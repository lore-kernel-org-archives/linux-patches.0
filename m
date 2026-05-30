Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E20430676E;
	Sat, 30 May 2026 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162243; cv=none; b=HdqcAouVDfo5F+9z0mHcf1tMPQjpifZB8G1KWiqcP4ryTRQv/N4PUetnBt0gkh/u6A2WQmS8Mnt+eIAC0/KaU22XwJNUVQiVObW7Gw34c12oOuQ2egvQyhN6ZZc7uoeEeRVW7mAJKTIb6FcXaxAlMHvm3+4xCU4iowDk1U7xW1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162243; c=relaxed/simple;
	bh=m8V1rQtLJWQSpdj+POmonJGon6YdPFsO+22ylF/klB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGdGbLhSUV8cNQoQR+uamb5+VxTsPa7JrRyKPjHd3IV5nnrdbWYUobkawICBCaKRNrav7juSfB7JOnbb/obTu+wfanvO0zhCBwVh9jC5QnhGM0AS1g+xG4lmF/DMp1jgDy0HYMquQ1mD1ETaZS+O4qwzpOK9N0eSgC6b1Y/Rnps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Flq8OWQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Flq8OWQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD0C1F00898;
	Sat, 30 May 2026 17:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162238;
	bh=Ysk59t3bVLD0+QMSKUYmZCKUi3+SoiL50NxjAInGXYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Flq8OWQHlkPU8gXuLaeQ+HjZjItAz2OzWpnTeHx0ht6+spn45k+hNyQMt0HosdIJC
	 XG7vsJsnpRa2g8Q9GEglGHQBGYBxmtBmiE3YH1ihgxg6ExLTFts9PrcC8Ck2pi+m+F
	 ITyRmVe2Vo11ezdP9S+35YgetnGqkmeYLoYJOF1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Benjamin Block <bblock@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 833/969] s390/debug: Reject zero-length input before trimming a newline
Date: Sat, 30 May 2026 18:05:57 +0200
Message-ID: <20260530160323.648931128@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9a94979ee4de5..65302aea77e85 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -1268,6 +1268,9 @@ static inline char *debug_get_user_string(const char __user *user_buf,
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



