Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF3B1494D9;
	Fri,  6 Dec 2024 14:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496171; cv=none; b=aFifonP5gh3z98o/e4bn1AaKxKLJ1Egx9V1lBIGwGQBU0//oWl0uy9w1mwDG353IRNLmWmqZvhUDYCtF7UANkgO3Ime9hduOhCqJryUF3FLSKbt77P4WPMKo+pZK87O3X8PCgP+6krBuVvy0ljkwYuQCrm/HEOSI647veH6aQkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496171; c=relaxed/simple;
	bh=zTFSR6O2WmYLlHUPLZi+bmQKjOCdYVNcsr7jswVQ1S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ub2gJ0BSCoFK1DQe+aYLHuGF8pftZ3q148lL9iZbrTdYma96OigbVpcbU0guLbABXcI89ZQm0aLYVORqRy5osYFJ25HVvfSBjQ0Rn5roySPWaD/EYr/NE9cvBBDubssuhzCZkTcMMd1PZx4jMZLcOLf+MHdypsMuPGSvJwvZvoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNLmG4pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNLmG4pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA011C4CED1;
	Fri,  6 Dec 2024 14:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496171;
	bh=zTFSR6O2WmYLlHUPLZi+bmQKjOCdYVNcsr7jswVQ1S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNLmG4pdUqoEtu596qMKoTtYK/GO7nrkzsSx9iQWgqA/NWZmj0LKK8+ee6opi+eTk
	 Jw5qWEd8K7r8le7o0X4TwvHmv3hdHYLb57et25dpsJ4+qwQ93HpWH0ajKuRjJfJFot
	 miNwDpllIeHE/2EcH0wlhGAlekGqdDYU7kMumYHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 072/146] ceph: pass cred pointer to ceph_mds_auth_match()
Date: Fri,  6 Dec 2024 15:36:43 +0100
Message-ID: <20241206143530.436602319@linuxfoundation.org>
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

commit 23426309a4064b25a961e1c72961d8bfc7c8c990 upstream.

This eliminates a redundant get_current_cred() call, because
ceph_mds_check_access() has already obtained this pointer.

As a side effect, this also fixes a reference leak in
ceph_mds_auth_match(): by omitting the get_current_cred() call, no
additional cred reference is taken.

Cc: stable@vger.kernel.org
Fixes: 596afb0b8933 ("ceph: add ceph_mds_check_access() helper")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5609,9 +5609,9 @@ void send_flush_mdlog(struct ceph_mds_se
 
 static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 			       struct ceph_mds_cap_auth *auth,
+			       const struct cred *cred,
 			       char *tpath)
 {
-	const struct cred *cred = get_current_cred();
 	u32 caller_uid = from_kuid(&init_user_ns, cred->fsuid);
 	u32 caller_gid = from_kgid(&init_user_ns, cred->fsgid);
 	struct ceph_client *cl = mdsc->fsc->client;
@@ -5734,7 +5734,7 @@ int ceph_mds_check_access(struct ceph_md
 	for (i = 0; i < mdsc->s_cap_auths_num; i++) {
 		struct ceph_mds_cap_auth *s = &mdsc->s_cap_auths[i];
 
-		err = ceph_mds_auth_match(mdsc, s, tpath);
+		err = ceph_mds_auth_match(mdsc, s, cred, tpath);
 		if (err < 0) {
 			return err;
 		} else if (err > 0) {


