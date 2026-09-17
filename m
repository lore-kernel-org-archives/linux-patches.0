Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF45C58FD22;
	Thu, 17 Sep 2026 15:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660628; cv=none; b=MY3sFeXXDK3cXZhnIAzxPH7FhzLry9LBnRVp73Z1ANbF2q3AL6MoYjURb85XEVpayGLX2q7tQDy8pUZQv4Y7vysgApCCha6vtLTzDCsWwon9GGLBUpzlN4V6oaMIMlhBmrj9XP8FHiogc2amGNCV1CARLRRMXRPWLnBcoEokAnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660628; c=relaxed/simple;
	bh=MomMuOmhL4ytXLLOl6cnvdwXQxXArDmyFGzChxqBJl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFR5lY/DLaT2l5hz7OUVp5Yb/zg78pp5rk6rxAefoQZk54qfnq12mqbWO/HpAixxZB9IPSnkd8zT4ENAnLROc+gSx0aADE96C0vFrp9dyUecee1SzcaXVUOwg/aGPR15XOafnm889ayvoM6zy0TCRHSymzKGv0x4FwOHskQqbas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jShymczD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jShymczD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451A61F00893;
	Thu, 17 Sep 2026 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660626;
	bh=YiJ77G/v0fOsuIAtzxMVhaUmhKDCveADzEaRNJKYIC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jShymczDqUIBvuU+BYmSukx1i6spdTuFNgE2bs8a+clTI6x+G/SFMDer+Y0xdNkIn
	 TpTKfZf9bOkVfijmRA7KcAR6MNkY9L0toaA8TJW1SQTamLiPCeMXAmYj0BMF5MUT1B
	 0gv7/ptunkOS3tvQ2iHR+MkQ7jFJ0WU0c+W9shzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 654/733] xfs: lock the healthmon when inserting unmount event
Date: Thu, 17 Sep 2026 16:16:02 +0100
Message-ID: <20260917151408.943471309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 7538ba528cfd6f176076186c1b1678fdca1c197b upstream.

LOLLM complains that xfs_healthmon_unmount does an unlocked insert of
the unmount event into the health monitor's event list.  Fix that.

Cc: stable@vger.kernel.org # v7.0
Fixes: 25ca57fa3624ca ("xfs: convey filesystem unmount events to the health monitor")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_healthmon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 4521ffdab9f1..3ae5f4496ad1 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -272,6 +272,8 @@ __xfs_healthmon_insert(
 {
 	struct timespec64		now;
 
+	lockdep_assert_held(&hm->lock);
+
 	ktime_get_coarse_real_ts64(&now);
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
@@ -294,6 +296,8 @@ __xfs_healthmon_push(
 {
 	struct timespec64		now;
 
+	lockdep_assert_held(&hm->lock);
+
 	ktime_get_coarse_real_ts64(&now);
 	event->time_ns = (now.tv_sec * NSEC_PER_SEC) + now.tv_nsec;
 
@@ -415,8 +419,10 @@ xfs_healthmon_unmount(
 	 * There's nothing actionable for userspace after an unmount.  Once
 	 * we've inserted the unmount event, hm no longer owns that event.
 	 */
+	mutex_lock(&hm->lock);
 	__xfs_healthmon_insert(hm, hm->unmount_event);
 	hm->unmount_event = NULL;
+	mutex_unlock(&hm->lock);
 
 	xfs_healthmon_detach(hm);
 	xfs_healthmon_put(hm);
-- 
2.55.0



