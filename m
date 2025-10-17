Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BDE3BB5A;
	Fri, 17 Oct 2025 15:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714713; cv=none; b=S4eV3mI0ZRUKDm4fs8WsrRTYaUba2gbwQJJWSJqRJLl747zAVMAic4WaiN2WU2+sIY1R9+DXx+TFjEOx0qnLimtFAzzZ3oamFcibzELIGr/UQ7u/m2gqD9INUDODiN9hVRSO4Iw0dD1lcGexyAHIJi7hp09XSoXIvwIOJ7S1Jb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714713; c=relaxed/simple;
	bh=3RxEu7DDMPfuMkWehCivwr0elPmhhu1nM/hE5oH9JOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prysiITo4R2Bgbo3G7hKvtB1wX5ZDNy+xyRrCcP3mZ5acxjBAE8WE6cRYqO/2DmTbTOoAm6p6CrF62/Y1SOn78VOqp+Izau2KES3VoVqokVVtiqPvg8TVpHHmBGjcI2jMncnlyVpGs4SnCiE37VPg+QOJ10/Rd8073VNggcr+yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLR/B4BR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLR/B4BR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0980DC4CEE7;
	Fri, 17 Oct 2025 15:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714713;
	bh=3RxEu7DDMPfuMkWehCivwr0elPmhhu1nM/hE5oH9JOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLR/B4BR+7Tk/5/9nGNuF50ZM8tkJABxJEca8uq5i79WQKf8qctRvOKoSZRPNQTJt
	 eZzCZFigUqloOSwpxD106FrYur7lty7JRZuncGVBVqHtLVsxTw7NT8JnTRnERsoWxx
	 J8ejSG4QvWI62hsIgtucRXJwJqvG+vRe80tcgsJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/277] statmount: dont call path_put() under namespace semaphore
Date: Fri, 17 Oct 2025 16:54:06 +0200
Message-ID: <20251017145155.866547084@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit e8c84e2082e69335f66c8ade4895e80ec270d7c4 ]

Massage statmount() and make sure we don't call path_put() under the
namespace semaphore. If we put the last reference we're fscked.

Fixes: 46eae99ef733 ("add statmount(2) syscall")
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5200,7 +5200,6 @@ static int grab_requested_root(struct mn
 static int do_statmount(struct kstatmount *s, u64 mnt_id, u64 mnt_ns_id,
 			struct mnt_namespace *ns)
 {
-	struct path root __free(path_put) = {};
 	struct mount *m;
 	int err;
 
@@ -5212,7 +5211,7 @@ static int do_statmount(struct kstatmoun
 	if (!s->mnt)
 		return -ENOENT;
 
-	err = grab_requested_root(ns, &root);
+	err = grab_requested_root(ns, &s->root);
 	if (err)
 		return err;
 
@@ -5221,15 +5220,13 @@ static int do_statmount(struct kstatmoun
 	 * mounts to show users.
 	 */
 	m = real_mount(s->mnt);
-	if (!is_path_reachable(m, m->mnt.mnt_root, &root) &&
+	if (!is_path_reachable(m, m->mnt.mnt_root, &s->root) &&
 	    !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	err = security_sb_statfs(s->mnt->mnt_root);
 	if (err)
 		return err;
-
-	s->root = root;
 	if (s->mask & STATMOUNT_SB_BASIC)
 		statmount_sb_basic(s);
 
@@ -5406,6 +5403,7 @@ retry:
 	if (!ret)
 		ret = copy_statmount_to_user(ks);
 	kvfree(ks->seq.buf);
+	path_put(&ks->root);
 	if (retry_statmount(ret, &seq_size))
 		goto retry;
 	return ret;


