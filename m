Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D7B3B6349;
	Mon, 23 Mar 2026 15:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278413; cv=none; b=MDPGseHpG/oAsNHuYH8dQ3xyyknfptVp1wVHYAu2j+l1UNWpH1jaQik4KkQjKi9cmfCK/4lM05zLB9eYihkB66GtCNp70XIC+922NZlz9mLzIo+gmVYAd5+rmKobvlZjXIPl7povFxONjH/1ntt25Drv2Ye12H08DZfFPSpuHXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278413; c=relaxed/simple;
	bh=22ol1KI28loqTevb176t2CvH7K/TXGuHAPj1L/CytZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKfyvf5rykWd1PRbahn0LefDClHfulLlVEjaZ8yhUyUzc/aVghcVvDl9DegofPQR8dPWuYOpUqyV8QtxwJOM3e31VmaxHwZDfASf0Zb7sI7vV0KnICTFNWAYMcbBE1KCV0p1TAeSKBz/QJk/w4sgIKn/IZaOpbs+9SHDwr+BT1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Db75/75j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Db75/75j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4F9C2BCB1;
	Mon, 23 Mar 2026 15:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278413;
	bh=22ol1KI28loqTevb176t2CvH7K/TXGuHAPj1L/CytZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Db75/75jdJaP9xh8Ohjq9xhjr1wzXsrwLKcLlY2vb1orBaVtg7IYLi5JiCzj6+1Le
	 AM0YURyxpn1wBHPUYr4sqbyendNJBV5kbKb+TFfkA/YB9ZASRZ4f4JVvkoBc7lDSZ4
	 yUMBR2dziTt3xUxAkrtyHas3DU9H5v2+Zk9gsVVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 300/567] ceph: fix memory leaks in ceph_mdsc_build_path()
Date: Mon, 23 Mar 2026 14:43:40 +0100
Message-ID: <20260323134541.240896562@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2672,6 +2672,7 @@ retry:
 			if (ret < 0) {
 				dput(parent);
 				dput(cur);
+				__putname(path);
 				return ERR_PTR(ret);
 			}
 
@@ -2681,6 +2682,7 @@ retry:
 				if (len < 0) {
 					dput(parent);
 					dput(cur);
+					__putname(path);
 					return ERR_PTR(len);
 				}
 			}
@@ -2717,6 +2719,7 @@ retry:
 		 * cannot ever succeed.  Creating paths that long is
 		 * possible with Ceph, but Linux cannot use them.
 		 */
+		__putname(path);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 


