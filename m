Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6D2134AC;
	Mon, 12 Aug 2024 16:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479983; cv=none; b=ee3uhXS5vwxjuxCi/ukm89KQ6yYYTN5RywE7TQ+CWInAHCZZfFIyu3HWQfnhVgn7skRaorOGPmYq4QADitJ/Qj/rKkk5Gwc749QuqEtXW32OPPEngqvMIyDmYX7YqC6T2PFSP8F4eDF9krNY7Wyd4jPMSJrl5LDWdgbzy2tBiAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479983; c=relaxed/simple;
	bh=kyJP5ZLxoqkJ/fu2bQ82Mi6PIMjkZ9ZfCV1BsEpvr7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8qKOKCnZOhhdblss8zjM0KbREf9AIxIch80X1sdM+IMQPkZuAEvq8O62hfzQcv1Qbt6ZbdAmzeZ19UPYkFTEh0lIP0MVk+ChIrspe92f4nZXRbJH33CgvMAYoX2SlMu3eWFTt6v+ueAGqPMnWVrR3Ge7QULv3xoWd/OBDp9Ok4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=an2l9tGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="an2l9tGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8753AC32782;
	Mon, 12 Aug 2024 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479982;
	bh=kyJP5ZLxoqkJ/fu2bQ82Mi6PIMjkZ9ZfCV1BsEpvr7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=an2l9tGA7Z1d7Od0zCzP8WnzZTYiaQdfbB+4xfrKAoXralsc40lMiDcYRgKSXrL6y
	 m5BtHRUJc9Z3j8uTgTmNXOLBKJNAy5aR+rwadC3RXh/47rTLRkOFWVPHY+M5NuMctO
	 2vALVmVggPbYpHaLftFx1cTN0SxgZZHpwWaRd+rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Connelly <amb3r.dev@gmail.com>,
	Tamim Khan <tamim@fusetak.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 061/263] ACPI: resource: Skip IRQ override on Asus Vivobook Pro N6506MJ
Date: Mon, 12 Aug 2024 18:01:02 +0200
Message-ID: <20240812160148.879577232@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamim Khan <tamim@fusetak.com>

[ Upstream commit e2e7f037b400aebbb3892d8010fb3d9cae6f426e ]

Similar to other Asus Vivobooks, the Asus Vivobook Pro N6506MJ has a DSDT table
that describes IRQ 1 as ActiveLow, whereas the kernel overrides it to Edge_High.
This discrepancy prevents the internal keyboard from functioning properly. This
patch resolves this issue by adding this laptop to the override table that prevents
the kernel from overriding this IRQ.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218929
Tested-by: Amber Connelly <amb3r.dev@gmail.com>
Signed-off-by: Tamim Khan <tamim@fusetak.com>
Link: https://patch.msgid.link/20240708000557.83539-1-tamim@fusetak.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index b3ae5f9ac5510..df5d5a554b388 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -531,6 +531,13 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "N6506MU"),
 		},
 	},
+	{
+		/* Asus Vivobook Pro N6506MJ */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "N6506MJ"),
+		},
+	},
 	{
 		/* LG Electronics 17U70P */
 		.matches = {
-- 
2.43.0



