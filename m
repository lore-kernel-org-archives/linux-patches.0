Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2E0446C9;
	Tue, 20 Feb 2024 21:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464758; cv=none; b=olDCOb0vPXedp6yxB3tMhzvNtDxApqN5vnGvwbO5OU+jdeTTdG+PI1TD09krAGRSelpEYYxKS8SjNALfRFZqFzhr2lO2YwGcuIqo/WMcRjv29OfHidcmA/tM0KuS3WLMc2nLxGGu0cXDHEpK+k552+3TYRWvPWoqDFTM1JgPwlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464758; c=relaxed/simple;
	bh=Nn1IJcWMQ2ntgDNJs8NHZD6a2P8naBtjcB9ewVe3QFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ily2Gv5gBeT+bqI2KwMvJ3Upw0VZWT4suYKwL5kRgqYHHE3i/o63QUVOigqYZxAKMNnsAWG2k8zWLnQyznkNAdFFYqifGRKEzzYeLRNykamNmZKo6PY2TmaTDMIWme8u3HNzVr14obrZ3qmG3LTuuljnQZo8sJC3c/1LCzgUTY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyhzefub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyhzefub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B25C433C7;
	Tue, 20 Feb 2024 21:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464758;
	bh=Nn1IJcWMQ2ntgDNJs8NHZD6a2P8naBtjcB9ewVe3QFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyhzefubfM4hvneu+2GSb3Mly7DnnbTZopFLX39UNMw1Du1tHqmhc1Z7Wu4vBsi6s
	 5IX7l4HNEMzcyqmgky5OsMqBQnjUviHHIH4fr6p6zbhUm9TehfV6hvUmuNojSovO+j
	 49a+WLu4sZAPvmLYcccqAZegO16cj02ZYyq7CBkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Saravana Kannan <saravanak@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 098/309] driver core: fw_devlink: Improve detection of overlapping cycles
Date: Tue, 20 Feb 2024 21:54:17 +0100
Message-ID: <20240220205636.252544664@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 6442d79d880cf7a2fff18779265d657fef0cce4c ]

fw_devlink can detect most overlapping/intersecting cycles. However it was
missing a few corner cases because of an incorrect optimization logic that
tries to avoid repeating cycle detection for devices that are already
marked as part of a cycle.

Here's an example provided by Xu Yang (edited for clarity):

                    usb
                  +-----+
   tcpc           |     |
  +-----+         |  +--|
  |     |----------->|EP|
  |--+  |         |  +--|
  |EP|<-----------|     |
  |--+  |         |  B  |
  |     |         +-----+
  |  A  |            |
  +-----+            |
     ^     +-----+   |
     |     |     |   |
     +-----|  C  |<--+
           |     |
           +-----+
           usb-phy

Node A (tcpc) will be populated as device 1-0050.
Node B (usb) will be populated as device 38100000.usb.
Node C (usb-phy) will be populated as device 381f0040.usb-phy.

The description below uses the notation:
consumer --> supplier
child ==> parent

1. Node C is populated as device C. No cycles detected because cycle
   detection is only run when a fwnode link is converted to a device link.

2. Node B is populated as device B. As we convert B --> C into a device
   link we run cycle detection and find and mark the device link/fwnode
   link cycle:
   C--> A --> B.EP ==> B --> C

3. Node A is populated as device A. As we convert C --> A into a device
   link, we see it's already part of a cycle (from step 2) and don't run
   cycle detection. Thus we miss detecting the cycle:
   A --> B.EP ==> B --> A.EP ==> A

Looking at it another way, A depends on B in one way:
A --> B.EP ==> B

But B depends on A in two ways and we only detect the first:
B --> C --> A
B --> A.EP ==> A

To detect both of these, we remove the incorrect optimization attempt in
step 3 and run cycle detection even if the fwnode link from which the
device link is being created has already been marked as part of a cycle.

Reported-by: Xu Yang <xu.yang_2@nxp.com>
Closes: https://lore.kernel.org/lkml/DU2PR04MB8822693748725F85DC0CB86C8C792@DU2PR04MB8822.eurprd04.prod.outlook.com/
Fixes: 3fb16866b51d ("driver core: fw_devlink: Make cycle detection more robust")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240202095636.868578-3-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index c18c7d4c6971..f9fb69249110 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2060,9 +2060,14 @@ static int fw_devlink_create_devlink(struct device *con,
 
 	/*
 	 * SYNC_STATE_ONLY device links don't block probing and supports cycles.
-	 * So cycle detection isn't necessary and shouldn't be done.
+	 * So, one might expect that cycle detection isn't necessary for them.
+	 * However, if the device link was marked as SYNC_STATE_ONLY because
+	 * it's part of a cycle, then we still need to do cycle detection. This
+	 * is because the consumer and supplier might be part of multiple cycles
+	 * and we need to detect all those cycles.
 	 */
-	if (!(flags & DL_FLAG_SYNC_STATE_ONLY)) {
+	if (!device_link_flag_is_sync_state_only(flags) ||
+	    flags & DL_FLAG_CYCLE) {
 		device_links_write_lock();
 		if (__fw_devlink_relax_cycles(con, sup_handle)) {
 			__fwnode_link_cycle(link);
-- 
2.43.0



