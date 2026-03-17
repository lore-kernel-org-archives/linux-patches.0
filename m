Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3E93F23DD;
	Tue, 17 Mar 2026 16:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766124; cv=none; b=lfiNqtPnpKPAcm56WfqI4MC2I+XcKyZ21LlycrrUD+++1vV6/q923AhTIO+6Xrn7uAdK/cqnCBwJ899X7tVRjHUWZsmT/y05YRb+9CkzsVrwmh8BJKeSbN/FcMjYfVgXjv84mew1+orxqZfIEKEjeBf91LRmaiuW60xU6mO51ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766124; c=relaxed/simple;
	bh=Vtn1t1w8h2KiI/jNFaK93AhcHUERVKk+MdjpAIKKgOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ol+fC+2ZulDWDLWY9r9GYeZx4S5wg6xcp5pAzB5ERaqYRQ+uDUz6wq1H23lgPXj06ShqCk/KzKG/ApYi0Ne+Lv4AMxf6684Sxf3A3LHcoWq7f1v8ebBR75qVwfo7DqFuGApW2fzR22L9WjHv8AC76L0L+r4sApRZeh27uNV4i/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeJSVpdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeJSVpdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCA6C4CEF7;
	Tue, 17 Mar 2026 16:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766124;
	bh=Vtn1t1w8h2KiI/jNFaK93AhcHUERVKk+MdjpAIKKgOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeJSVpdoJoCJ7a7fuZ40NsUug9qp4W+hbYLCd3YtBMaTjdyZLgInlYYLXJCjpiF2s
	 ZEF3COukVaqVLprebnbK2YoRQp8AU6lBUZm5YAk9Uh5PdfAAsgVi48jmQwE5IZmP66
	 sx9Uet1Oi/FyY32hyqZxi1xWF0vnXYEoeNJHXRy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.19 176/378] ceph: fix memory leaks in ceph_mdsc_build_path()
Date: Tue, 17 Mar 2026 17:32:13 +0100
Message-ID: <20260317163013.482038875@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2768,6 +2768,7 @@ retry:
 			if (ret < 0) {
 				dput(parent);
 				dput(cur);
+				__putname(path);
 				return ERR_PTR(ret);
 			}
 
@@ -2777,6 +2778,7 @@ retry:
 				if (len < 0) {
 					dput(parent);
 					dput(cur);
+					__putname(path);
 					return ERR_PTR(len);
 				}
 			}
@@ -2813,6 +2815,7 @@ retry:
 		 * cannot ever succeed.  Creating paths that long is
 		 * possible with Ceph, but Linux cannot use them.
 		 */
+		__putname(path);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 


