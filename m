Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8081F75AC;
	Tue,  3 Dec 2024 16:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241616; cv=none; b=VYRuES7nuiCW5qJhTiMOQsYKZUXu56qm6MrRqAKPnphX1kLsMSZPgZFOhkt8yXXLhLZMc0LR+ksganMK3tQogPBY6PTNQGUthwoe+KESor1iJI9vfYz8Zq73uwrQXyRTNbmokW69ghbb9otJcs5Qs/aPuAZEPRhjuVuO/M72LAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241616; c=relaxed/simple;
	bh=sW4oua2dYZD7joy7x79AY3fyjoXIkD7wp0bStQ8s+A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+8XLGOBRdU9yBW2Ggi34DXvO/p7kHpsW+Tb5ZCfZvqQsBR6dlPnrGSsFyrRlGrwE+WkkptlHefSNtfvv4QDW9U0XQSYfxhje/FpoaPiohYbQMhWE2ndAwJ4nGDPuYnPXqB2zrWlNsSGU18OG6NjTIPB7qeAHXOonAxE+xjW/tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjhGawfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjhGawfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF546C4CED9;
	Tue,  3 Dec 2024 16:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241616;
	bh=sW4oua2dYZD7joy7x79AY3fyjoXIkD7wp0bStQ8s+A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjhGawfmrzktYN0g/CfbfhAZeAex8PEzVf4Yif6paqJ2tTdvBC2k1sKBblWxGxo5R
	 NIeqlhCIpILEjadRBh5BIbYRuX+M4X0B2HqTe+Ay2LvV60UtaHpMOwi2cfPmpwjS3T
	 odOpaQzILh/lrCT8Okbk6hm1/7h1cNRug8qtcL/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 468/826] gfs2: Allow immediate GLF_VERIFY_DELETE work
Date: Tue,  3 Dec 2024 15:43:15 +0100
Message-ID: <20241203144802.019668891@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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
index 5addf4ebf33bd..509115202ccf9 100644
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



