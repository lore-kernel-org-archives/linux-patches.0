Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCCF345725;
	Mon, 31 Aug 2026 13:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183912; cv=none; b=XJxhaanDsFy7XeJppTI+pey3PhNpCMRsZnLJcjFkgDBGd/He0j+ruUAyLS+d+yBXDh8Z5enPR8pUxmGMJyf0BIYptxXQ1K1IL4/QOw0Urn+Q5RCZMfhDKNCvc+dI6ck6x3WolEfEm85Lal8MQtimkXzs46lvbzotsHS2Rtq7ZnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183912; c=relaxed/simple;
	bh=pUPoRK0PlWqnE3rD7pUfw8ucAHK5FYCJdZ8cu/VqBuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uxdYKFbRs1fVXl97m26rokUITUW+DIsb5Wk8zjZQxESNLXM5NfhO8HGHPJ6JkEkol0ZhCVtlqpm2kdVUeV7ahoBj+f0bvUChJyRNcKNLqtKzV4MOeNODrNYn2c4D9tYYNczquy+4LminBUSEcYY8CVvklruegi0Up4sgFZlpWYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LV6enQ37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LV6enQ37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86151F00A3D;
	Mon, 31 Aug 2026 13:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183911;
	bh=UuqXvgZlLk8azWYKGyjz6OEwqXiLwJfHaMuEOTGTnqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LV6enQ37/hPnucCZXN8eJxCPu3Wh4HDIauL0Y5pvu5VdTsoVMWpS05GbHqbfSnrog
	 yalVyKunYsgVC90V0SCi/bFE5JvJbZT4WA+X1jUF/rVFGBG+y9rXRgmAMnwyOZ+WZM
	 YzxxBMFn/+0bEDoDMNTQ4m2O0IewupqkV6CRc83sYtjtWafR/j0ak3w+SnQ8bCS3RB
	 IFO0LtqUBoZVdrjjyvEVcoiHyypxi/nTrUHeCqYTYPpMSysP209+FKLXZjAuO7zz7H
	 o5a2ZXrY/mKMXC80j7HguK26tEtEdlHxlOC1tUfmVNERnnxw/IilXYBiNtgzURrJiP
	 17FFt5+WEqpyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Armin Wolf <W_Armin@gmx.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	corbet@lwn.net,
	nathan@kernel.org,
	nsc@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] modpost: Handle malformed WMI GUID strings
Date: Mon, 31 Aug 2026 09:26:44 -0400
Message-ID: <20260831133314.4125787-376-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 3429ae7b2f02a4a6ad40d36ee06641d433d75a1b ]

Some WMI GUIDs found inside binary MOF files contain both
uppercase and lowercase characters. Blindly copying such
GUIDs will prevent the associated WMI driver from loading
automatically because the WMI GUID found inside WMI device ids
always contains uppercase characters.

Avoid this issue by always converting WMI GUID strings to
uppercase. Also verify that the WMI GUID string actually looks
like a valid GUID.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260610203453.816254-10-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git searches finished. They didn’t turn up the modpost
WMI GUID commit in this 6.18.44 tree — it’s still only a candidate. The
closest related in-tree commit is `97b726eb1dc2b` (msi-wmi-platform
lowercase GUID typo), which lines up with the modpost fix but doesn’t
replace it.

That doesn’t change the earlier conclusion: backport **YES** for 6.18.y.

 .../wmi/driver-development-guide.rst          |  2 +-
 scripts/mod/file2alias.c                      | 28 ++++++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/Documentation/wmi/driver-development-guide.rst b/Documentation/wmi/driver-development-guide.rst
index 5680303ae314e..ae577a290afc3 100644
--- a/Documentation/wmi/driver-development-guide.rst
+++ b/Documentation/wmi/driver-development-guide.rst
@@ -54,7 +54,7 @@ to matching WMI devices using a struct wmi_device_id table:
 ::
 
   static const struct wmi_device_id foo_id_table[] = {
-         /* Only use uppercase letters! */
+         /* Using only uppercase letters is recommended */
          { "936DA01F-9ABD-4D9D-80C7-02AF85C822A8", NULL },
          { }
   };
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 4e99393a35f15..20e542a888c49 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1253,6 +1253,8 @@ static void do_tee_entry(struct module *mod, void *symval)
 static void do_wmi_entry(struct module *mod, void *symval)
 {
 	DEF_FIELD_ADDR(symval, wmi_device_id, guid_string);
+	char result[sizeof(*guid_string)];
+	int i;
 
 	if (strlen(*guid_string) != UUID_STRING_LEN) {
 		warn("Invalid WMI device id 'wmi:%s' in '%s'\n",
@@ -1260,7 +1262,31 @@ static void do_wmi_entry(struct module *mod, void *symval)
 		return;
 	}
 
-	module_alias_printf(mod, false, WMI_MODULE_PREFIX "%s", *guid_string);
+	for (i = 0; i < UUID_STRING_LEN; i++) {
+		char value = (*guid_string)[i];
+		bool valid = false;
+
+		if (i == 8 || i == 13 || i == 18 || i == 23) {
+			if (value == '-')
+				valid = true;
+		} else {
+			if (isxdigit(value))
+				valid = true;
+		}
+
+		if (!valid) {
+			warn("Invalid character %c inside WMI GUID string '%s' in '%s'\n",
+			     value, *guid_string, mod->name);
+			return;
+		}
+
+		/* Some GUIDs from BMOF definitions contain lowercase characters */
+		result[i] = toupper(value);
+	}
+
+	result[i] = '\0';
+
+	module_alias_printf(mod, false, WMI_MODULE_PREFIX "%s", result);
 }
 
 /* Looks like: mhi:S */
-- 
2.53.0

