Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E359F2505AA;
	Tue, 11 Nov 2025 01:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822806; cv=none; b=j4e45UoyLtBPxIT+PRvBBOP1JKsPYOrUthCm6dPDApO/3j7+a79ITRAG8yOFQEbL/zG5UKx1qtST/aQDrvZLuZlcbkt70EJm7DLm05F7h7HjjKA9hav/UilT3cZL8rS7NxE9Jt87sCRaZ06Db/grBp975k2MNb/3DKKh/4H9Nh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822806; c=relaxed/simple;
	bh=FV8J7uopejTU8V7QQ3+C+mXqvpEmoXr67SZMe2tHjig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3P9B5e92g50Axzj/S2o01T6AJ789L7iqgdRTZlLrrpSBVOvuDuspiuJf2pS6OTU8jmi9UP8QFAqB/YMe8A86SGWSArCTqWNnLghr/lDpx29ig94uIjGNjFunJa/PsI7N0mwljx6sylo5y/e5QU2o3LXWaSZi+JpKmjAUTHXFK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZY1ug+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZY1ug+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CEEC19421;
	Tue, 11 Nov 2025 01:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822805;
	bh=FV8J7uopejTU8V7QQ3+C+mXqvpEmoXr67SZMe2tHjig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZY1ug+FIyfmw33W8KOSlwbgok6YWfnWsvJ/pbfJ6OQgHUpAJbTTBInKYC133DTlx
	 YuX5O5qAz9k8nDrxm0KIKxSS7jSyfnukEaoym/n7R1Jez0XHDo68BgaNo8Y6J1JhQ+
	 t526WqGScU/XEo3W5w4rKyEq+3kDZiiXC9zsub8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam van Kampen <sam@tehsvk.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/565] ACPI: resource: Skip IRQ override on ASUS Vivobook Pro N6506CU
Date: Tue, 11 Nov 2025 09:39:28 +0900
Message-ID: <20251111004529.474638236@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 7d59c6c9185fc..4937032490689 100644
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



