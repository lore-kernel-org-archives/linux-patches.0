Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1771DFE27;
	Wed,  6 Nov 2024 12:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897068; cv=none; b=eBGV/8UE5G0EtCRwQDa3oNeZp+qWrtbNZ9ClnVcgcKaJgmK1gaCweiDqCWnLY2nAvA8i2TtPfsq4DCwClveM3Y8loTb5gLJj9TLZPOwsCkJvGcH1s5gg1AiXmlaCBatvEy4CKGPaqJFLVGy5CsXUWns9nEdl5oFspbgdIyozD8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897068; c=relaxed/simple;
	bh=gFWMEyW3yQHHehkm7IRgOcis9kEbPfSR+Q9guGCepgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Od+QLz8aCMCpk5nvh89IWFLdqLmbnuoXITvf05/h5civMx8P7M2AlD6yFHRTZusqphEFc85jKuNPYGF1KuQcMF0A0g1fEl9ti4bbadCz+w5Y0GwfUPNE+DVhn6IqGS7/Y7uEaVlSG2e2dfZPAUUw0cxRjnIIj51Ij5csQE6GcoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqEuSyNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqEuSyNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61916C4CED3;
	Wed,  6 Nov 2024 12:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897067;
	bh=gFWMEyW3yQHHehkm7IRgOcis9kEbPfSR+Q9guGCepgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqEuSyNwVYDVFxjerd8m41wovG/9nooD1TDjOBe9UAMd+Da50qy6psQUjURZs+JI+
	 4xCnrZ/VQGsdPBxL2gEP7Ju4b9o3QEHjUasfjwyLIyYTE6E6lh4B5EbzFrMqzdhYfS
	 sFkvLIrn982I1qA9aw6ncMeHXwljygoC/S/phimM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bc7ca0ae4591cb2550f9@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/126] fs/ntfs3: Fix possible deadlock in mi_read
Date: Wed,  6 Nov 2024 13:04:16 +0100
Message-ID: <20241106120307.586104402@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 03b097099eef255fbf85ea6a786ae3c91b11f041 ]

Mutex lock with another subclass used in ni_lock_dir().

Reported-by: syzbot+bc7ca0ae4591cb2550f9@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index a9549e73081fb..7cad1bc2b314f 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -79,7 +79,7 @@ static struct dentry *ntfs_lookup(struct inode *dir, struct dentry *dentry,
 		if (err < 0)
 			inode = ERR_PTR(err);
 		else {
-			ni_lock(ni);
+			ni_lock_dir(ni);
 			inode = dir_search_u(dir, uni, NULL);
 			ni_unlock(ni);
 		}
-- 
2.43.0



