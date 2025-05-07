Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C521482F5;
	Wed,  7 May 2025 18:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644251; cv=none; b=Kh/RIIxFLpzo0CF2OJmdGsIy2tlbFsIELeabp1sjx/x58RiMSv6QCSVkKTft5PtF9nNQDGsUzzVWBNHQyUBt7NQ4HztxGYBuPZnn4DMORL6mXuWaI/8/l42kB43jChJHEAheQwMZzvrzM4GT/pd1PsYm1l+3MRW3aBFYE4NTNJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644251; c=relaxed/simple;
	bh=D+85v+96x3lK9bFuMP0YcU7yEQ5OjZD8E9SUOXLxgx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kg8VL+si68ierhmB1asrF5s6cmhXfodIdI7475alIMwrw2XDj6zDimp600iG0sYHh83P4QBRxq4ufaLxet+KQYgkLUcAMpskS7WKZLh9oeR4jneVEgE4IsdtTCUs+O9SVz5kDM1SG6Mb1HipdGpkcAzlJgT1FMNY+leW4D+s/Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCzPrOOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCzPrOOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9419BC4CEE2;
	Wed,  7 May 2025 18:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644251;
	bh=D+85v+96x3lK9bFuMP0YcU7yEQ5OjZD8E9SUOXLxgx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCzPrOOctdj9Canb7Hmg2lEs8kh58G6rMlkaq5OQ/KIMMm39nlmny5zWPZ7a/MYpF
	 P06nvlVqRaz/GXKoV7L/W+xGw9XAFGF/ap/315r6RfFEHa4IDj2ysS9MXH0xiXpd8R
	 vLAVAtoZ7UO4y51PTL8Xp5tQbakvnn00iTvZJNQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 167/183] firmware: arm_ffa: Skip Rx buffer ownership release if not acquired
Date: Wed,  7 May 2025 20:40:12 +0200
Message-ID: <20250507183831.630826920@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 655672a880959..03d22cbb2ad47 100644
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



