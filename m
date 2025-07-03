Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A570F2EF661;
	Thu,  3 Jul 2025 15:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556177; cv=none; b=i+0gAjC829oqqXnwtTofEg1RE3YuKV8NKisl7jZwI0rJhq2awNb13F2r9rpI9SvcYgHdhIEq7NHflqxtJox94s73lDDP5DtYjHO+rJZxHc4GRTNOmzLkSB4TzY+/Rbuh+3M7Zn9W9PoRFlxEo8zMWHDZhcoZZrrwYQSzLWyT/kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556177; c=relaxed/simple;
	bh=jiD8bbq2EXDWOb7gq8tTf+oaZr1A2PSZVolBL9ODaXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GubOcDkyHsqZX4cjKQfthPazp+IBDKMEMSV8eEkNH46A9HsbS6peiFQao5VJLy5ekhtMrRD1usOY8a8lEyopAXYee1eWyhScA2JhAC8jh6W5lBMUYyQ2Ci1SJqpn0eiRItF6387cb+xVoEJF78IZ2C3qz19+QMB9B4th23d8MBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVPrOy49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVPrOy49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4A5C4CEE3;
	Thu,  3 Jul 2025 15:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556177;
	bh=jiD8bbq2EXDWOb7gq8tTf+oaZr1A2PSZVolBL9ODaXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVPrOy49eYQJNg5TAxPkKyikPUBxXHsc+l+1e0g5ug/oZFFA4ROYReOdBwYkGYqiq
	 OdsBNkB7PuU+yNnKM7F1oJousNp6wUtOrFIzk9KuH/ne7Rx0hvad4fzl8FRdmVZ52i
	 Bw5qTedgCwuY+ELN0EbGSsCmN0Ms1Ew7L6guO9iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Long Li <longli@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/132] uio_hv_generic: Query the ringbuffer size for device
Date: Thu,  3 Jul 2025 16:42:28 +0200
Message-ID: <20250703143941.735456492@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurabh Sengar <ssengar@linux.microsoft.com>

[ Upstream commit e566ed5b64177a0c07b677568f623ed31d23406d ]

Query the ring buffer size from pre defined table per device
and use that value for allocating the ring buffer for that
device. Keep the size as current default which is 2 MB if
the device doesn't have any preferred ring size.

Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Link: https://lore.kernel.org/r/1711788723-8593-3-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 0315fef2aff9 ("uio_hv_generic: Align ring size to system page")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_hv_generic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 94dda3d4d509f..8cb724095be6d 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -249,6 +249,7 @@ hv_uio_probe(struct hv_device *dev,
 	struct hv_uio_private_data *pdata;
 	void *ring_buffer;
 	int ret;
+	size_t ring_size = hv_dev_ring_size(channel);
 
 	/* Communicating with host has to be via shared memory not hypercall */
 	if (!channel->offermsg.monitor_allocated) {
@@ -256,12 +257,14 @@ hv_uio_probe(struct hv_device *dev,
 		return -ENOTSUPP;
 	}
 
+	if (!ring_size)
+		ring_size = HV_RING_SIZE * PAGE_SIZE;
+
 	pdata = devm_kzalloc(&dev->device, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
-	ret = vmbus_alloc_ring(channel, HV_RING_SIZE * PAGE_SIZE,
-			       HV_RING_SIZE * PAGE_SIZE);
+	ret = vmbus_alloc_ring(channel, ring_size, ring_size);
 	if (ret)
 		return ret;
 
-- 
2.39.5



