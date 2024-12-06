Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E0B53A7;
	Fri,  6 Dec 2024 15:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498686; cv=none; b=nEgYK3QHJRBaH1NvQRaQN1CN/gq/2o+v32HLC4SWBFwbEz91Uls3NJuBBTOfiQvQjYrvSxo0ag7xdOXkUJ2cyaDdyQFeZOqOCeiYg7EfqBpTOMFiXC8xRKCvBG8SKPvmDFApRQDeBk2v6u7tv6/iEdI7snILrAXtJJUnNOBhuiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498686; c=relaxed/simple;
	bh=a8Sa8JxBUI75la530swEsLRShnSZdCjhP05CLKXm2VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDh27Ae3xG6iLoAPbNJIAaLnO4P865RsTgg8jpqI/Gj/3afwhRFyiH03A82RlXU6dzCPOPYLaE78xt8WzJQ7vdiaw9HTDmQwCtIHeSzVWkN6hqkPb25iKUNVtUMeLw/Z3qCpCsgntddyvBExs2luqSNHCmgCvfRKzh05LEOrliE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJPxI2LD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJPxI2LD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A348C4CED1;
	Fri,  6 Dec 2024 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498686;
	bh=a8Sa8JxBUI75la530swEsLRShnSZdCjhP05CLKXm2VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJPxI2LDxF6E3O9DovNXMiYQjToSMpFsRJ5Nod+J5aAo6Lp6hKT23iKUt1zYzCsc2
	 ahjdEPyTp5tjrk2iqqWJIxXnv4PnXhdDvWdA3/e2fey1BTXAhPfHvNktKR3Y3aWzLp
	 C3K3JTT64omxGuF07glN+xAhsUrF08uUg32BwmLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.6 626/676] ovl: Filter invalid inodes with missing lookup function
Date: Fri,  6 Dec 2024 15:37:25 +0100
Message-ID: <20241206143717.819581279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit c8b359dddb418c60df1a69beea01d1b3322bfe83 upstream.

Add a check to the ovl_dentry_weird() function to prevent the
processing of directory inodes that lack the lookup function.
This is important because such inodes can cause errors in overlayfs
when passed to the lowerstack.

Reported-by: syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=a8c9d476508bd14a90e5
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/linux-unionfs/CAJfpegvx-oS9XGuwpJx=Xe28_jzWx5eRo1y900_ZzWY+=gGzUg@mail.gmail.com/
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -171,6 +171,9 @@ void ovl_dentry_init_flags(struct dentry
 
 bool ovl_dentry_weird(struct dentry *dentry)
 {
+	if (!d_can_lookup(dentry) && !d_is_file(dentry) && !d_is_symlink(dentry))
+		return true;
+
 	return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
 				  DCACHE_MANAGE_TRANSIT |
 				  DCACHE_OP_HASH |


