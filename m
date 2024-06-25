Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1660A148315;
	Tue, 25 Jun 2024 09:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308280; cv=none; b=hTKOoQ/NE0u/5F4mJLfW0sKE2VA60V3UZg0yQ9yKqt6tNdNy3oIEelYmDcbymNHIDe16Q8130C7dNzitRTSWsEC1+rATlGrY3Rv4DE/eSci6YXJfvV2n3jhKaeZxMBFshQPEud9dhUR2hsJ6DF2yfpAupTLMiE4MwCOoshDjAzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308280; c=relaxed/simple;
	bh=mvuwVo6UG2rudSks50/koAGS+olELBdegIngQkRg9jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3SVl3RuyosxAS9WNpwZI4I1u3qFqypLByDQ9mNOe7Q/6pBznjwELu5Vn8+8plqjJjEBV/pYUg5hhkCXHSooPGhiq5lEXNr4uGR8aE46hhGusjO+IQ+HxyTnY4/KrFIq/2sRIXln56nQCui0s8TOcObDwKnrfJ856QmURyqlDYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQ/9dpyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQ/9dpyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2DAC32781;
	Tue, 25 Jun 2024 09:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308280;
	bh=mvuwVo6UG2rudSks50/koAGS+olELBdegIngQkRg9jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQ/9dpyEYrrmpLh8cPeVKvdtl9fPvF94kgMshw9RUZ9M4SqjAutB2V4Q39WtY1Ngh
	 x9gU3lGPh8RO46y3m4PswYybL/DNypQjDTIFW8E7odxPxpsHVUZAovKAF6g430xAre
	 ilyz/O0zd3UqBxU0DIwxXiPu89kOxCSBhdz0+e2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gianni <gianni.casagrande.mail@gmail.com>,
	Tamim Khan <tamim@fusetak.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 036/250] ACPI: resource: Skip IRQ override on Asus Vivobook Pro N6506MV
Date: Tue, 25 Jun 2024 11:29:54 +0200
Message-ID: <20240625085549.444147840@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamim Khan <tamim@fusetak.com>

[ Upstream commit 7c52c7071bd403acee8cb0064627d46c6c2a1ea3 ]

Like various other Asus Vivobook and Expertbook laptops, the Asus
Vivobook Pro N6506MV has a DSDT table that describes IRQ 1 as ActiveLow
while the kernel is overriding it to Edge_High. This prevents the internal
keyboard from working. This patch prevents this issue by adding this laptop
to the override table that prevents the kernel from overriding this IRQ

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218745
Tested-by: Gianni <gianni.casagrande.mail@gmail.com>
Signed-off-by: Tamim Khan <tamim@fusetak.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 65fa94729d9de..b5bf8b81a050a 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -517,6 +517,13 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "E1504GAB"),
 		},
 	},
+	{
+		/* Asus Vivobook Pro N6506MV */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "N6506MV"),
+		},
+	},
 	{
 		/* LG Electronics 17U70P */
 		.matches = {
-- 
2.43.0



