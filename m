Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31E4415F12;
	Tue, 21 Jul 2026 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656528; cv=none; b=eftkXmz3SDgbXddHgKby18FtPLaVZG4NXPwDmAlZ0inkj89go51DN5/y0AHlg3Af9OAbvzejhjEVqmLwA3PvLnVMYAhf/X5pQ6Sp0ywZ3XdBk5uhhgCZDmyjxyoXSHVKLuQbzRkF+jZOr/s7JXMKWfcNtr8Bxx+OR2ZA2ZWkB9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656528; c=relaxed/simple;
	bh=xAf1LgRZUHTKQtrpMbrauemWYT0fUnNeOrGC8f7oqbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nl8OSB143Nkj4wUplS/llOtGelEyaEyunOfpx3vct5/k/nFndYxCXebR7gGsVpcPv1fcxjs8LQpHekoHLW65mhWnvN0glO9TAmfZ9LR6ZSmNDO2Gdy9GNJgO3f12hEpRLDJAtvpPF/IHx0PQ2VoAL6z0ECUUJHUnEQYQhvrhRMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNxuNE+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNxuNE+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BD01F000E9;
	Tue, 21 Jul 2026 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656526;
	bh=X0jWm7q26kW0EsnibJZO+OPc0Z652aaN5tZOp7djpn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNxuNE+j8rK/mtWXkXTelUFOBsQpaHhiPLdbR5BL07IuUy/BF/RyLHcWhGTI8JKTL
	 7bA8DDx10OjneKReVuIkP4oJr6f5ZmPKKNlvuva+AYmhwvcjBdK71gZDe13wW2lvhw
	 ImurxhmUlmuAz4zNgfY8boTQ4i+sT8SvVn7xkPqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0378/1611] thermal: testing: reject missing command arguments
Date: Tue, 21 Jul 2026 17:08:14 +0200
Message-ID: <20260721152523.695684892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



