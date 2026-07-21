Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA43042DA53;
	Tue, 21 Jul 2026 19:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661968; cv=none; b=j9pfbqZBR4VTI8JqNMIRVc0tHEFxDqjBZPtOk7m8vv7BLOXR5Iov+t609ziW7dYsex2MBuFqjQ8dwM7hgm79gi0mqXWwvnxEy63yDm6JvTKqR7WfTfR9IURhENNut79vXyHgA0LpO2tLtH4KBqORY/mMjd0NOrAckq+9vRT3VHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661968; c=relaxed/simple;
	bh=jj2BdQjNK9ofyxclvXQb3K7RBJun0AMAekyvN2MSaXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRv5hFytQ1GHfbbUgp1fe65tycy3RlA8M6fdu1sJdfjZ0z6oRudbVZZZJO4xjxhtxPNT9sEmFQ3Kz5pdnQTfOFElNLMP66LipFpXr2EIaua//aFSRTJwLK0B5t56NSQN8n+umEzLlADtxRkRKnGh0sTp+1YVFmY2fs1LbkvzRI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWeUwPji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWeUwPji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5642A1F000E9;
	Tue, 21 Jul 2026 19:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661966;
	bh=r0FkbrBu7blNZJF/QLEm4wttUftQwQikiN/NiYc7B58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWeUwPjiXKobn2KrkjSHwfFwUAyx0ru0Xg75ubfGUn0517PGleaerbvdK7bfe0uSw
	 e/31dnAm6WgmXw1jyDDy+23G2yCPyV8tSsX7PtChByjetPI14koDDItVBjqe0pTGbP
	 qLkTo5wJTmhmzaUDxjBwrthJDamxKIY1P6/pQlec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0265/1276] thermal: testing: reject missing command arguments
Date: Tue, 21 Jul 2026 17:11:48 +0200
Message-ID: <20260721152452.012806413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index ba11d70e80219b..3c99a771aa6d7e 100644
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



