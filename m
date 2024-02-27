Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B72278B61;
	Tue, 27 Feb 2024 14:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043321; cv=none; b=BPVFZKhw3YoN9lhAyXkAb0KDpcn52iGbuwUBxlQJ3NtEKV9NYAIoPsEF2aoaFYvrs1hNILjkKjSxwbrdRQ4lYnfdapK+lr39FGS63XqTcigqGi8aNQn2eMBA8D/3qwG9KcQOEMxVWp/KIzk+2oEjR1OuiOOi3iP8h2UHmVoHI30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043321; c=relaxed/simple;
	bh=s80ukngunMa83007O6KS9Av1Ra92CvWDItZ3memas0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+sKLlFYCebr+qTR/JN7ov3eDsi2a5z87bfz1ngYV/7WAmgztMk477cuM3y9p5tc1wE2qajpxJyMvLJBThk6GTyukFktys1nWfueFYQLc8fPy7zXR06cm3aGW5Cvc8JFWNjgQ5Bcuy5fPxCq1EY8IeoXKBf/PPfen/mHMBvJ4kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d//jhh6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d//jhh6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02ECC433F1;
	Tue, 27 Feb 2024 14:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043321;
	bh=s80ukngunMa83007O6KS9Av1Ra92CvWDItZ3memas0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d//jhh6YeP+ZNjiHc7wz6L5SDsf+6NeMlA+V0/mB23VVq7ErhlICCZtTuFypcdRzJ
	 SChjZfvE+tvROdIGgyM0Qxq5yc1Nvu9x95F6WcLk6kRLVQFR1vKRIn3Y/8FTZWq89h
	 nkZEb/LtEqXIXYP4YzsXLpeo7gdkXp+fZJmet2C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+65e940cfb8f99a97aca7@syzkaller.appspotmail.com
Subject: [PATCH 6.1 065/195] fs/ntfs3: Fix oob in ntfs_listxattr
Date: Tue, 27 Feb 2024 14:25:26 +0100
Message-ID: <20240227131612.649593309@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 731ab1f9828800df871c5a7ab9ffe965317d3f15 ]

The length of name cannot exceed the space occupied by ea.

Reported-and-tested-by: syzbot+65e940cfb8f99a97aca7@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index df15e00c2a3a0..d98cf7b382bcc 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -217,6 +217,9 @@ static ssize_t ntfs_list_ea(struct ntfs_inode *ni, char *buffer,
 		if (!ea->name_len)
 			break;
 
+		if (ea->name_len > ea_size)
+			break;
+
 		if (buffer) {
 			/* Check if we can use field ea->name */
 			if (off + ea_size > size)
-- 
2.43.0



