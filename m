Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D4622F14C;
	Mon,  2 Jun 2025 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877318; cv=none; b=tQreqStT4hbk3cmP9b85fOfk2xqoW6ZaGiUgm7zJP1y0Zg3v2YXFIOo2xMUBiFwPDjOAkEWdYtt2pNTfWLXwojHOKXa5K0b86AnmirSs1zszA3IG9J4flY8AIEfN1WCZ0udv9nvzB8SJAE1oTDQvJYB9n/5MDgHA/FA4uEOiWVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877318; c=relaxed/simple;
	bh=Er6BgJk3TmK4wX7nHR6v6hHBfE+CPNint4bpQp30XYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuWRm7OlsrJ8+ltb1oXaeQMZp/1mXV9xMVAukXMrTE9sHGfqtO1Q5xdlDW1v57HyNGrWBdtIlA0f4isg36dpu0/t7LqdijtM73lG+5UtGNNg+SKGpmgDrOUp10HMaFm8phVP/66tc9DwchSpGX70koWyHorGt7w8XjZSmKz5JSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gVUT5AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gVUT5AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C34EC4CEEB;
	Mon,  2 Jun 2025 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877318;
	bh=Er6BgJk3TmK4wX7nHR6v6hHBfE+CPNint4bpQp30XYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gVUT5ATA/26TvUr4SNeCPbTMHaHiG8raIiSpHyWO3nVgLaTA6FRtyoZcyXQnr0HX
	 eo3bOPj3/p6nXgbfU6zOTJxWUFs88V31Z+dTzmriimrfGGR237MZKBAYjcO+qvf3/O
	 JODlaGYTsyeguSOlLA4cb9GT4wYAX/Pcu85ys/to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/325] bpftool: Fix readlink usage in get_fd_type
Date: Mon,  2 Jun 2025 15:48:05 +0200
Message-ID: <20250602134328.288274731@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit 0053f7d39d491b6138d7c526876d13885cbb65f1 ]

The `readlink(path, buf, sizeof(buf))` call reads at most sizeof(buf)
bytes and *does not* append null-terminator to buf. With respect to
that, fix two pieces in get_fd_type:

1. Change the truncation check to contain sizeof(buf) rather than
   sizeof(path).
2. Append null-terminator to buf.

Reported by Coverity.

Signed-off-by: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20250129071857.75182-1-vmalik@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index db02b000fbebd..eea00bc15b5cc 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -384,10 +384,11 @@ int get_fd_type(int fd)
 		p_err("can't read link type: %s", strerror(errno));
 		return -1;
 	}
-	if (n == sizeof(path)) {
+	if (n == sizeof(buf)) {
 		p_err("can't read link type: path too long!");
 		return -1;
 	}
+	buf[n] = '\0';
 
 	if (strstr(buf, "bpf-map"))
 		return BPF_OBJ_MAP;
-- 
2.39.5



