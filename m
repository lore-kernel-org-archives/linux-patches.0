Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E4E3ED3B2;
	Tue, 21 Jul 2026 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649351; cv=none; b=ibYK5Ji5j5/brA86U+Ei7tVOVL5BE4Mz1mAwdlG1qUDpusWULMKWxmMo9RUPWQVbPp6tLFuypnU1G+QriSWnDwWQ86rEFtNMyktlghCrqtvhFw2bZCiFpwqojAzuJnVG4VN4jNSKMOEsvAtVvPvwmlatI2fjhotNxPzTNEiXLVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649351; c=relaxed/simple;
	bh=xyaL2q6SMLdpWInyT9uQwBy5fuj2tGSWILu6AZjhwhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj+d/rYUoTHrCyPsj8DSTDx7H8QCMSDvGO6n/yRV+a7c+0L6XRiMvokj3ywCJgi+Y13wkSPYkJcNnth0ke2TKoW4suXgV1gFsOmsUZt+BqG5lOD6rjtWsuF8Nq+naLYi3S9CB1d23o3EmHX7MHQwry5sBfK4QMm2M1bWFijllyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJZDWFrN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJZDWFrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85FE1F00A3A;
	Tue, 21 Jul 2026 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649350;
	bh=V3mARM5MPERPACq7g4bD8AzwklWhMX4x7goqgaQhiY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJZDWFrNB7vkGbHK380PYWLDsRVbmO8lMjnWF1M3k55qhnXYk3BtBur+Ra1fWWZ6w
	 zsH19sfPhk+XAai3Kqmgva3kVJ4v8lnNSgS+6LMV17KCdAW6vPK9rKiYtviLCsz7yj
	 QMG5t9gB34niYyBMteA/Vd1DdBAEhivQ23PXf/9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0543/2077] thermal: testing: reject missing command arguments
Date: Tue, 21 Jul 2026 17:03:36 +0200
Message-ID: <20260721152605.616442419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit ef3e98b0aa4b348f44065d7130251273c83bd204 ]

The thermal testing debugfs command parser splits commands at ':' and
passes the right-hand side to the command implementation. Commands such
as deltz, tzaddtrip, tzreg, and tzunreg require a zone id, but writing
one of those command names without ':' leaves the argument pointer NULL.

The command implementations parse the id with sscanf(arg, "%d", ...), so
the missing-argument form dereferences a NULL pointer from the debugfs
write path.

Reject missing arguments in tt_command_exec() before calling handlers
that require an id.

Fixes: f6a034f2df42 ("thermal: Introduce a debugfs-based testing facility")
Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Link: https://patch.msgid.link/20260605185212.2491144-1-sam.moelius@trailofbits.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/testing/command.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/thermal/testing/command.c b/drivers/thermal/testing/command.c
index 1159ecea57e7cf..fbf7ab9729b5a5 100644
--- a/drivers/thermal/testing/command.c
+++ b/drivers/thermal/testing/command.c
@@ -116,18 +116,30 @@ static int tt_command_exec(int index, const char *arg)
 		break;
 
 	case TT_CMD_DELTZ:
+		if (!arg || !*arg)
+			return -EINVAL;
+
 		ret = tt_del_tz(arg);
 		break;
 
 	case TT_CMD_TZADDTRIP:
+		if (!arg || !*arg)
+			return -EINVAL;
+
 		ret = tt_zone_add_trip(arg);
 		break;
 
 	case TT_CMD_TZREG:
+		if (!arg || !*arg)
+			return -EINVAL;
+
 		ret = tt_zone_reg(arg);
 		break;
 
 	case TT_CMD_TZUNREG:
+		if (!arg || !*arg)
+			return -EINVAL;
+
 		ret = tt_zone_unreg(arg);
 		break;
 
-- 
2.53.0



