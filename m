Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8023D32AAA0;
	Thu, 28 May 2026 20:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000464; cv=none; b=DJXsqugiUY4KvserjuPJ354zGTxRXCdfE400KFvmBc3s5H2Tvj8CloMOupMn+QK9R+Di7WMrAdDE9TrDx+YNtLRHAnpBe2iQots28wVQj7YttNHfQTiq5nxMd27l8AoGfAc4DkBdETH75X4hzYrsgLpyMMe8vFR022q5LPVzwuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000464; c=relaxed/simple;
	bh=QDTdyavbmeurIK5jed/hT5qhweOaaWPTjH0Q4qqLuFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8Z5pCydG3AdmFJ+6dYTYk2Wewnu6wzuRp0V+JEkF9jwvmnpIhNgiPbjUM/oHXvBPFRUCLNNnuUOqvr0MG6CrZApV+vaoVn2YNrww7eDKPbDOR1JMDkYkmKGVxhf2hyXik3Q7UMPwgxM3/9te1cqdoDMpWsKP+Sibe30CXqZ/yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRYQ6ilA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRYQ6ilA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685341F000E9;
	Thu, 28 May 2026 20:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000462;
	bh=fWEyIFPQSTsnmE4B2FYqI5+OOFYQViQQ0xZAngAgUE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CRYQ6ilAtlflH3XrQMKtDqx8jGMQ+wHqkaWiY5H0oN0UVDApAqWn7HFxtnVIH/re0
	 nIw/QA5t1As+1DcTsNAmOA3Uuvk2Unr5uh/0WjqfyoTBhY/kGKeEGrR9JzL+rSuQcW
	 CS7pq9PkGApthPnkJ7tM0Bg2KxNHaQqZra+fAeoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/272] s390/debug: Reject zero-length input before trimming a newline
Date: Thu, 28 May 2026 21:46:21 +0200
Message-ID: <20260528194629.586826251@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit c366a7b5ed7564e41345c380285bd3f6cb98971b ]

debug_get_user_string() copies the userspace buffer into a newly
allocated NUL-terminated buffer and then unconditionally looks at
buffer[user_len - 1] to strip a trailing newline.

A zero-length write reaches this helper unchanged, so the newline trim
reads before the start of the allocated buffer.

Reject empty writes before accessing the last input byte.

Fixes: 66a464dbc8e0 ("[PATCH] s390: debug feature changes")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Tested-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20260417073530.96002-1-pengpeng@iscas.ac.cn
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/debug.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index e4b324dcfe0d3..16bb554a07fef 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -1256,6 +1256,9 @@ static inline char *debug_get_user_string(const char __user *user_buf,
 {
 	char *buffer;
 
+	if (!user_len)
+		return ERR_PTR(-EINVAL);
+
 	buffer = kmalloc(user_len + 1, GFP_KERNEL);
 	if (!buffer)
 		return ERR_PTR(-ENOMEM);
-- 
2.53.0



