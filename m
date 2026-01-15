Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEC986334;
	Thu, 15 Jan 2026 17:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498743; cv=none; b=i/fPtHcAofQSx3/gPO7YJf9oiTZT5WmAcJNizAT0VUflursON5RjGSCiKWUWHeu9I4/tO/1LbpSWdXLDjMYw+fbvBAQQAa6cRg0Xp52SmPKJ8YtbbVYtXwJl6yPuuV+4TaVOPdq+qbuWbMDDyQFaB1iK50L0ts15iSBtarvlvjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498743; c=relaxed/simple;
	bh=VJ8UzcsghJnjIvFdT0tOjyV/ktKekqSiva6lIJIiKVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQf16LSg01RoExy1MCv8ZbWDFfa8X7MQeZHnoJikHafJNl+D5UqkDffQORMqI2fLImY+iZwwRvvEc5tXUsgHRltzkgeDVEo6bWGnr8w/L4w1C7qpZS/QYsA34bgL/GAytM7h325NNX7ARB+qf7fHHVn5a2CKsOJ0K5HsRy/3bXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTZrYqKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTZrYqKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220E1C116D0;
	Thu, 15 Jan 2026 17:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498743;
	bh=VJ8UzcsghJnjIvFdT0tOjyV/ktKekqSiva6lIJIiKVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTZrYqKnnNmprPlT7y9xqib5ENJPWUs/PTe5nhAak/KQXCPW2XrfMzJxc7Dcx2Jo4
	 Yi+3SIYBCFjXw1qcIwE4eRa79DTxFpjLrs8yo76dcv34WyCmk8CUd8Q6H96RLrk1L8
	 CGp+5RJib/dT7XOr1SxVflpILkIjVN04z5CVIqQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petko Manolov <petkan@nucleusys.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 539/554] net: usb: pegasus: fix memory leak in update_eth_regs_async()
Date: Thu, 15 Jan 2026 17:50:05 +0100
Message-ID: <20260115164305.835800644@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petko Manolov <petkan@nucleusys.com>

[ Upstream commit afa27621a28af317523e0836dad430bec551eb54 ]

When asynchronously writing to the device registers and if usb_submit_urb()
fail, the code fail to release allocated to this point resources.

Fixes: 323b34963d11 ("drivers: net: usb: pegasus: fix control urb submission")
Signed-off-by: Petko Manolov <petkan@nucleusys.com>
Link: https://patch.msgid.link/20260106084821.3746677-1-petko.manolov@konsulko.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index cd063f45785b7..fd7b9776b4824 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -168,6 +168,8 @@ static int update_eth_regs_async(pegasus_t *pegasus)
 			netif_device_detach(pegasus->net);
 		netif_err(pegasus, drv, pegasus->net,
 			  "%s returned %d\n", __func__, ret);
+		usb_free_urb(async_urb);
+		kfree(req);
 	}
 	return ret;
 }
-- 
2.51.0



