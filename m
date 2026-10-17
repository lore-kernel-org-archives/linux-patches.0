Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DEC3A59BC;
	Sat, 17 Oct 2026 18:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260239; cv=none; b=sfotifCFsE3iPN3QDqtLTNlrfdzjq6arBAoc3mkze/6FHioS4CiUhz+/e9Yp6gkNvtePjctKbJHGnN/jvkPuXbqQOf5vnm3/n4ukLiVtf2w9vVgLBENcssJVaKh+QUItDbx6oSIu347iQUZfoDfzdKV/HRmhYRM7+SEwMJknsIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260239; c=relaxed/simple;
	bh=nJIrrC0sVPhBvBU1OAvYhbr7ZCZ8xWXNv2o4qKcrQjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBHdkp111ZCQn17Khhnfai2aVqrLXOCO5XB7180PADbigJC3gzgTHYiiocfGDrg+hlQ4Of2pkrZNIBuhoNqksipIapDsT2/9r7zEI8wdbFceNffKJGGs88EolnGAKvAXESrWCMeOD5qNwWjsJHejbNnjGT+J6E21hylmwTn1iJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTkvJ8kS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTkvJ8kS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396BB1F000C4;
	Sat, 17 Oct 2026 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260238;
	bh=8kRpEZNjVRfgOTsgmv6QdWkMS3mDLSNRv5fsPgOdq0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTkvJ8kS4bk2pEvGJdmdx1afLgZa9QnTINyIVRUPC6RwYV1aP29cPIk/1TOOSh4oN
	 injuUv8PGF++TkvPFV+0ez+hqx8HezmDW3lHRKgv+aESAxpBIhXccERCJVzYum+QFR
	 NnJchYQg/MYelPUSIebFS6N6gaMygglDeWNjbgaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1479/1674] firmware: arm_scmi: Clean up channels on setup failure
Date: Sat, 17 Oct 2026 18:02:31 +0200
Message-ID: <20261017160509.119512842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 687d67be3d87894ef12e8a164434612e0b53cfae ]

scmi_channels_setup() can fail after the common BASE channel or earlier
protocol channels have already been registered in the TX/RX IDRs.

Route this failure through the existing channel cleanup label so the
transport channels, transport devices and IDR state created before the
failure are released before the probe error path frees the SCMI instance
ID.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-4-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index f99cfc49dfcdb..0c2a0dc350ebd 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2830,7 +2830,7 @@ static int scmi_probe(struct platform_device *pdev)
 	/* Setup all channels described in the DT at first */
 	ret = scmi_channels_setup(info);
 	if (ret)
-		goto clear_ida;
+		goto clear_txrx_setup;
 
 	ret = bus_register_notifier(&scmi_bus_type, &info->bus_nb);
 	if (ret)
-- 
2.53.0



