Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABB62907;
	Tue, 20 May 2025 14:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750887; cv=none; b=i1AGRzyyCE9kIzzvSPsLQAnBM2ZjUaVLghJXGhshbNbSL0Vq7E4ZHttNNOv5ha9fhpib+8s8leGZRh2IiJ2CwIUnAv0r54FEfxStMzZj9Hs+un/0UO5Pmdaj3gMbGDqJ2uZTAX+oYEDxTPTvkE2RhknQsk31vgxqu8w4rMS6UPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750887; c=relaxed/simple;
	bh=k5SeS67/kJh2uTAA4yeEfL+u/Wl632EYNMtXXx3mbfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZE41wnxx/gqB9rfbEbFvpo3hiLWxNLNKzzVEWDyZfqSwJ+wqftPsTLH078qyjUWb4eH2Ia77deYGMMRpGVTOvhZzA31r/fQ9W2FbWBK/8Fdqcj25/wvSmzgdA5GcwNMnDYhYzavXIi7IzRLA79zXYAhEOQRcmFCo4mVGmibaB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1AJpB0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1AJpB0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F64C4CEE9;
	Tue, 20 May 2025 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750887;
	bh=k5SeS67/kJh2uTAA4yeEfL+u/Wl632EYNMtXXx3mbfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1AJpB0MXyFeYzL3uheSnLrsPY/lbJv3n2/PyaDM6dgr+KGHHGd/gzGPril2yufb1
	 r+zH6ag2DVKLHUivfH//vhkTp071i9I6XHIO1JML7dPrree5/RBAhwjd/eKxNAHnxf
	 dhXmElg77BtgI2gYBwu6rzkMIpBSWkh94+YvO5Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Karol Wachowski <karol.wachowski@intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.14 140/145] accel/ivpu: Fix missing MMU events if file_priv is unbound
Date: Tue, 20 May 2025 15:51:50 +0200
Message-ID: <20250520125816.025712671@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@intel.com>

commit 2f5bbea1807a064a1e4c1b385c8cea4f37bb4b17 upstream.

Move the ivpu_mmu_discard_events() function to the common portion of
the abort work function. This ensures it is called only once, even if
there are no faulty contexts in context_xa, to guarantee that MMU events
are discarded and new events are not missed.

Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250129125636.1047413-4-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_job.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -369,7 +369,6 @@ void ivpu_context_abort_locked(struct iv
 		ivpu_jsm_context_release(vdev, file_priv->ctx.id);
 
 	ivpu_mmu_disable_ssid_events(vdev, file_priv->ctx.id);
-	ivpu_mmu_discard_events(vdev);
 
 	file_priv->aborted = true;
 }
@@ -872,6 +871,13 @@ void ivpu_context_abort_work_fn(struct w
 	}
 	mutex_unlock(&vdev->context_list_lock);
 
+	/*
+	 * We will not receive new MMU event interrupts until existing events are discarded
+	 * however, we want to discard these events only after aborting the faulty context
+	 * to avoid generating new faults from that context
+	 */
+	ivpu_mmu_discard_events(vdev);
+
 	if (vdev->fw->sched_mode != VPU_SCHEDULING_MODE_HW)
 		return;
 


