Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2E0823DD;
	Mon, 23 Mar 2026 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275528; cv=none; b=ljoknC2fk/Z1os2dn/bhAihRl3T9TWY7cZg25A+0EGuy5J62ugM/DYQqW5RVNgA3acoFRZcjJeMvrdipjeNJqweAPNVxy6hZNmdYUoYbKtcjYHnY5KJBsOaI1xi0jpVDY5CBuHFmFbKYOay/5lcM8KsSvh3dRyeaGEV29cOKZlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275528; c=relaxed/simple;
	bh=+ztgXG86+k47y78ecqsXNTD2pcLkuP00acs6v88H+G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afprOtYd9OsXApEpZhcyS1JJy2wjJZm52llnC96upOBIYt5Mi20zp9cu2rnmLQQZuOLIu3p7nf6cZ05C+MGFii7LrpNsCM2QeqdI8Bj/X36GAJMBfUlUOaRFt1BRe1gbVdnheUt234yGpOxgFI+pFsVj978CdgRCQwS1G1yETzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eia2QJeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eia2QJeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B461EC2BCB1;
	Mon, 23 Mar 2026 14:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275528;
	bh=+ztgXG86+k47y78ecqsXNTD2pcLkuP00acs6v88H+G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eia2QJeDYWA6YuJ0jI+cQUtT35pEFNQNK1eg7GGBdtcx0KeLdwQlLOLdP7rMECTC4
	 FxdzTJeo3KhNA2EjelDVBR4rDFbLKKwA3W9MFosmQ09LDK8gUE+h+/G8sxvElcaRIu
	 iB1/pVB3vCmo7nlKhZ8BM/gOZaXNcNeRa4FOc3qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 132/460] ceph: fix memory leaks in ceph_mdsc_build_path()
Date: Mon, 23 Mar 2026 14:42:08 +0100
Message-ID: <20260323134529.851583585@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

commit 040d159a45ded7f33201421a81df0aa2a86e5a0b upstream.

Add __putname() calls to error code paths that did not free the "path"
pointer obtained by __getname().  If ownership of this pointer is not
passed to the caller via path_info.path, the function must free it
before returning.

Cc: stable@vger.kernel.org
Fixes: 3fd945a79e14 ("ceph: encode encrypted name in ceph_mdsc_build_path and dentry release")
Fixes: 550f7ca98ee0 ("ceph: give up on paths longer than PATH_MAX")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2766,6 +2766,7 @@ retry:
 			if (ret < 0) {
 				dput(parent);
 				dput(cur);
+				__putname(path);
 				return ERR_PTR(ret);
 			}
 
@@ -2775,6 +2776,7 @@ retry:
 				if (len < 0) {
 					dput(parent);
 					dput(cur);
+					__putname(path);
 					return ERR_PTR(len);
 				}
 			}
@@ -2811,6 +2813,7 @@ retry:
 		 * cannot ever succeed.  Creating paths that long is
 		 * possible with Ceph, but Linux cannot use them.
 		 */
+		__putname(path);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 


