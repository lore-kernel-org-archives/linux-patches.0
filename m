Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA9224EAB1;
	Sat, 30 May 2026 18:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165231; cv=none; b=RUhUtTSVymlmRZMbN/k/8Y8cvxtAHcbpOb69XUTsvXqjo+wP/gzWuLpMQJMeER2SYCYZ/6ikXBO9eC8YNZe+AQDfqpe4UwUnzW/SLBCc+66ADKuzqmN4lSG0mOEgY/s5/BZ3mecWVd9OYI2J2l/g5MhUn9ef4XHj4Qcx1IZOWLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165231; c=relaxed/simple;
	bh=OfKZm7VXCLWFSXh5V7tnjjPJKhhTj5se+ApCb7ramvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H63OXGiMFNyFhLwiglNGx57jDMRylmYV4jVBNMXwoBXUQzY7JL3Vzz4pvzYIj8N9rmKQvuCcdZLkPULxEFkKrrhYTISIZ7ft0QimhQRPO7J6jylCyyIlS2Ih8lQaGIhqXmBykdB/GzgTR2AB5dSyNZ/QnmEROGi86cgHDaQ5xKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0oPUHDw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0oPUHDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868061F00893;
	Sat, 30 May 2026 18:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165230;
	bh=F13f8o9V+T2Q9vBUWPjFk8UZV/Mx2DFsDcTgSSAuiKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0oPUHDwSgf3MHX5QrA74qliwJ9NhUKxVRcSnk35Rq/wzadPktFu+1gx+WDHIrsme
	 pgmksDjm03lfZZWs0pWHrK6ubj/NEZzXEi0PS24H78qCQj7tjTkavOrTq13BfIxRxs
	 G8Vz2bzK3GUJgO4pjVFhmfQP158MG2AuRxtQrx7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/589] drm/vc4: Protect madv read in vc4_gem_object_mmap() with madv_lock
Date: Sat, 30 May 2026 17:58:19 +0200
Message-ID: <20260530160225.057427194@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 338c56050d8e892604da97f67bfa8cc4015a955f ]

The mmap callback reads bo->madv without holding madv_lock, racing with
concurrent DRM_IOCTL_VC4_GEM_MADVISE calls that modify the field under
the same lock. Add the missing locking to prevent the data race.

Fixes: b9f19259b84d ("drm/vc4: Add the DRM_IOCTL_VC4_GEM_MADVISE ioctl")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260330-vc4-misc-fixes-v1-4-92defc940a29@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index 9006b9861c90c..437084f7973c6 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -719,12 +719,15 @@ int vc4_mmap(struct file *filp, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
+	mutex_lock(&bo->madv_lock);
 	if (bo->madv != VC4_MADV_WILLNEED) {
 		DRM_DEBUG("mmaping of %s BO not allowed\n",
 			  bo->madv == VC4_MADV_DONTNEED ?
 			  "purgeable" : "purged");
+		mutex_unlock(&bo->madv_lock);
 		return -EINVAL;
 	}
+	mutex_unlock(&bo->madv_lock);
 
 	/*
 	 * Clear the VM_PFNMAP flag that was set by drm_gem_mmap(), and set the
-- 
2.53.0



