Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0AE56C641;
	Thu, 17 Sep 2026 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661204; cv=none; b=QYHjiW0FErJuiNP0hEU55uPS5drDfLiPn7WCCNNUhIrdkpkUK2Gb9zIBWMOF1kW/avlC6BeS1SsruhLQdbZg8pO/Nf7G8+ygMQkHGFp2ioN4VuT7DsU0oPqjn/VKGFAZL7uA9rjiy9AuWpSGsDfTBIgytqTvkNhuX/RDyrRZITo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661204; c=relaxed/simple;
	bh=blactdBWtjvQugmVjrrcikuYrP4gq6jocMsbqaCVezI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAvKxOJBSNCT7q0JD5WcTVHQ0JgaueC8cB0CERPnY9SiKDjxg7XKdyHd79SjlOXLry4YvM5w6uQIbZUkh4FnscVEH4bjpb5v8HfBiQufKRyD9DvgA4OYj3ZMNgNiQYeYSorYO8mbiKXMEYAVyh20QI9+xlMRmHt3dfwA2RHGKCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrCSWn8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrCSWn8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671B81F00893;
	Thu, 17 Sep 2026 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661203;
	bh=q7DfFpipCTkVNh3D8fiVynMfktCgM05xtiT1A52C0cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrCSWn8jKpIpP2EvbHK38C0KHJ6NEgTGZ1CcKH/s4kcM4UXzfaCflCe6CckJ7Z9Dk
	 VxvuEYDg63VUjJmglyAQG+rzXAiCtS1jw0V7bCMK//ondRayBZsCWeTu0Jnk4UUGnM
	 CYK1+WOq9/qJ/wj0lgyHGRyPkjq9+cuxSMHyVmAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0115/1250] drivers/of: validate status properties in reconfig state changes
Date: Thu, 17 Sep 2026 15:58:30 +0100
Message-ID: <20260917151555.132018867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index b5be7484fb36d..3e08484d351b4 100644
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



