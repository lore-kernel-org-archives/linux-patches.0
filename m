Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC2923D7FF;
	Wed, 30 Sep 2026 18:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793447; cv=none; b=jWvrhzSNkLW7Hqb6lclyo8yB4ChIrRKz9t+3A7OHnz1cfq1R3zRvidJVQIsaH3U5Z2i5B45jOkU8PdRIVfRHvA3c7h1J8Gcuu4DO9jYSC1a7HVX1d+JmsIRb7uZ8SPSwQMm0T9sq1mFPPlHD2uoy9AcAYCjij42CrwVXJ6pIhyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793447; c=relaxed/simple;
	bh=fqWDQbYSFsWOj6dYOtU85A5gjIsb48nJw9z7A+ZqyQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVPsQf4Pm4wh21BDwWwM3pFsv+hzOAXbCljAP3q9CoYXbcJHEw+L2MFOSDM5kuZrE8dsW1puHgMTBM6yRMwt3fVFsmDYuFjzgmnD/3OIjTMc93Le8jox7MP695ttxSO37mqQLqQSvsOS2TDNK2r/Anma2S+pM/hF98f+3aB9xns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlwgQqnl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlwgQqnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EB41F000FF;
	Wed, 30 Sep 2026 18:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793446;
	bh=VKyRZPJNbu//h42hCWPK86nbk7/uBA5wYZXfVl8EeDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlwgQqnlbWHLPKYDcmtwK2nwmEHWoPWROcoArGLiGSNTA4yQNj/VlYhZQHDSYEITm
	 uJ/+zM28l9noVP5F7EFuSkICp1v93Hf+LqOwTWhREZ4sfFOq4EhkN3ODzfOtOULwq4
	 GhJwGyTwEDwB7QjvQytkTNEG1wq6C6HugAsAznpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 257/395] drm/xe: Keep walking on SVM eviction failure
Date: Wed, 30 Sep 2026 17:28:39 +0200
Message-ID: <20260930152346.229935969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit be1df8badae513e01d9575398438716cfae18655 upstream.

The desired behavior for SVM eviction failures, which can occur due to
various uncontrollable races, is for TTM to continue walking the LRU
list and look for another eviction candidate. This is expressed by
returning -ENOSPC from the ->move() callback.

Adjust the SVM eviction failure path because of races in ->move() to
return -ENOSPC so that TTM continues searching for another buffer to
evict.

Fixes: 3ca608dc7561 ("drm/xe: Basic SVM BO eviction")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patch.msgid.link/20260917203158.292823-1-matthew.brost@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 36a86c23588b8f57c9d20feb4cf5a2ab27e3baba)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -853,6 +853,13 @@ static int xe_bo_move(struct ttm_buffer_
 		} else {
 			drm_dbg(&xe->drm, "Evict system allocator BO failed=%pe\n",
 				ERR_PTR(ret));
+			/*
+			 * The semantic we want upon SVM eviction failure
+			 * because of racing access is keep walking for
+			 * eviction, which is -ENOSPC.
+			 */
+			if (ret == -EBUSY)
+				ret = -ENOSPC;
 		}
 
 		goto out;


