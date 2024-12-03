Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF641F4283;
	Tue,  3 Dec 2024 14:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237991; cv=none; b=IK8NGQkjG62T3jelWU+SeXPoliRPDvm/HqgBt64hQXyBV7x4KnGieX+29fbNYfonxgcbzL/YxzuHK37EVRznju0DlUTAlqM9GeGTz2vyhDjAnRqp0LmMKPxprxCAmuk5pn/UATw+eUXpOTxD2Sq099NXxX9eofNlQ/MhE6/0Gk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237991; c=relaxed/simple;
	bh=gBsl2hM9BpSCennFv0Jt4Ccjj9PHLKYlk5KGV818f7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6PfeYVZskJ8pONbpNcsoR7JQeA68OcWJJiMd+muIa/V58IJQiVREDgcGZKc0V4XsjiiONRyn8GpS1L2ifA/VBmldBZR7Rqa2sGfZaOkfbKqJvMlomQ2mwdgikfU3op1oKOY26Pu7Uh17BhkmhSaqbAsaxHXP6bIcrsJC7vPFa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlzW2Rvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlzW2Rvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D37DC4CECF;
	Tue,  3 Dec 2024 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237991;
	bh=gBsl2hM9BpSCennFv0Jt4Ccjj9PHLKYlk5KGV818f7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AlzW2RvpMg0GJaorJlaDhW1ZpXE0ur915CgVAfF6ksp0fpPAUegakjW65skU6qmHQ
	 +6gfQFr7rwIYVG0SipCWbOVwjpQg0oGFm0ngOG7AgaF1PD7bp75t7viA3GiwrGfSEX
	 M764eT3K+FQCPEnI64zEfxM7Ypi/XdpRMW9IC+RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 127/817] tools/lib/thermal: Make more generic the command encoding function
Date: Tue,  3 Dec 2024 15:34:59 +0100
Message-ID: <20241203144000.673696553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit 24b216b2d13568c703a76137ef54a2a9531a71d8 ]

The thermal netlink has been extended with more commands which require
an encoding with more information. The generic encoding function puts
the thermal zone id with the command name. It is the unique
parameters.

The next changes will provide more parameters to the command. Set the
scene for those new parameters by making the encoding function more
generic.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20241022155147.463475-4-daniel.lezcano@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 7569406e95f2 ("thermal/lib: Fix memory leak on error in thermal_genl_auto()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/thermal/commands.c | 41 ++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/tools/lib/thermal/commands.c b/tools/lib/thermal/commands.c
index 73d4d4e8d6ec0..a9223df91dcf5 100644
--- a/tools/lib/thermal/commands.c
+++ b/tools/lib/thermal/commands.c
@@ -261,8 +261,23 @@ static struct genl_ops thermal_cmd_ops = {
 	.o_ncmds	= ARRAY_SIZE(thermal_cmds),
 };
 
-static thermal_error_t thermal_genl_auto(struct thermal_handler *th, int id, int cmd,
-					 int flags, void *arg)
+struct cmd_param {
+	int tz_id;
+};
+
+typedef int (*cmd_cb_t)(struct nl_msg *, struct cmd_param *);
+
+static int thermal_genl_tz_id_encode(struct nl_msg *msg, struct cmd_param *p)
+{
+	if (p->tz_id >= 0 && nla_put_u32(msg, THERMAL_GENL_ATTR_TZ_ID, p->tz_id))
+		return -1;
+
+	return 0;
+}
+
+static thermal_error_t thermal_genl_auto(struct thermal_handler *th, cmd_cb_t cmd_cb,
+					 struct cmd_param *param,
+					 int cmd, int flags, void *arg)
 {
 	struct nl_msg *msg;
 	void *hdr;
@@ -276,7 +291,7 @@ static thermal_error_t thermal_genl_auto(struct thermal_handler *th, int id, int
 	if (!hdr)
 		return THERMAL_ERROR;
 
-	if (id >= 0 && nla_put_u32(msg, THERMAL_GENL_ATTR_TZ_ID, id))
+	if (cmd_cb && cmd_cb(msg, param))
 		return THERMAL_ERROR;
 
 	if (nl_send_msg(th->sk_cmd, th->cb_cmd, msg, genl_handle_msg, arg))
@@ -289,30 +304,38 @@ static thermal_error_t thermal_genl_auto(struct thermal_handler *th, int id, int
 
 thermal_error_t thermal_cmd_get_tz(struct thermal_handler *th, struct thermal_zone **tz)
 {
-	return thermal_genl_auto(th, -1, THERMAL_GENL_CMD_TZ_GET_ID,
+	return thermal_genl_auto(th, NULL, NULL, THERMAL_GENL_CMD_TZ_GET_ID,
 				 NLM_F_DUMP | NLM_F_ACK, tz);
 }
 
 thermal_error_t thermal_cmd_get_cdev(struct thermal_handler *th, struct thermal_cdev **tc)
 {
-	return thermal_genl_auto(th, -1, THERMAL_GENL_CMD_CDEV_GET,
+	return thermal_genl_auto(th, NULL, NULL, THERMAL_GENL_CMD_CDEV_GET,
 				 NLM_F_DUMP | NLM_F_ACK, tc);
 }
 
 thermal_error_t thermal_cmd_get_trip(struct thermal_handler *th, struct thermal_zone *tz)
 {
-	return thermal_genl_auto(th, tz->id, THERMAL_GENL_CMD_TZ_GET_TRIP,
-				 0, tz);
+	struct cmd_param p = { .tz_id = tz->id };
+
+	return thermal_genl_auto(th, thermal_genl_tz_id_encode, &p,
+				 THERMAL_GENL_CMD_TZ_GET_TRIP, 0, tz);
 }
 
 thermal_error_t thermal_cmd_get_governor(struct thermal_handler *th, struct thermal_zone *tz)
 {
-	return thermal_genl_auto(th, tz->id, THERMAL_GENL_CMD_TZ_GET_GOV, 0, tz);
+	struct cmd_param p = { .tz_id = tz->id };
+
+	return thermal_genl_auto(th, thermal_genl_tz_id_encode, &p,
+				 THERMAL_GENL_CMD_TZ_GET_GOV, 0, tz);
 }
 
 thermal_error_t thermal_cmd_get_temp(struct thermal_handler *th, struct thermal_zone *tz)
 {
-	return thermal_genl_auto(th, tz->id, THERMAL_GENL_CMD_TZ_GET_TEMP, 0, tz);
+	struct cmd_param p = { .tz_id = tz->id };
+
+	return thermal_genl_auto(th, thermal_genl_tz_id_encode, &p,
+				 THERMAL_GENL_CMD_TZ_GET_TEMP, 0, tz);
 }
 
 thermal_error_t thermal_cmd_exit(struct thermal_handler *th)
-- 
2.43.0



