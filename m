Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1626C1CF5C6;
	Wed,  7 May 2025 19:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644811; cv=none; b=TfQZCI/kbi933R3m9CUSQ8GnLU5LsktIuiyFduGwsAHxbrsUd9bcnbPikbddS+tFUzrdko59EcdPJz1pR9oTFuky6OUNsD4lfNKseC/U6vwQx5JJDV7AlnftjUuJo6arlscn1wNQ0VyKhAFksNOVJczvOLUTVVNxB1nTeq+AZN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644811; c=relaxed/simple;
	bh=gE+Z9ZgOMPdUCGyZZFp6v2kBBPWtGNr8BtijQEtazxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l6dvKealfCaPH7hFKjpzDscbAKPVg6WW1dLC6EdZNTxvMYhzRjDTmCn57N/uUur/11oTciyNoD4iD4MHt9NRpgX1lvl2XXrUyUpCETTjSVRzsJPlAd6yVmfq42fK7xZReV7txSQ6Tqbd1jMdAdJyDWNH3X00ZlOHAc8580AasWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNkQNRJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNkQNRJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE46C4CEE2;
	Wed,  7 May 2025 19:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644811;
	bh=gE+Z9ZgOMPdUCGyZZFp6v2kBBPWtGNr8BtijQEtazxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNkQNRJun0K5B6lQFRKoPLFXJhREcATR79JiZJFqqnMcP+yTJUfxJdaOb5dvpo7fh
	 mTXn7XSB+prbqRFBIIHExpibWJ3Dd2U1vApUxhyroM9tAjxWvhSaSnxlAJ8FlvfpI5
	 3ULsSeQvI5lh0LhXIA17fAasrwdd/djKTBytYEsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/164] firmware: arm_ffa: Skip Rx buffer ownership release if not acquired
Date: Wed,  7 May 2025 20:40:39 +0200
Message-ID: <20250507183827.202623427@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2c2ec3c35f156..dce448687e28e 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -280,7 +280,8 @@ __ffa_partition_info_get(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 			memcpy(buffer + idx, drv_info->rx_buffer + idx * sz,
 			       buf_sz);
 
-	ffa_rx_release();
+	if (!(flags & PARTITION_INFO_GET_RETURN_COUNT_ONLY))
+		ffa_rx_release();
 
 	mutex_unlock(&drv_info->rx_lock);
 
-- 
2.39.5



