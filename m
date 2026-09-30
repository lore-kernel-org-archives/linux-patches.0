Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1A951CF6E;
	Wed, 30 Sep 2026 17:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789796; cv=none; b=qT3AJbRvfc/T6MmeGKCvHHjb7jU9uQ4D49Q2g18YuLdE9sAqtwp4IzrDp33gai36Oe8ktUpaPmeDIc5qGCLUuwJb+Q6NUel4FMqOJdi7zh3ppvkFN6yHzQs+SX9hMjX4S3WDzVwY6aS5+5hl7NMMuLe2v6JFUJITHD77pzc8Xa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789796; c=relaxed/simple;
	bh=n52TnoBOhoAVkCKesNeg/VJNmWFBSGffVy4x+h3KzuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bYrO9SxaNHqN/iZ9cxNCf7ffbcsYGNOqucQ+M3CK5myNqgyAchMKeY3/R6hRdE+X6p1PUVzm11pEmSzCKrzisecULoZmCCFEJwZM1zfZcGXrGVNXQ4cVwGHli+3pCLlnn8naaxnXYAuFMWguTvTQNFENaqzZWbsx5jz4CMevlNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCFJiAb2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCFJiAb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526721F00898;
	Wed, 30 Sep 2026 17:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789794;
	bh=RtCnzjGNwMY6lg2LRf6oa8rQ0mVid8IcrnGY8NxQjro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uCFJiAb2VRPUkvEiiKuqBpRNPYguJ9WiU3MiyCPSyiRG8w1QwGBrj4tB4csrmCC85
	 yL15FQobrvzOLXZojgsp9HacRlT0QOIyx8vMpFmX8XOU6OngalfpISs/LQAhJYja4z
	 C+GOIlF1cFhQANTZ1kRTUCIuA20MDbf5xw3+LH/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 604/877] i3c: master: Do not treat master device as a duplicate target
Date: Wed, 30 Sep 2026 17:25:15 +0200
Message-ID: <20260930152427.690891227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 4dc1b3eeba7991905a5b5b8129ebea51be7d87b7 ]

i3c_master_search_i3c_dev_duplicate() searches the bus for another I3C
device with the same PID as the reference device.  The search can match
master->this, causing the controller itself to be returned as a
duplicate.

Since the controller is not a target device, it cannot be a duplicate of
one.  Exclude master->this from matching so that the function only
returns real duplicate target devices.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
Link: https://patch.msgid.link/20260807145638.168865-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
[ adjusted the duplicate-device comparison to match the older branch’s PID handling without nonzero-PID checks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2024,7 +2024,8 @@ i3c_master_search_i3c_dev_duplicate(stru
 	struct i3c_dev_desc *i3cdev;
 
 	i3c_bus_for_each_i3cdev(&master->bus, i3cdev) {
-		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid)
+		if (i3cdev != refdev && i3cdev->info.pid == refdev->info.pid &&
+		    i3cdev != master->this)
 			return i3cdev;
 	}
 


