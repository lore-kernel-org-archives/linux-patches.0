Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9F62FFDEA;
	Tue, 17 Mar 2026 17:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767211; cv=none; b=XQMurDmGTUb8cLTjycweE29JvpCGVdbsfBZIC7VlhMH336GMdZ300QvyUtBlPIyzPOqpT+zZriT6uIGzkZIAC9CInokRoCIz0luiUmA6sqe1mjKqGQItwBNNneFkspH/Zq+pFrCh02Id+EoDebAOPZ1n5wDA2PyuOfGHiXobPkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767211; c=relaxed/simple;
	bh=i3op2QGtCu8cQK8d0LzmoDLSc0DSyuDra3iLaDU6oV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAXCBbO9qdKBseZJoEYY0yQta0dHeGz4m+iG9kc8aY/oBlgF7v08DYb1HpMm8Vy0Gb1pAp8c77iywhyQeMQM3zuMVddxQUvIal0+uqf4O9AnZPjOhFZpeCq6c3UMMGJ1do4rlJwZHkQACLGkIVJ0teH2ep8sZy8BrjbLpdaenhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M81EWIB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M81EWIB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BABC4CEF7;
	Tue, 17 Mar 2026 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767211;
	bh=i3op2QGtCu8cQK8d0LzmoDLSc0DSyuDra3iLaDU6oV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M81EWIB/nWiijbMQzI7E8KLTCfmVdeOVqu8OkTXLGnXve/bM5NlORnX3VvR2vTr2Q
	 tnDzmesQchiMdTabCQpEjPNlORaDxZZ9Oi0gOrEb4hu92pzvH7FhnHn1hSQIVRPKSf
	 vYM+nhL6UXI/90n2ze6Yyiok13Ij2wzYOpd7jH0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sofia Schneider <sofia@schn.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/333] ACPI: OSI: Add DMI quirk for Acer Aspire One D255
Date: Tue, 17 Mar 2026 17:30:38 +0100
Message-ID: <20260317162959.702118473@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Sofia Schneider <sofia@schn.dev>

[ Upstream commit 5ede90206273ff156a778254f0f972a55e973c89 ]

The screen backlight turns off during boot (specifically during udev device
initialization) when returning true for _OSI("Windows 2009").

Analyzing the device's DSDT reveals that the firmware takes a different
code path when Windows 7 is reported, which leads to the backlight shutoff.
Add a DMI quirk to invoke dmi_disable_osi_win7 for this model.

Signed-off-by: Sofia Schneider <sofia@schn.dev>
Link: https://patch.msgid.link/20260223025240.518509-1-sofia@schn.dev
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/osi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/osi.c b/drivers/acpi/osi.c
index f2c943b934be0..9470f1830ff50 100644
--- a/drivers/acpi/osi.c
+++ b/drivers/acpi/osi.c
@@ -389,6 +389,19 @@ static const struct dmi_system_id acpi_osi_dmi_table[] __initconst = {
 		},
 	},
 
+	/*
+	 * The screen backlight turns off during udev device creation
+	 * when returning true for _OSI("Windows 2009")
+	 */
+	{
+	.callback = dmi_disable_osi_win7,
+	.ident = "Acer Aspire One D255",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "AOD255"),
+		},
+	},
+
 	/*
 	 * The wireless hotkey does not work on those machines when
 	 * returning true for _OSI("Windows 2012")
-- 
2.51.0



