Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B39B202C2B;
	Wed,  7 May 2025 18:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643685; cv=none; b=SROv5u+UIzvDN/syJNTVTQ0BIe01Kpadcyf7+iZLVsxirRa+SmlCbBS5d8lLjmNoiEj6q+SrrwR6Aagv8UZtgtSmLJrqNvIxJe+qAdSqokkWjrRPJggqe47NfhQ+NJkKRyPFawWSovdaJlAdrWPpWwVIZfJTIDk/1oAnyPw4mWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643685; c=relaxed/simple;
	bh=RJbi4PlsCRNINZkwDO34q8yI0el73UO3eIO1ydL5qYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m2eH4Crn+boBwPIEBBascXh59+ryx1wghWYIltBBdni/tKNhHEPL294oi3t8vSrMUv77kq6UOtXWoie9pz+DZn+2Zm2/+Pe24l50PeWcRE8C2JBEJdLRUAiwS2eeZT02O4fecjsv8B2K8k2Vw1/KdqNTDv3eRzE6eMsBs39Fhqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDU/7y1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDU/7y1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E00C4CEE2;
	Wed,  7 May 2025 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643685;
	bh=RJbi4PlsCRNINZkwDO34q8yI0el73UO3eIO1ydL5qYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDU/7y1s7LkUzRqxEnorQZ/l8yr2nUvwNqCuhDLmN1UU3PVvhVYxn1yFxysgKKgLu
	 BXzIKOSR2RyvIDVJuNX5YDUiyxgADQOxRECdqJaGyMOXHlN2COhZ0ef8aNtX2mU7oG
	 JPtICVGvrR5uiC/pkMDRGi8ft/bEX2e3KAiwvT5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 81/97] firmware: arm_ffa: Skip Rx buffer ownership release if not acquired
Date: Wed,  7 May 2025 20:39:56 +0200
Message-ID: <20250507183810.240362049@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e9f86b7573012..e1e278d431e97 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -306,7 +306,8 @@ __ffa_partition_info_get(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 			memcpy(buffer + idx, drv_info->rx_buffer + idx * sz,
 			       buf_sz);
 
-	ffa_rx_release();
+	if (!(flags & PARTITION_INFO_GET_RETURN_COUNT_ONLY))
+		ffa_rx_release();
 
 	mutex_unlock(&drv_info->rx_lock);
 
-- 
2.39.5



