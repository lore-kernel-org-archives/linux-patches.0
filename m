Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E92225A38;
	Tue, 17 Mar 2026 17:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767860; cv=none; b=ttDpFJv3x5VCGL8Ib3/SA7HaFLZ2hXo3xL1vQ3VjgZHiVMJxyVz5GtWT3majFmrsCjb/qtWhAlJsZ3k5cSsMo8YqjI7AUSf2oy4/N2hS8gCa7lVzUiFChwLxbayzICL1rk/QqmpBBX0odoj/KeQcepMJn36Kfgbq/lOnJ4jMOXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767860; c=relaxed/simple;
	bh=aVwqHn0dzhiSqSNuAGzZfXxgYTY/JT/vHNpWxvKAMug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9vKYx3PEai54Oqv8FPDNT9aer4UtYl69X1KxjRph/z2CIgBgN7hoJqcvOHImq/m3f7VG6P7S9df7EiDyj9exG6Xs/PGL7TaCCyWnRuobpsPubDrV1rhBHauKFZUnz7l+9t8cIJ15LjrDR2uYmTKiy/f5ILDLCwk4D8QcIeJwAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NU4k+RI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NU4k+RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9088AC4CEF7;
	Tue, 17 Mar 2026 17:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767860;
	bh=aVwqHn0dzhiSqSNuAGzZfXxgYTY/JT/vHNpWxvKAMug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NU4k+RIjNX+Z6qc9W0ByZ6OgI7c2bF26k08shDEf38/jHSRiAPqAwl6Ug4hRBv1O
	 blC+AnMZhMvFMQMsiFPd0zWreuc7ytGfNvfTuu36zhrpZ63XoymMfeZGWdVG8TmM6u
	 9xxn7rldRcQQggpPYaC46HkCt/PLBVeQWxpCaBCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 172/333] ceph: fix memory leaks in ceph_mdsc_build_path()
Date: Tue, 17 Mar 2026 17:33:21 +0100
Message-ID: <20260317163005.737083707@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2767,6 +2767,7 @@ retry:
 			if (ret < 0) {
 				dput(parent);
 				dput(cur);
+				__putname(path);
 				return ERR_PTR(ret);
 			}
 
@@ -2776,6 +2777,7 @@ retry:
 				if (len < 0) {
 					dput(parent);
 					dput(cur);
+					__putname(path);
 					return ERR_PTR(len);
 				}
 			}
@@ -2812,6 +2814,7 @@ retry:
 		 * cannot ever succeed.  Creating paths that long is
 		 * possible with Ceph, but Linux cannot use them.
 		 */
+		__putname(path);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 


