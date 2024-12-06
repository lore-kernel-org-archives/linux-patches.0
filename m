Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD731494D9;
	Fri,  6 Dec 2024 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496174; cv=none; b=nUBcwNDLiRJSZ+RNIBM1Yp+kMCgBZvqi9MXCwNsVRC/UOOIOoLeFjc0aQQqlbL1di1d/vbtyEhIIawjbMGRLFHmuIMnbiERdCH5UoYpNV/nzAo5Ghs0EY62qzoBMlswmzBoKW4IQvV3dx8N6JFgJmRtKwzC7lEv5XQjP5ta+3UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496174; c=relaxed/simple;
	bh=f+DKir8Zf7tH71vZpn4tsMwPRqk8wsSknTWaNm8ZuBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0ekVfIV91keXfXNtpO97RReuz57XXrHj+S983DBT1zdjPK15dhCgsln6+gGfHl4cxcxLENNIwXTW25feWtYAYvK+GPkWo+hbBYYpXXZhJzX9Ntb390BGGpixT6I6FHngp+As+nzjbV/t9BUSf8yP0CZJRTB8LRLz6G1NnnPNvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7EFTJGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7EFTJGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2152C4CED1;
	Fri,  6 Dec 2024 14:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496174;
	bh=f+DKir8Zf7tH71vZpn4tsMwPRqk8wsSknTWaNm8ZuBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7EFTJGGp8fPmfDis3bzBwxJIVrrySsnIHa/wM3auLdFjN9IJ90B7sHeT6ZvK8+YR
	 euY+ttp2pgqjkmVANyLrOKpx69L47fbhzDNWtwFcF9vEH2KIlt6SNbU3p/U3ChA7Zt
	 jPEBJTnGuaB2jabG7huipQTf4oW8W0/qADRMnmX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 073/146] ceph: fix cred leak in ceph_mds_check_access()
Date: Fri,  6 Dec 2024 15:36:44 +0100
Message-ID: <20241206143530.475311004@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit c5cf420303256dcd6ff175643e9e9558543c2047 upstream.

get_current_cred() increments the reference counter, but the
put_cred() call was missing.

Cc: stable@vger.kernel.org
Fixes: 596afb0b8933 ("ceph: add ceph_mds_check_access() helper")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5736,6 +5736,7 @@ int ceph_mds_check_access(struct ceph_md
 
 		err = ceph_mds_auth_match(mdsc, s, cred, tpath);
 		if (err < 0) {
+			put_cred(cred);
 			return err;
 		} else if (err > 0) {
 			/* always follow the last auth caps' permision */
@@ -5751,6 +5752,8 @@ int ceph_mds_check_access(struct ceph_md
 		}
 	}
 
+	put_cred(cred);
+
 	doutc(cl, "root_squash_perms %d, rw_perms_s %p\n", root_squash_perms,
 	      rw_perms_s);
 	if (root_squash_perms && rw_perms_s == NULL) {


