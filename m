Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9BE281364;
	Wed, 23 Apr 2025 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420817; cv=none; b=oOC2JUmL2++s88ZkgBRNqakDquukp4WRN/sTHRUTGqX/YvRmL339PUPZL+NGszjxyxbmNXLctzwwgiQMOv639ZiJkniuHnbFah1g3ARAZNCSYkUpaPHEdin5go2BJoyLHV5ATrlbi9q3XWOpi0M1zhIKz1dXp5VBwrhr4LELVQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420817; c=relaxed/simple;
	bh=DCF7e3Bu383lCR7QwIFtM3UeoF0GdvfVfOrF0KWuNmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQ+pSaB/I65zrVZ5FoAx2r3IZjYWlzevXIQYidcd51oSX+fMDw5x9fTpAqUcZpRmPiMXjl8s68kiBt7kLWoeWvtiTtd2aoQmfZQHHpH4y0ex141H6bP7xe5GoyQeYTB2XEll/NMKEtgw+algDeedbSg0InTcCsqxSvzUo3m/SBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMQTwI4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMQTwI4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726B5C4CEE3;
	Wed, 23 Apr 2025 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420816;
	bh=DCF7e3Bu383lCR7QwIFtM3UeoF0GdvfVfOrF0KWuNmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMQTwI4ieS+t3fpA/g7b2CFF6es4+iwLVz8VPkUB7ENCbtg5MWMHfuYPdWuADBPbe
	 pRphRQto5rXn/D34++Brz3YHg1zVuwW8owAe67hSM0gDsqbdcOlWz5K6GAsOYFhyfc
	 hhbX+MiHaJYTOt2d1O4Z/DZu4LXdukwp9CSsnTHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.12 165/223] drm/xe: Use local fence in error path of xe_migrate_clear
Date: Wed, 23 Apr 2025 16:43:57 +0200
Message-ID: <20250423142623.888469363@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit 20659d3150f1a2a258a173fe011013178ff2a197 upstream.

The intent of the error path in xe_migrate_clear is to wait on locally
generated fence and then return. The code is waiting on m->fence which
could be the local fence but this is only stable under the job mutex
leading to a possible UAF. Fix code to wait on local fence.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20250311182915.3606291-1-matthew.brost@intel.com
(cherry picked from commit 762b7e95362170b3e13a8704f38d5e47eca4ba74)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -1177,7 +1177,7 @@ err:
 err_sync:
 		/* Sync partial copies if any. FIXME: job_mutex? */
 		if (fence) {
-			dma_fence_wait(m->fence, false);
+			dma_fence_wait(fence, false);
 			dma_fence_put(fence);
 		}
 


