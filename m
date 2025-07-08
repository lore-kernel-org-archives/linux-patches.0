Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8AF2E0910;
	Tue,  8 Jul 2025 16:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992944; cv=none; b=t4I7dyQQ3gaWlCRwLIFlN6bc8l3WBmrSfP0gIqDQTEHjlcGbF9SDrHDiJElgFK3TzVYNOCanbMlIt17n/COH8TqhSNATP5QB+vGoMn7fCnQ0Fug2kgp6s/kiRL2Gc7qgBXDXFiNd3VLAa1ymo7aaaBwJ+wONlRtS2Gu6+lwI4LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992944; c=relaxed/simple;
	bh=VRduV3qublJbrTbJdmdhfNS0Os5KKMPBOLQC+xu1rf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8VtrUTzr0BO5Nx6BryQDaN5sJRqMDMiOOUGi2mJOrc2be5Pr0vB2EXvA3pq1bh9Jg3Un0v3qBvnaA8pBDcGnu6cXlEzKDtPS5uAFNtY2Caus2VHfyxcfSgW2aBCvHxJzSdyCjuCapT87HfGuC/rJpjqIfK5KO51X5duV2tnLmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBUKUMSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBUKUMSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BC6C4CEED;
	Tue,  8 Jul 2025 16:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992944;
	bh=VRduV3qublJbrTbJdmdhfNS0Os5KKMPBOLQC+xu1rf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBUKUMSWhdXNUHv7WKedblzhLwdhVOjlQRQkyI4I1ru/wS6IUGsuu0xiZfHlM8RcG
	 IO6jXRttSvSpFjbWW14VR7e/F2vVtTNksAF8ZIIVMj7kP1jm6BePRKvuILqOxE62kK
	 IUsLMqsBDfyClHV+EcBwcXfQ0pqzGx/bkCGtgj5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/232] gfs2: Prevent inode creation race
Date: Tue,  8 Jul 2025 18:21:40 +0200
Message-ID: <20250708162244.163784578@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit ffd1cf0443a208b80e40100ed02892d2ec74c7e9 ]

When a request to evict an inode comes in over the network, we are
trying to grab an inode reference via the iopen glock's gl_object
pointer.  There is a very small probability that by the time such a
request comes in, inode creation hasn't completed and the I_NEW flag is
still set.  To deal with that, wait for the inode and then check if
inode creation was successful.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 2c63986dd35f ("gfs2: deallocate inodes in gfs2_create_inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 9d72c5b8b7762..3c70c383b9bdd 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -984,6 +984,13 @@ static bool gfs2_try_evict(struct gfs2_glock *gl)
 	if (ip && !igrab(&ip->i_inode))
 		ip = NULL;
 	spin_unlock(&gl->gl_lockref.lock);
+	if (ip) {
+		wait_on_inode(&ip->i_inode);
+		if (is_bad_inode(&ip->i_inode)) {
+			iput(&ip->i_inode);
+			ip = NULL;
+		}
+	}
 	if (ip) {
 		set_bit(GIF_DEFER_DELETE, &ip->i_flags);
 		d_prune_aliases(&ip->i_inode);
-- 
2.39.5



