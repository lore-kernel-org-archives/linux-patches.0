Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9857E1FB3;
	Tue, 27 May 2025 17:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368081; cv=none; b=hWaQOqRz6TJHRuX3VMNzgFzjnEQZYJMube28nqc8j/WJlQhRMP5hSQ2dTF87mHJiUTOXg4UU4OWX8aDBa4w6JJ8XA4Z59PobpZDj7XwVfC52eVlqbZMuxPhVKNGp8CtGoL0UP0O5ZgsyMUdbZc8TuAgcX5db0oqbct8uaDUGSyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368081; c=relaxed/simple;
	bh=hlRdgNyZROehNFd4OHq4LB8Jom4jn0tgh0EBHNVLqTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/VO9zoN3+r/kK3Kai9DiL36lYvKMSmp4F3e8Co+umzGnAWjIyZWaUusdWzSZDnX1ruZgcnJ/jvQduW8h71R/dNODpyEBs0sNWBuTJRL8LFLa61R3/rC64uXsN1VjTzfyum77iidG3oNeyWScoFUma0Ov30LeReYFrCOBsyOd4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJjSm5ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJjSm5ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05252C4CEE9;
	Tue, 27 May 2025 17:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368081;
	bh=hlRdgNyZROehNFd4OHq4LB8Jom4jn0tgh0EBHNVLqTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJjSm5mlBTQgD604iKtVEVf7BnrZXhN2s0c/WDW1mbdEdU9KzpSOdGLtIAiZgZ92h
	 EGPrWaqj63l4m2aCDsSEshfyC8JLVhU7movky4sURCyILSyEKswP/32q9CASrQeOKB
	 e45ezh1VqFmFRrtN0F1oLUrm+v0L1ScqDv4sdll4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Quentin Monnet <qmo@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 593/783] bpftool: Fix readlink usage in get_fd_type
Date: Tue, 27 May 2025 18:26:30 +0200
Message-ID: <20250527162537.278934581@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index b921231d602e4..ecfa790adc13f 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -461,10 +461,11 @@ int get_fd_type(int fd)
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



