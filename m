Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3A630C618;
	Thu, 30 Jul 2026 15:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424436; cv=none; b=HzdIbddsxjf4mPM1fRzHkYH717EIKke8OI2dpX9U6y7d4PuiAIznmFfsR535jc3zIikd9bZBbeIbKwM5rfqUCe9aQEKHM5bSkmMbrx8jrtfLKPj0arJFZZM8AQEY6XTJwO2Wb76hRcEuJ66T8o9Um9KWr54JzLGH2B7IpGMzqe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424436; c=relaxed/simple;
	bh=7RCQjLXujBaPlFVykyVvRYp7aMEJBibf24w5860xMeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5eMcWb9sYkKSOrOcc3UxrLtgQEIeqqtJrAPulZYQOz+5NuyfMbNM8ZWSTdX8ZDdmsh5hd9vHbI+GV5hHUGkLy3nkEZlce4YTaDORr5TVFK5dcf4qk80nKwVC1GPnEKwNz9JvNoLVnwum5rmhYVhRoSCM8CVtia1Fr2KgjY1wRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KURiizTP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KURiizTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E976B1F000E9;
	Thu, 30 Jul 2026 15:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424435;
	bh=VkndL4gQeSnaAz/wiKIu3/vCPXWoToF4XDbamx8LfrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KURiizTP9m/9RE0Ku5sU0OvAcei1/ALC4uMMNCVjT9So/DyDG6jhcJ3zOcnMA4uGq
	 dAyDvjWDoQS8SgauJ+V+HYqnpO00CHSbtwppCfi4FkjbNiMSPg87nmr4W3hZfjJXVY
	 vkgoyzq/IykitRzmICYY0OMgm3N7WdV/TxLTdP9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Subject: [PATCH 6.18 392/675] drm/gpusvm: Fix MM reference leak in drm_gpusvm_range_evict
Date: Thu, 30 Jul 2026 16:12:02 +0200
Message-ID: <20260730141453.465055387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

commit 847b371debf3c8c72384ab7b9a0c4123a74cc925 upstream.

If kvmalloc_array() fails in drm_gpusvm_range_evict(), the MM
reference acquired earlier is not released, resulting in a reference
leak.

Fix this by dropping the MM reference on the kvmalloc_array()
failure path.

Fixes: 99624bdff867 ("drm/gpusvm: Add support for GPU Shared Virtual Memory")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patch.msgid.link/20260714170025.3487974-1-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gpusvm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1566,8 +1566,10 @@ int drm_gpusvm_range_evict(struct drm_gp
 		return -EFAULT;
 
 	pfns = kvmalloc_array(npages, sizeof(*pfns), GFP_KERNEL);
-	if (!pfns)
+	if (!pfns) {
+		mmput(mm);
 		return -ENOMEM;
+	}
 
 	hmm_range.hmm_pfns = pfns;
 	while (!time_after(jiffies, timeout)) {


