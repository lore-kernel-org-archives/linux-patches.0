Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC012F531B;
	Sat, 12 Sep 2026 12:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215498; cv=none; b=fPirnyMjQsKkpWHx74AjHHB2G4UE2Xd5Dnr9G1RuoxlvBSgegkHUSUqP0Mo/ROUGEssntzMKabzBT6NIoibRCJXv1SUVucgZmSvMeR6oyoOClrZhiMsss0sQ4usY8+FqRm1A9ZTu2ZV1j4VP4RYiKkEnSm2hQnBBUTPRHSWksGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215498; c=relaxed/simple;
	bh=JAYQ4GS8+hsAF73nNrBsc3cPpf4kp6H3fF6OIpQsCmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMbAvAPuXsOrYzhGbXbkfGr/bWq1QP+u/eBNPAQ6sSWd/Zb38UTJitbQ/GBqD4HysHUZ2o1ihQyLZCo0nmfzJ7BzNQeB5oHnZ0HlYUKwQnurTTboQoSo5MYbU/qaTSjJMZR/CIWJabij/JYHV6t/hdTx5Nm5uMt+oY/lHXLEjDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZS8ITJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZS8ITJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592D11F000FF;
	Sat, 12 Sep 2026 12:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215497;
	bh=kvXKw5mDj3hFAsuNysRwiwRCPxOaSyVmm5OtgdgxX6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZS8ITJH/bGx0PgeAo8UyXbgFx6dnF0zTIGY9I0jaqBwvE8/x/PMGpXnZJq2lW/oP
	 WnGRYXVif4hNTkgr8qSAbHbPo2UItBQd3XI+LtEUCY7V/Zh0RHeK72Uhh7QfMCEr+b
	 3+eQkdhu3U3OEmW03nqb38YMWLvj980cSrEK4uEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0543/1376] firmware: arm_scmi: Unwind TX receiver mailbox setup failure
Date: Sat, 12 Sep 2026 08:49:29 +0200
Message-ID: <20260912065619.642885831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 6f7c06744d53dc8e047725d411d7f915d9ec35ae ]

mailbox_chan_setup() can request an additional unidirectional TX
receiver channel after successfully acquiring the primary channel. If
that second request fails, the function returns immediately and leaves
the primary channel allocated.

Unwind the primary mailbox channel before returning the error so probe
deferral or other setup failures do not leave the channel busy for later
probe attempts.

Fixes: 9f68ff79ec2c ("firmware: arm_scmi: Add support for unidirectional mailbox channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-13-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/transports/mailbox.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/transports/mailbox.c b/drivers/firmware/arm_scmi/transports/mailbox.c
index f4847569b42c8..3e662ec063c3d 100644
--- a/drivers/firmware/arm_scmi/transports/mailbox.c
+++ b/drivers/firmware/arm_scmi/transports/mailbox.c
@@ -227,9 +227,10 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 		smbox->chan_receiver = mbox_request_channel(cl, a2p_rx_chan);
 		if (IS_ERR(smbox->chan_receiver)) {
 			ret = PTR_ERR(smbox->chan_receiver);
+			smbox->chan_receiver = NULL;
 			if (ret != -EPROBE_DEFER)
 				dev_err(cdev, "failed to request SCMI Tx Receiver mailbox\n");
-			return ret;
+			goto err_free_chan;
 		}
 	}
 
@@ -245,6 +246,8 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 
 	return 0;
 
+err_free_chan:
+	mbox_free_channel(smbox->chan);
 err_clear_cinfo:
 	cinfo->transport_info = NULL;
 	smbox->cinfo = NULL;
-- 
2.53.0



