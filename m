Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0823A214813;
	Wed,  7 May 2025 19:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645139; cv=none; b=neHWlwzRgBhDEABWcPe/pzCinXlJTqiwzkQAnflAKAxSR94UCOVrnhVwCAmAbKxEy0IcmBBc0D74mwqjoCFUPEDK85htVCp1WTviDaKvTtR3SJdBI3uPMr7Ne5MzlDFo2p2OvKmvRxuxEMdcl+VdUpWR6abQVNSyDwGn/xlod9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645139; c=relaxed/simple;
	bh=QDRDB61KkhlKSDo8YlrE2vh5rVfH5kowM9aIbH6+X1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VVhN20yUz86Acs0U0QsbTFh2XhfEk1KxToKL37JAjvuYCMncJV+40mlx/epxZrfU1q9AFJ4T8rr5JbZxWHkPRE36zZ9H5b5xfA6i2RwqrITrDvCNhRwSJgYi1hn3LuVcKRJsx2eHuP3UyHQItFLZX1K5aWk0Q66ihOfRtIQFcsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAXNcAOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAXNcAOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2F2C4CEE2;
	Wed,  7 May 2025 19:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645137;
	bh=QDRDB61KkhlKSDo8YlrE2vh5rVfH5kowM9aIbH6+X1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAXNcAOIGcTPoOwnAVo0seUzxPyLlGaK7dETJ9X5O3zpdviBIx6F9/U46jymU3Lau
	 gID2c5TACl0IRxAumo61hLI95y62d5/Y+wrl6u8b4VolM0wimy94KCB4lvLtmTZh6d
	 QFQqftqJSMq1xbpzWsRqSrUKDcVerf1ZGSa1AD88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/129] firmware: arm_ffa: Skip Rx buffer ownership release if not acquired
Date: Wed,  7 May 2025 20:40:41 +0200
Message-ID: <20250507183817.750780450@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 4567bdaaaaa1744da3d7da07d9aca2f941f5b4e5 ]

Completion of the FFA_PARTITION_INFO_GET ABI transfers the ownership of
the caller’s Rx buffer from the producer(typically partition mnager) to
the consumer(this driver/OS). FFA_RX_RELEASE transfers the ownership
from the consumer back to the producer.

However, when we set the flag to just return the count of partitions
deployed in the system corresponding to the specified UUID while
invoking FFA_PARTITION_INFO_GET, the Rx buffer ownership shouldn't be
transferred to this driver. We must be able to skip transferring back
the ownership to the partition manager when we request just to get the
count of the partitions as the buffers are not acquired in this case.

Firmware may return FFA_RET_DENIED or other error for the ffa_rx_release()
in such cases.

Fixes: bb1be7498500 ("firmware: arm_ffa: Add v1.1 get_partition_info support")
Message-Id: <20250321115700.3525197-1-sudeep.holla@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 7cd6b1564e801..7c2db3f017651 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -225,7 +225,8 @@ __ffa_partition_info_get(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 			memcpy(buffer + idx, drv_info->rx_buffer + idx * sz,
 			       buf_sz);
 
-	ffa_rx_release();
+	if (!(flags & PARTITION_INFO_GET_RETURN_COUNT_ONLY))
+		ffa_rx_release();
 
 	mutex_unlock(&drv_info->rx_lock);
 
-- 
2.39.5



