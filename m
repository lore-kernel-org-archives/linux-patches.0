Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E941C6FE1;
	Tue, 11 Nov 2025 00:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822692; cv=none; b=ZjdMkKLeFMWAprNL+4Tl9axZNYueqKLLkpHl5+87jcyJkqAh53mHtHS1BMVVUdSqe381I9lTziOrqC5KHKSovEXfyRxrPku2XwjZ0mTsITn8th9FSAR87DAQtd3Y7ttBs07KZGjXVsSspoEdsUHbrxnzT8mr3pRm4qX8cdCeCCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822692; c=relaxed/simple;
	bh=yP3T01gHyiqNe08dO0SbnQv/TZmcf3x7Cxc70h3zveY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBX+4ok7kuLQs5UnANjwXXfzrzcKvWn9wBoOqxi+rk1bw0r4BNGhqi50ooyGt3hGSrBx92uA4+UYBnAW50rGc/XehV5cn1xGtchvIBcVS0tKOiB2FHXU2T8VQIJDUnT9bZgyOvWFNMtBwD9IZr0aoyAvMbeCeZKApHgOXYmsItU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2p7V5YP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2p7V5YP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCD0C16AAE;
	Tue, 11 Nov 2025 00:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822691;
	bh=yP3T01gHyiqNe08dO0SbnQv/TZmcf3x7Cxc70h3zveY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2p7V5YP4lD/JfHkhJhKRUPE+bjYev6Ttpd+yXVcGewvMc/dBBjcb1bNb7j3haPXp5
	 eZ/roU+N5qRm/5f4f+ebe031XI97k6nWtIMIXz0GYm056jboSpBk83Y7RZdQ1N1v5D
	 ebG27kR/DY7YTMSj/1LSX58o58NZFE5n6xvkdM2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam van Kampen <sam@tehsvk.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 149/849] ACPI: resource: Skip IRQ override on ASUS Vivobook Pro N6506CU
Date: Tue, 11 Nov 2025 09:35:19 +0900
Message-ID: <20251111004540.020125036@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam van Kampen <sam@tehsvk.net>

[ Upstream commit 3a351de0d9c86e23b9eca25838b19468aab02f38 ]

Just like the other Vivobooks here, the N6506CU has its keyboard IRQ
described as ActiveLow in the DSDT, which the kernel overrides to
EdgeHigh, causing the internal keyboard not to work.

Add the N6506CU to the irq1_level_low_skip_override[] quirk table to fix
this.

Signed-off-by: Sam van Kampen <sam@tehsvk.net>
Link: https://patch.msgid.link/20250829145221.2294784-2-sam@tehsvk.net
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index b1ab192d7a080..ddedb6956a0df 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -510,6 +510,13 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "N6506M"),
 		},
 	},
+	{
+		/* Asus Vivobook Pro N6506CU* */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "N6506CU"),
+		},
+	},
 	{
 		/* LG Electronics 17U70P */
 		.matches = {
-- 
2.51.0



