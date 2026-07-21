Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ED746DFFD;
	Tue, 21 Jul 2026 19:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660520; cv=none; b=LHh/abhK84kBFzp9uszA+fZKTvGAavIZdMSbrTvqu1hBMQBmqvM/RuVkarHaklJUtIA8dHfN456NEW+DAJ9FYIUDr7bgEia4Etl5Y6D7SVep6ntjohr0IWxSmJz4BmLIJgyMY2L20NRg3BA7wGWZr+8xjhd7iDXFyoZ/ehCrhlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660520; c=relaxed/simple;
	bh=wZao2o0xSpEWYGcLF4bAv6jZDeIXcVTNSc9NONgQzXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyGSmFGI4+snPrXRqqdt7cVogRAvV06TEs2kwK+REwBxl80ymIAcEhjlHt21oqJhf+SKshac8t9Bqw/FiHLX2WPyZfu/Lq4USBpUQVBCc797R6EplCJAk3+6NnrQHInHGf06MiV67YW0TXu4AsCl6sdzHhgTmcMZ0ZRA6kZosdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aL6/dBgv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aL6/dBgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C94B1F00A3A;
	Tue, 21 Jul 2026 19:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660518;
	bh=RUkZN8IkxPBeOJQDMAzxBX9WQbLCjX9bU3bzGkty6YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aL6/dBgv3JP0+0PEnSE+dVejUuzh/GK8F1nTQ9a1giMjbvY8M3EauL9BkG8Xx526I
	 Ksd+/o6wfk/cTGKyz8KbwyRaHtbqjeBm63DpN5q1W2/BFLIBpDtOW0resSu0pQp+ze
	 WXIcNpHDkbOCsoYuV+wu94v8LM1H107ArEGCf964=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1008/2077] perf symbols: Bounds-check .gnu_debuglink section data
Date: Tue, 21 Jul 2026 17:11:21 +0200
Message-ID: <20260721152616.590725173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 792d270c3a70da..3b2e31367196c2 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1026,7 +1026,14 @@ int filename__read_debuglink(const char *filename, char *debuglink,
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



