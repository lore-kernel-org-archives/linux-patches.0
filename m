Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC5F3B9D97;
	Tue, 21 Jul 2026 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657301; cv=none; b=Edp64kBfDe3mJCAhSyaqoHnB1ajRZcuGHaBtgML729jjXoMPom4Fy+MRMMb3ZemljsMoQZLLUmIGLKVwyKVLY4ncy99xdUz59YFYkVpJZJOnIsM27R5xibf/rXVKORhntm80s7rPFp9sWGLLqQjybI0iEl9x6LtN7JWMc7xIcqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657301; c=relaxed/simple;
	bh=jWY3vW6tDKcswLyRgzxfRFQ6rQ6rSSS4YmXMRX2RL+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WR+RDtuWmfuf/ZY9P2SMCSAFQp3KoCTIzuz9sjiZ6Z8s/NJ9OZdkM4wOlyNRkV5tk6GE8WPuRaiTkahBeCdFfyibuI7Xo4llwwy93KG2s8OMfAOwHotklIQgY7Q5lXCGmFq/UljlYROxm2vLIBW41XzvNMHJ3mrf9rQOTLp3tx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0cndbTq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0cndbTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B711F00A3A;
	Tue, 21 Jul 2026 18:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657293;
	bh=+nkP++TOSRenYsXlB+FsDr97sI6veFEvNpOhk3Juy1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0cndbTqeylM2xm8c/SkwzhTT34hxUCfeTDNVEpo1SkCRn8hI5X8QQOiZ0Fzl8hAz
	 jl+8dT39/xv7DQePKloXtjewZ8F+Z1G2bVNs+RzaLgujO3L1OxqjHQ9jteLZUwvqLE
	 PJBcHs/2vorn873tIamdrQZsj00P3IK6H5pkA0gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0711/1611] perf symbols: Bounds-check .gnu_debuglink section data
Date: Tue, 21 Jul 2026 17:13:47 +0200
Message-ID: <20260721152531.374996033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 9c74f0aab398cb32ab250401f323c0fdc9a3a496 ]

filename__read_debuglink() copies .gnu_debuglink section data into a
caller-provided buffer via:

    strncpy(debuglink, data->d_buf, size);

where size is PATH_MAX.  If the ELF section is smaller than size and
lacks a null terminator, strncpy reads past data->d_buf into adjacent
memory.  A malformed ELF file can trigger this, potentially causing a
segfault or leaking heap data.

Additionally, strncpy does not guarantee null termination when the
source fills the buffer.

Replace with an explicit memcpy bounded by both the output buffer
size and the actual section data size (data->d_size), followed by
explicit null termination.

Fixes: e5a1845fc0aeca85 ("perf symbols: Split out util/symbol-elf.c")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 0de9439ae2dcd7..2b91255123c340 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1025,7 +1025,14 @@ int filename__read_debuglink(const char *filename, char *debuglink,
 		goto out_elf_end;
 
 	/* the start of this section is a zero-terminated string */
-	strncpy(debuglink, data->d_buf, size);
+	if (data->d_size > 0) {
+		size_t len = min(size - 1, data->d_size);
+
+		memcpy(debuglink, data->d_buf, len);
+		debuglink[len] = '\0';
+	} else {
+		debuglink[0] = '\0';
+	}
 
 	err = 0;
 
-- 
2.53.0



