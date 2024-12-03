Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C16E1D9341;
	Tue,  3 Dec 2024 15:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239037; cv=none; b=NMoxMdjs/bsHX8nYAubE/vvdig9kYo5kLOb/lyD+7Cb4NP0yhGQVH8Q1K29Uc2z+kGx5SrzsyNfblUAb8Rdoj+nbgxHOa+zNorBJuM/PuMhXZexEDQQFSNGoFUBpiTdqDY1fv6y1W74xvIVforoLJfBmXB6Jh0Y4j8FVYfxjfoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239037; c=relaxed/simple;
	bh=1Ptlv6AtZ0M48nJPuemh91dgNurfC9Dry8iOy4m6JVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEcvGY8jKcBMmmzNYwEfkNoNBXew/cj1nvVO4x9QnQWChAKxwGqpIlHkItkDdjQMiqaQRnc2x93x3LTpgg4C1lfi6Cez8n7l/0fe+ccgtkHOq6J7Ai5nRxUicud6gw0lggR/1UIRtFbivTIry5eBqmagsGkK0NYyaN2YkkbdReo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nN/6O3+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nN/6O3+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4530EC4CECF;
	Tue,  3 Dec 2024 15:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239036;
	bh=1Ptlv6AtZ0M48nJPuemh91dgNurfC9Dry8iOy4m6JVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nN/6O3+Wpze7ST/Ix3cKgOmNBBO2f/UR68GRo83rSv14t7gQ6Ib9aIraglUN9UsNl
	 vqD0dGX1zRmT/574zgnlA1qAgl4FZL4CuAxEO/Y8y9lf0wdpp4K5fSLo3n7VpbKMXx
	 vRpFZauvuT4rUwneTkOrzZjZKi6jeaadYsiC9F+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 483/817] gfs2: Allow immediate GLF_VERIFY_DELETE work
Date: Tue,  3 Dec 2024 15:40:55 +0100
Message-ID: <20241203144014.725404347@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 160bc9555d8654464cbbd7bb1f6687048471d2f6 ]

Add an argument to gfs2_queue_verify_delete() that allows it to queue
GLF_VERIFY_DELETE work for immediate execution.  This is used in the
next patch.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 7c6f714d8847 ("gfs2: Fix unlinked inode cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 301139db908bf..b7f5347e4b41b 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1013,14 +1013,15 @@ bool gfs2_queue_try_to_evict(struct gfs2_glock *gl)
 				  &gl->gl_delete, 0);
 }
 
-static bool gfs2_queue_verify_delete(struct gfs2_glock *gl)
+static bool gfs2_queue_verify_delete(struct gfs2_glock *gl, bool later)
 {
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
+	unsigned long delay;
 
 	if (test_and_set_bit(GLF_VERIFY_DELETE, &gl->gl_flags))
 		return false;
-	return queue_delayed_work(sdp->sd_delete_wq,
-				  &gl->gl_delete, 5 * HZ);
+	delay = later ? 5 * HZ : 0;
+	return queue_delayed_work(sdp->sd_delete_wq, &gl->gl_delete, delay);
 }
 
 static void delete_work_func(struct work_struct *work)
@@ -1052,7 +1053,7 @@ static void delete_work_func(struct work_struct *work)
 		if (gfs2_try_evict(gl)) {
 			if (test_bit(SDF_KILL, &sdp->sd_flags))
 				goto out;
-			if (gfs2_queue_verify_delete(gl))
+			if (gfs2_queue_verify_delete(gl, true))
 				return;
 		}
 		goto out;
@@ -1064,7 +1065,7 @@ static void delete_work_func(struct work_struct *work)
 		if (IS_ERR(inode)) {
 			if (PTR_ERR(inode) == -EAGAIN &&
 			    !test_bit(SDF_KILL, &sdp->sd_flags) &&
-			    gfs2_queue_verify_delete(gl))
+			    gfs2_queue_verify_delete(gl, true))
 				return;
 		} else {
 			d_prune_aliases(inode);
-- 
2.43.0



