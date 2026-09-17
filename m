Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E93547057;
	Thu, 17 Sep 2026 17:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667404; cv=none; b=B2Oefg0lqszQsLROb91FSLbN7ox8TgdTgFwAR80B1FuWgrXigGMkXl8PqJ5PO9BXKhBihfxC6asIpfJ2FMhUzWK+g0bLZPWIxInmWwwHZoMANxdAVLYLyIbLD+XcotxeIIn/FKUn7XGe2IF+SpwtAn2fThVRDESb5hFmYL9HBrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667404; c=relaxed/simple;
	bh=9g2vyp7zb/JsxwkACrS6+IcSY3BHbk6iD+6l6c/0oxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZBxqcW2DRvDn8X3tnzAJuLxHGgyPg1YdQQWsqnpqhZCrpG8+niS3Y+u4MAVXv5mpCQ9/R6hkS+S0ZOp5mUA1mAIZorwVtzzoWpWy1qgbrAIkBANwhFNvLiWIVbtMpr5+zc5HMpXt6hHXtkEARlw4JWBD31rTlFTISIf7bBtNoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGImmmFT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGImmmFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5511F000FF;
	Thu, 17 Sep 2026 17:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667402;
	bh=VrGq8BT6JWpY30di43N6DL3aboPLbXmGtQQNdInEofk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGImmmFT5iFpxh016t9ZcI6Na/xz3aNdZIaX/RORpXQM5UZNmD8TyG82oOlTD0Uxu
	 UoQCBUL3s2uKTK4A5KashF5jipqKk6HPDGI/jQfsERvbl1hqivcLyMl6+xkEYAew4w
	 ZU8LGVakpUp0l26xuNi8Kcw/QxXyoI4NgigbRpeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0080/1102] drivers/of: validate status properties in reconfig state changes
Date: Thu, 17 Sep 2026 16:00:23 +0100
Message-ID: <20260917151541.481833821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0b6b12c5dcce16e604d4cde953bef46531b98571 ]

Live-tree reconfiguration properties also carry raw values plus explicit
lengths. `of_reconfig_get_state_change()` currently treats `status`
property values as NUL-terminated strings and feeds them straight into
`strcmp()`.

Factor the `"okay"` / `"ok"` check out into a helper that first verifies
that the property contains a bounded C string within `prop->length`.
Malformed `status` updates should be treated as not enabling the node.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260507081812.91838-2-pengpeng@iscas.ac.cn
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/dynamic.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index 77818436fd60a..e206fd916c1c9 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -74,6 +74,20 @@ static const char *action_names[] = {
 	[OF_RECONFIG_UPDATE_PROPERTY] = "UPDATE_PROPERTY",
 };
 
+static bool of_property_status_ok(const struct property *prop)
+{
+	const char *status;
+
+	if (!prop || !prop->value || prop->length <= 0)
+		return false;
+
+	status = prop->value;
+	if (strnlen(status, prop->length) >= prop->length)
+		return false;
+
+	return !strcmp(status, "okay") || !strcmp(status, "ok");
+}
+
 #define _do_print(func, prefix, action, node, prop, ...) ({	\
 	func("changeset: " prefix "%-15s %pOF%s%s\n",		\
 	     ##__VA_ARGS__, action_names[action], node,		\
@@ -135,11 +149,9 @@ int of_reconfig_get_state_change(unsigned long action, struct of_reconfig_data *
 
 	if (prop && !strcmp(prop->name, "status")) {
 		is_status = 1;
-		status_state = !strcmp(prop->value, "okay") ||
-			       !strcmp(prop->value, "ok");
+		status_state = of_property_status_ok(prop);
 		if (old_prop)
-			old_status_state = !strcmp(old_prop->value, "okay") ||
-					   !strcmp(old_prop->value, "ok");
+			old_status_state = of_property_status_ok(old_prop);
 	}
 
 	switch (action) {
-- 
2.53.0



