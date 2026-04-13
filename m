Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7E613A86C;
	Mon, 13 Apr 2026 16:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098704; cv=none; b=oFNaLit4kPwCophe7JbZzkAKQHSnwLOdu1k61Zc5ubPR1xaSP68Wp3mEbAzzBEszE/gJdJHEg5mHNDov+SJagxs1bc38E3NvAbLoJTwGE3TurXmn518qp8K7yaKDujVgAizNU/FpqDleUwbT23agZOOAE1bUezlgVyNFkxm3YUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098704; c=relaxed/simple;
	bh=NGLBIvoUPi7o42ev+T56BNPIcUTH+873hzywPvAoxYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHFE2OuqXteFaWFIPLpvC7O8Svk3sI7Qav6jYvo+Jr7H7flzrHuq76Pjm9olVkKZlY3Qk80Z0ZZuDOJHz0e3cjmOi87Ya/xoLSgZKuXyw9fMazrpwUhylJV4QJDXELms88AB0WK3gH3n04TjGQ15PsPXk2KDSOiFfcir9EhWXQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imI94u1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imI94u1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A684C2BCAF;
	Mon, 13 Apr 2026 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098704;
	bh=NGLBIvoUPi7o42ev+T56BNPIcUTH+873hzywPvAoxYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imI94u1tiCzJEwnOW9GZ5SaaE5Yv3atYPCzuE/6kPEsfKuDGTBTvcwSgnlCFgPuLd
	 WZ7wqK8+npprzJ3DQVAp7XxG/54MnIyoffw2whLCImsXIqO1Rcc/iw/USFZ+UtXmS/
	 AsA59NEUMPC0wCe6wsExB90md483cv3Ren20oRMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sofia Schneider <sofia@schn.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/491] ACPI: OSI: Add DMI quirk for Acer Aspire One D255
Date: Mon, 13 Apr 2026 17:55:01 +0200
Message-ID: <20260413155821.147371251@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d93409f2b2a07..6913264490225 100644
--- a/drivers/acpi/osi.c
+++ b/drivers/acpi/osi.c
@@ -413,6 +413,19 @@ static const struct dmi_system_id acpi_osi_dmi_table[] __initconst = {
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



