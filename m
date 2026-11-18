Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035421;
	b=ChibTpRN29JAaKVGTHOWY5bymYPUasPnGoJDcFxCHKM1o1HU0+oLhibloYqOLksX17Xw
	 A9Ad0B6eAFoeWZns80ShSivPPsCNlINhlwNcK3io+KkTF9rsqqQrYieAtQQIMTbqCAZqr
	 6Vvyye5QevRv8UJuopaj75gx3OEP5pu4FLcEYWjxBzivwQDeJaEL8aMsxpNybMVmDSg2J
	 tlEYxtemIujAvG5LvwvKIoxc6shAA5zA+I29VMA/BnZXP19IbZ0Z9XDTbLQttAfPEoyav
	 hx9x8E7TOprp6WX4EpMRZOfbqG371lv+gWYLia16J4aoVrZ6WzHMzQnftuzo0K1Dx7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UIh8x1Ecng0DhczWCFzveut1E7Br+HEuT8KqE400xbI=;
	b=TPML8C2pR0YchZL6Oc+lpE8KuHYSCrbczDaWi2bS+2YlXpezcum0pBPZei8CKwGbp0tq
	 cowUEZFNwGTCnRJ4+Lf1ZFcGEvBPxSfY0I2DEyf4jtKe7tb3cN5EtPFc/hXFkyQGukg7Y
	 Dggh9KFZU9Zb/F57jLq7j/WFpyy/IasqK8b8XUHJAsGTH5Fte1neQ0rNX2JSy55fGNVa9
	 9t9fh3VLk226H5sGGX2FqkKpmufcVJMh5CXNwfUYhKSLLAdrT2vbA5sYB9G5k6FEDMBYl
	 GdmMDVGScXoC89MOzLnshCRxY86bqmErxwCKMp56wznsLgdVB7es0NQZrwH9LqN3PMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGWanvy2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58345606A32C;
	Wed, 18 Nov 2026 20:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGWanvy2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67211F000C4;
	Wed, 18 Nov 2026 20:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035421;
	bh=UIh8x1Ecng0DhczWCFzveut1E7Br+HEuT8KqE400xbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGWanvy2WeiE5vliYrpLh44Qn0eZEormpboiRFvLkhI79YjHCeYncSR2fVxDSRysh
	 aVm5n0d4yKt94/YQvVt/oSQL7vZt57AXvymuFiU4d/R7X1ECDq10BkTogIb9As8PXV
	 pTKwFO3I9J2lFRUZ+LCbZVivZAmLttLWREquw4pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.6 0649/3318] ovl: fix a torn path in ovl_get_redirect()
Date: Wed, 18 Nov 2026 15:21:11 +0100
Message-ID: <20261118150337.475137153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 2001cd7ca5560198131e46c6ca3c3472b06145c2 upstream.

A hard link of a metacopy file that races with a rename of an ancestor
stores a redirect to the wrong lower file.

Each component of an absolute redirect must be the name that a dentry
has in the parent that the walk continues with. ovl_get_redirect()
copies the name under d_lock and calls dget_parent() after the unlock,
and the callers for a hard link hold no lock that stops a rename across
directories. A rename between the two steps combines the old name with
the new parent.

With delays in ovl_get_redirect(), an unprivileged user hard-linked a
metacopy file while renaming its ancestor to another directory, the
stored redirect named another lower path, and after a remount the file
showed the data of a root-only file.

Fix this by taking the parent first and checking it again under d_lock.

Fixes: e04527fefba6 ("ovl: fix dentry leak in ovl_get_redirect")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -975,7 +975,19 @@ static char *ovl_get_redirect(struct den
 		const char *name;
 		int thislen;
 
+		/*
+		 * A rename can move d to another directory at any time.  Hold
+		 * d_lock to copy the name that d has in this very parent, or
+		 * else the path mixes the old name with the new parent.
+		 */
+		tmp = dget_parent(d);
 		spin_lock(&d->d_lock);
+		if (unlikely(tmp != d->d_parent)) {
+			spin_unlock(&d->d_lock);
+			dput(tmp);
+			continue;
+		}
+
 		name = ovl_dentry_get_redirect(d);
 		if (name) {
 			thislen = strlen(name);
@@ -988,13 +1000,13 @@ static char *ovl_get_redirect(struct den
 		if (thislen + (name[0] != '/') > buflen) {
 			ret = ERR_PTR(-EXDEV);
 			spin_unlock(&d->d_lock);
+			dput(tmp);
 			goto out_put;
 		}
 
 		buflen -= thislen;
 		memcpy(&buf[buflen], name, thislen);
 		spin_unlock(&d->d_lock);
-		tmp = dget_parent(d);
 
 		dput(d);
 		d = tmp;


