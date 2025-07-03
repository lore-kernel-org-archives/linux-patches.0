Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A89B2F0C55;
	Thu,  3 Jul 2025 15:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555572; cv=none; b=rm2qIOtn3s23anu4wYUPuoSmVAAwNE2u0jbfqe0Q9qMr5d5IeecPhIaz/oHtG6jzDVq/XnAwhCsL1H9C05nlZtDiVZBKAOG+IJ+sgWTCMszzxFUNSQ+2n0aO3c1dVhz3M8TYr599dZ2d2Nl1CzuJzcrlSV4RGY10y72TWGDuPVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555572; c=relaxed/simple;
	bh=s7yl8GmhIA/45MVuZ467KKLxpBMplDgkP2HpvZexy6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAeMZkY+jSN/Zq3EFuR6lmPrMcxYWYODeyS4TW+QKu30PVVUzCp7Puaa0SnhKGu9ob4m8jIVCYBIVrQcKvM+SNtm/U0dwNF7UyTTDUb2/+rhUe8sP7I3ZaOqnqnrHzSGSFFwKw4Dda0HsbAG8khfqxvzCS3Wy63a36QJ//eTzPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/TCcxvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/TCcxvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15EBC4CEED;
	Thu,  3 Jul 2025 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555572;
	bh=s7yl8GmhIA/45MVuZ467KKLxpBMplDgkP2HpvZexy6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/TCcxvyeSnR+MtGjxPLVXX2aHDQyyywp5n2szKln5z4ZtQwxPVhSQHfgohFDoRA4
	 lcvEBW8xAGn5ytP592kB9hqpZt/0ZOBYZkQ9nu5X5ajr5mtB61nlJMG9WUlVdP+n/a
	 p5KcJo0feRGoMZ/XHnTvwVnIEodN2Vrxik49GLrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/139] uio_hv_generic: Align ring size to system page
Date: Thu,  3 Jul 2025 16:41:58 +0200
Message-ID: <20250703143943.315994235@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

[ Upstream commit 0315fef2aff9f251ddef8a4b53db9187429c3553 ]

Following the ring header, the ring data should align to system page
boundary. Adjust the size if necessary.

Cc: stable@vger.kernel.org
Fixes: 95096f2fbd10 ("uio-hv-generic: new userspace i/o driver for VMBus")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/1746492997-4599-4-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <1746492997-4599-4-git-send-email-longli@linuxonhyperv.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_hv_generic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 031f6a8f1ebb2..17c1f85f2b7ba 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -260,6 +260,9 @@ hv_uio_probe(struct hv_device *dev,
 	if (!ring_size)
 		ring_size = HV_RING_SIZE * PAGE_SIZE;
 
+	/* Adjust ring size if necessary to have it page aligned */
+	ring_size = VMBUS_RING_SIZE(ring_size);
+
 	pdata = devm_kzalloc(&dev->device, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-- 
2.39.5



