Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30923B6377;
	Wed, 30 Sep 2026 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793987; cv=none; b=lE86o0HR5eP3yaSX6LUZtBY4vLhbJp/P38hW7AWQsNzAA2dc9ewAz4dsodUQAtrt5zOEFW3lOTcwE7HXSEy2aiO2tdAJHri/fFrG27bM1z2T6wGcywT9f/6gMs7ng7XldElPkkSOEtMr/rYbWNu+4mzE8k3i+KqsbBm7hv1UE3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793987; c=relaxed/simple;
	bh=TTO1DHMER6cTtvgbj/SL91YDSkRQmQzX+IlNHDQH574=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfme6dbHGG78iP7o8V0xZEED+yPWjSVAv1YUndSqXXrLbfZsK/c/e1j7YsCssKkwQK69T8OI/ActihpWHx1JlMizeUUwd84wDDgD+MQTm0gZ52tsqdCG2vwjNLcwka9SUrVq9iY18sAfGXvqIHat2A8SYe28RIf9MikKgZz9B3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rgjn+sD+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rgjn+sD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4E01F000FF;
	Wed, 30 Sep 2026 18:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793986;
	bh=otLcdnAF5xyflU5m3g5fXkof/twA945pHa0WAgs4dSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rgjn+sD+PtDsjyR+FXemTHDEbRE46U10MFTDeERnn7eT0mwwzAzPR2WoMHizEC97R
	 xz4aCrLTo1aMw0JOpL4AUstH/fo+ByLo8pBv9OzYqY3ONVv11FUgzNexuk1eEt1X+U
	 4JctpfrrPC9paGFRo94AkBQhAxtYwxQZoYpvJ8ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0050/1193] drivers/of: validate status properties in reconfig state changes
Date: Wed, 30 Sep 2026 17:12:14 +0200
Message-ID: <20260930152435.391685946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 9cc0f4ffb8142..46a7626ad282f 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -73,6 +73,20 @@ static const char *action_names[] = {
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
@@ -134,11 +148,9 @@ int of_reconfig_get_state_change(unsigned long action, struct of_reconfig_data *
 
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



