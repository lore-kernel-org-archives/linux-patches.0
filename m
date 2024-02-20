Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBE814A4E2;
	Tue, 20 Feb 2024 21:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462851; cv=none; b=UhirgovPcflNOPmgTsXluCXzcdt4Ijzo3/r8XFgv4DsvfdM20oxOTXN1re4fFMZsTAM3867kHRhkIzStRN8z5XMGO59xN448gygXCRVKlHEzXHlan4bnYbXmCI6f9Vc0ou5XI0o2s5uRku0wcDXxHNm5XIjNnXdPoz6Qv1gOQzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462851; c=relaxed/simple;
	bh=W+4zjgLoSeMu2Q0ZZRPiP87e2IDsS27OLY428cd+2Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUN/PyW0eOW16K6tDmeqFVu10Q2+YwKt5EO7VWJJ2ZV+5JkXlYPQj303YWG72Xlwt5ii85DFxNDC97jWyKCnzGXpQjGU4kprm94ccDzc2sYZ3hTya0sbQIo8yJrfQ57Zy429CGUjHherXkrXC8uLoNaKkRoXSdVpJNLVxu3zPZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovsvoi04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovsvoi04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893EFC43390;
	Tue, 20 Feb 2024 21:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462851;
	bh=W+4zjgLoSeMu2Q0ZZRPiP87e2IDsS27OLY428cd+2Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovsvoi04a8OoA+fze+L5LtI5ozzs2P2zY5TtkF5EnXocrlJmT/Tk/THSE3nmK65Ck
	 45nnLyf26DBnnU32cERr2Aj77ozoTg4LQzX8vDLTbmWemBirJx3WzVR3kHzw9gs5xM
	 0ZjNc5pzFZ76Bjav2kx0gnUCdS5jdl04wBRKIJgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Saravana Kannan <saravanak@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/197] driver core: fw_devlink: Improve detection of overlapping cycles
Date: Tue, 20 Feb 2024 21:50:15 +0100
Message-ID: <20240220204842.756090086@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 191590055932..3078f44dc186 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2056,9 +2056,14 @@ static int fw_devlink_create_devlink(struct device *con,
 
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



