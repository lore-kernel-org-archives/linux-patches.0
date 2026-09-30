Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDAF51617E;
	Wed, 30 Sep 2026 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787778; cv=none; b=WewOfWD8uCIedZmEm2W2MMRLZA7erM0F53t9pLb/fwGVWqogZT/1zb8A9yhCc9ZlDf2sGWyqnEDTj22NFCGPKTdJwFB/STenXkSaGSWW3bDu042S6KWDJt+6/YjhmmxPxrAAnC92dMg55zqlH7Uufsi1+Ow6jaBB09pju+U2m9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787778; c=relaxed/simple;
	bh=wy+LxIGbyoSZl1x/GvlPPS0pGesDl5O1G2ZSRXCZfEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxXQ0wEwC9/5E/M3C8E5ZY9PBTjBRP79/QgHQ9Fja31sRaL4HJOZ2ylu3Bzw/yxcAOtmuC2mE0bpSEkLDYnFMTU5hQoe0y61V4jLPQ05jvNRm2KMTshX6BjI4yEXNXfdR0SLq9lBQmZsdWjX4CjsnTHjfxxk6CHJkQLpdnINxVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4dEAn8Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4dEAn8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA98C1F000FF;
	Wed, 30 Sep 2026 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787777;
	bh=zzhKCSf4iT0zE7j6kgAftpfR+x5POBzm+6D60aVLlO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4dEAn8QuA1lIciKX28KRw+FLtoh4CMjU22yfIFgohcGDiRQ0n7fyCrjiSXkBrSE1
	 Ur72VUAEj+qjf5nFOCGNParony0Ofb9OCgQyjD9zL28b+i0ebxqluzJRJKbpaeuEra
	 uLgB7yiWae0syKsNUUd5SZwIeEOCcZVhtlUTylEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 7.2 305/457] drm/xe: Keep walking on SVM eviction failure
Date: Wed, 30 Sep 2026 17:26:50 +0200
Message-ID: <20260930152352.612238201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
@@ -1025,6 +1025,13 @@ static int xe_bo_move(struct ttm_buffer_
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


