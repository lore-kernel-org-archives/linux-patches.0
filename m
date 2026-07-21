Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8A446D56D;
	Tue, 21 Jul 2026 20:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664385; cv=none; b=nes0HBc/tvXbUz8LLo6Hiu2ioPvGnstpkRkU4bqGmGYZerAq2RnaQ6QLiWS2QO7PtEtn6UBCVsklY+MtJ/+EOtAUZ6uFDwSLU4cwmeBxwQ2QIjTfc08obRGkeG1d6wVnn0VjocH4uHychwP5B5svBpeHCG1hM0Irpkvz7aGSbPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664385; c=relaxed/simple;
	bh=2JfjCmeg2EM6bF/UCubPSwsGMezmtwvmREU4GFn+7KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVBKfGeaE+fjaPt1jIygtK9bA5ZM5jPYKz5DEJB9mxz6GI8r8RtUtyF2uj9stDpOJyjgJNWCyBllr9aWAeFYZGKAQv7xG+MsQewuOOCD2IUQP0ErR9TW76ejxonMAB34u10eG+xmZuDhwo9gW5OGidK9PA7KLCxbchDHvHdArc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiAZrsYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiAZrsYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60E41F000E9;
	Tue, 21 Jul 2026 20:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664384;
	bh=Tnb8ONrA0ConVCLDvH/KaW46HN0KRnXUkzTSeEuVnfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XiAZrsYTc/Mfjgcgn3GU+ErmG7T0MmN8p7vq1D6H0rz+MA+55oPJFnUUsCuGTwi/g
	 ZbebsHbS7xX7EFT3LUa3cjkZ6QG1DEXDJBPbLvTuXglx16iNx1O1YiW8AinYV1yA6K
	 Kll/rOfY5EVOPFKBLrCifhxzfN1od4bt8yLTR+X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1180/1276] ksmbd_vfs_rename(): vfs_path_parent_lookup() accepts ERR_PTR() as name
Date: Tue, 21 Jul 2026 17:27:03 +0200
Message-ID: <20260721152512.440368355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit ba33ac100d3feb1efb43b32e63cc0c6430936aa3 ]

no need to check in the caller

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 1c8951963d8e ("ksmbd: fix path resolution in ksmbd_vfs_kern_path_create")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -715,10 +715,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *
 		return -ENOMEM;
 
 	to = getname_kernel(newname);
-	if (IS_ERR(to)) {
-		err = PTR_ERR(to);
-		goto revert_fsids;
-	}
 
 retry:
 	err = vfs_path_parent_lookup(to, lookup_flags | LOOKUP_BENEATH,
@@ -819,7 +815,6 @@ out2:
 	}
 out1:
 	putname(to);
-revert_fsids:
 	ksmbd_revert_fsids(work);
 	return err;
 }


