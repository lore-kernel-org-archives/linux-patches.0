Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A762882C9;
	Thu, 27 Nov 2025 14:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255211; cv=none; b=bCIcTkcONQ+6ZPdPnFu9wGNXbz/bKuKQtZv44q0+n1N7v9EYCzoJ1ZN3Xx3vjROKrvwScFjh0RteXLbKibGANhFkrk0rakH30WuQsDWdS6j+xDJL9EJ16Id7f0eKkf4hE/9vHIPRUYkqsxisOJqzyAr9w8PHO78iUFQ+5j89Flo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255211; c=relaxed/simple;
	bh=1vBtUO08JhPrX7nti5Oy9zonV4SGhEO0cdPtXxsSyZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKjGfNXI2fgDazPSfK37un2Miw7LDupSjpEteLkIatFCUxtXoadCPBFOFGlRkZnAuda+eJRT8AG0UVBfJjo1yU55uAt9SfHzvGN4xzQoF7BKI5HWAsEPVit48cecdTYXy4GEMZIr/WtxPpkeYXsreHZeiVQFAHm+yDchqy2eUIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QE4djSyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QE4djSyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEC5C4CEF8;
	Thu, 27 Nov 2025 14:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255211;
	bh=1vBtUO08JhPrX7nti5Oy9zonV4SGhEO0cdPtXxsSyZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QE4djSyOmv5FnLUGSB2WK5dxPNcekq7jot9Mwq0MAnVBffbH/hZKqQCZqjuSuHRlM
	 kNGZFaX8r5kMqLlHPgsupHBA9n570nBYfDmX9qvtRnEb//sHSNlYGc0XFPR+iO0EMy
	 EmZVQ/xbSPtBgdgplVRo1tsTdlHR8H9ZUHd5auds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Robert McClinton <rbmccav@gmail.com>
Subject: [PATCH 6.12 046/112] drm/radeon: delete radeon_fence_process in is_signaled, no deadlock
Date: Thu, 27 Nov 2025 15:45:48 +0100
Message-ID: <20251127144034.527000918@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Robert McClinton <rbmccav@gmail.com>

commit 9eb00b5f5697bd56baa3222c7a1426fa15bacfb5 upstream.

Delete the attempt to progress the queue when checking if fence is
signaled. This avoids deadlock.

dma-fence_ops::signaled can be called with the fence lock in unknown
state. For radeon, the fence lock is also the wait queue lock. This can
cause a self deadlock when signaled() tries to make forward progress on
the wait queue. But advancing the queue is unneeded because incorrectly
returning false from signaled() is perfectly acceptable.

Link: https://github.com/brave/brave-browser/issues/49182
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4641
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Robert McClinton <rbmccav@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 527ba26e50ec2ca2be9c7c82f3ad42998a75d0db)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_fence.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -360,13 +360,6 @@ static bool radeon_fence_is_signaled(str
 	if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq)
 		return true;
 
-	if (down_read_trylock(&rdev->exclusive_lock)) {
-		radeon_fence_process(rdev, ring);
-		up_read(&rdev->exclusive_lock);
-
-		if (atomic64_read(&rdev->fence_drv[ring].last_seq) >= seq)
-			return true;
-	}
 	return false;
 }
 


