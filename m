Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646BE2BE037;
	Mon, 27 Oct 2025 19:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592670; cv=none; b=RqKqyc9Y6zYyQOZkWhzkk8CJgPHrmNdLQw6NJpiqnKqD8CPyYnLWtSW2JgYsr7lWWT9wsaFfvx4HvAiB3svdy8thpXJ5Z6sKHwwjaH5Jxn1aTyL6GqfdSrG/WRvGJitd+syKUxF0NkZmkZcPEoqSjqAScLviCIl8pISrmvExrc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592670; c=relaxed/simple;
	bh=m3IDyyHGSFhYQOH31ClQPnkRURtXris0umCAJzx5T54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pltTZMoNGpZpw/1v2WWbZQ5dBOeTrueR5NE0WllEoPRbhezMhkEHMUhhlMFK9AxEJ6TBwQqRI3w40PC8EctWSqwqttvg3Uq6Nqh1O8tjtye4AP0sIi49A5vRtDOps0SJlADx01H4GkJN39yFaoUCAwJ0+4o7b2QMypg0z6PPp7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gD06/VWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gD06/VWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B30C4CEF1;
	Mon, 27 Oct 2025 19:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592670;
	bh=m3IDyyHGSFhYQOH31ClQPnkRURtXris0umCAJzx5T54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gD06/VWRrKaJFHYMQQUBf7Rfsf4y8liFhihAPmfflUIOdwmUoWq8bW8RVDheTBSfV
	 X+erSxi1+cBNBInZJ0/FmUOVmBBMyKnYL+IoXVaS6Q3QrKQ5njvDemXv09HNpkPTqT
	 KQgEltEmCMB/RLaAOBo7moaq9Z6E2wCyGz8K7cB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Artem Shimko <a.shimko.dev@gmail.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 51/84] firmware: arm_scmi: Fix premature SCMI_XFER_FLAG_IS_RAW clearing in raw mode
Date: Mon, 27 Oct 2025 19:36:40 +0100
Message-ID: <20251027183440.177890940@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Shimko <a.shimko.dev@gmail.com>

[ Upstream commit 20b93a0088a595bceed4a026d527cbbac4e876c5 ]

The SCMI_XFER_FLAG_IS_RAW flag was being cleared prematurely in
scmi_xfer_raw_put() before the transfer completion was properly
acknowledged by the raw message handlers.

Move the clearing of SCMI_XFER_FLAG_IS_RAW and SCMI_XFER_FLAG_CHAN_SET
from scmi_xfer_raw_put() to __scmi_xfer_put() to ensure the flags remain
set throughout the entire raw message processing pipeline until the
transfer is returned to the free pool.

Fixes: 3095a3e25d8f ("firmware: arm_scmi: Add xfer helpers to provide raw access")
Suggested-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Artem Shimko <a.shimko.dev@gmail.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Message-Id: <20251008091057.1969260-1-a.shimko.dev@gmail.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 9d4c983a27547..fbe893734411c 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -627,6 +627,7 @@ __scmi_xfer_put(struct scmi_xfers_info *minfo, struct scmi_xfer *xfer)
 			hash_del(&xfer->node);
 			xfer->pending = false;
 		}
+		xfer->flags = 0;
 		hlist_add_head(&xfer->node, &minfo->free_xfers);
 	}
 	spin_unlock_irqrestore(&minfo->xfer_lock, flags);
@@ -645,8 +646,6 @@ void scmi_xfer_raw_put(const struct scmi_handle *handle, struct scmi_xfer *xfer)
 {
 	struct scmi_info *info = handle_to_scmi_info(handle);
 
-	xfer->flags &= ~SCMI_XFER_FLAG_IS_RAW;
-	xfer->flags &= ~SCMI_XFER_FLAG_CHAN_SET;
 	return __scmi_xfer_put(&info->tx_minfo, xfer);
 }
 
-- 
2.51.0



