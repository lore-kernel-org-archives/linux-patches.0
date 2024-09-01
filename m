Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A722A1B8;
	Sun,  1 Sep 2024 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209820; cv=none; b=a1FoZ8bZVZX3c6Xa9DhdKQ3MhAAoYH5b80s+qMR0vVQtIl2qWlstdd2gScqi5HkfsJy4Ikg/hOe/x0Ux9h/r1foqRMyuEPRgkPPFFnUOe9/RlcDQ+Bjr0OsIXVL4ST1f3mhD4J8hpyU39c4237c1IDl0JYVUKpmJmhlizPNr7Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209820; c=relaxed/simple;
	bh=wV/xCnAquXbf+mbsBwYN2USXZ1jCGSYim6tQ5gNqNwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzYplR1k7BB/1UCSTXfrCa68oDtRYMSrXw95gmXa43sn6VVVMgEtirOV9uJQEkAtaV/JIg/uw/5UaNtiVjEAZpEJRr6hak23zORBh27Q5QQ6W8Q289C1/Cc5lBpT9BtMcAyHytuFT50cWqBhfp9z3b2NDqUF19vAxbXxu9XEQy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMbh2QcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMbh2QcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0D9C4CEC3;
	Sun,  1 Sep 2024 16:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209820;
	bh=wV/xCnAquXbf+mbsBwYN2USXZ1jCGSYim6tQ5gNqNwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMbh2QcK93uHzKEQDUnNDvb6rCLigxgNAgnhiGJ8rnsEOoaHlAv8olXTq68ZmNwfG
	 K73FSsA9FA7ue3IKyuExa7hMPd/evZVPDghGFAz3LI4RLtL4o7w7S65ZmEOyW9i0xf
	 rAVMG/VOwKGAWJoAaXCx7fkdqOWb8EFCyMY8wB60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 5.10 134/151] ovl: do not fail because of O_NOATIME
Date: Sun,  1 Sep 2024 18:18:14 +0200
Message-ID: <20240901160819.146836718@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit b6650dab404c701d7fe08a108b746542a934da84 upstream.

In case the file cannot be opened with O_NOATIME because of lack of
capabilities, then clear O_NOATIME instead of failing.

Remove WARN_ON(), since it would now trigger if O_NOATIME was cleared.
Noticed by Amir Goldstein.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/file.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -53,9 +53,10 @@ static struct file *ovl_open_realfile(co
 	err = inode_permission(realinode, MAY_OPEN | acc_mode);
 	if (err) {
 		realfile = ERR_PTR(err);
-	} else if (!inode_owner_or_capable(realinode)) {
-		realfile = ERR_PTR(-EPERM);
 	} else {
+		if (!inode_owner_or_capable(realinode))
+			flags &= ~O_NOATIME;
+
 		realfile = open_with_fake_path(&file->f_path, flags, realinode,
 					       current_cred());
 	}
@@ -75,12 +76,6 @@ static int ovl_change_flags(struct file
 	struct inode *inode = file_inode(file);
 	int err;
 
-	flags |= OVL_OPEN_FLAGS;
-
-	/* If some flag changed that cannot be changed then something's amiss */
-	if (WARN_ON((file->f_flags ^ flags) & ~OVL_SETFL_MASK))
-		return -EIO;
-
 	flags &= OVL_SETFL_MASK;
 
 	if (((flags ^ file->f_flags) & O_APPEND) && IS_APPEND(inode))


