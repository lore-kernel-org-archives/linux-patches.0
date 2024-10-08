Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A399B192594;
	Tue,  8 Oct 2024 12:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391463; cv=none; b=iXFXH+I416YC6zAdwq4G7Pl+C+vK114yt1ek/tF5U2w50VahJR88yUZVu21zj6v/lTuWmN4rZw5yTvqKPcPxdPkRL2jFX3p7oc0/H/9j6zcbtyMoBPOUfQjiiAFDYLbeyk829b9J32MgqbfJJ7f9IgNeNSEYxFHE7OwuIYjiBuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391463; c=relaxed/simple;
	bh=fHvC2Y2b4lyeGUs/ncuXAo6bXjnsQkJp8ya4QFyXofE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5oEHqIaojuTJLwx+uozvvbf3CFFdf25yFUrCS4LLcBta2nyFujZRwbF0oizaO2f1TM/nyxZE5vVXXxT5hIc2XQugVr7vDmDH4tuabKPe4YaS97R8gzRXPPXcTCxEM7qaAG99Bvhlj6IO4ouDjJ86MVS0Qsgb+V6ZRIASAMcmSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPV1Y3Fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPV1Y3Fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0957FC4CEC7;
	Tue,  8 Oct 2024 12:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391463;
	bh=fHvC2Y2b4lyeGUs/ncuXAo6bXjnsQkJp8ya4QFyXofE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPV1Y3FwBsc2VvkxBa2C56PADxdQ7ap4t++0nwD2BQV11CmDrktHTSDJRm+1/t/Ns
	 /xQU0Kr8F9GXFSgYynJIbSzmLMlngSf+vW37dIJJZBV4O33qEkkJRbPrhLiUqBRklX
	 BnILnxNuVRBsjKx0Vdm5Zq/DBSCSw8KhEVKd4SkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamim Khan <tamim@fusetak.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 105/558] ACPI: resource: Skip IRQ override on Asus Vivobook Go E1404GAB
Date: Tue,  8 Oct 2024 14:02:15 +0200
Message-ID: <20241008115706.500247990@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Tamim Khan <tamim@fusetak.com>

[ Upstream commit 49e9cc315604972cc14868cb67831e3e8c3f1470 ]

Like other Asus Vivobooks, the Asus Vivobook Go E1404GAB has a DSDT
that describes IRQ 1 as ActiveLow, while the kernel overrides to Edge_High.

This override prevents the internal keyboard from working.

Fix the problem by adding this laptop to the table that prevents the kernel
from overriding the IRQ.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219212
Signed-off-by: Tamim Khan <tamim@fusetak.com>
Link: https://patch.msgid.link/20240903014317.38858-1-tamim@fusetak.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index cb2aacbb93357..8a4726e2eb693 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -503,6 +503,13 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "B2502FBA"),
 		},
 	},
+	{
+		/* Asus Vivobook Go E1404GAB */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "E1404GAB"),
+		},
+	},
 	{
 		/* Asus Vivobook E1504GA */
 		.matches = {
-- 
2.43.0



