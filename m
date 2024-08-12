Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB027134AC;
	Mon, 12 Aug 2024 16:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479979; cv=none; b=Db2qQTeALQFvi6Ug5BeT9DNTaz+D1xgPQjtyttHIDtQZIqxsUywnUZDP2gRIDDmWmDt26N4iJmeAHangl4mJaPaV/pxL+1ciDRxNV9Iw5RYbeosnhOmsStxVnWvfdsTDj5TWijefIA5hAS9OW9OcR1sNH7pnClK1BYqj0TVXGUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479979; c=relaxed/simple;
	bh=gCxdRtfsM3yJS2jgclgqrI/U/f3HaQRe4lhcvVMXjGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IM6VDoZJp+8et9BYaZO4z5PFkavxbBMYvBHijP37F1Kaku9yzZor9+8r/e9trtgP3EdNiePDuGL7bxe4sKfPx0Xl5BahOPKMl3nEJUFByFO/hZKP/94acLwWi6du5/0JUcgrNOQdwd/gi31akw0q09tRDSWCNHxoJzDgJKEjKug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcmtCqr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcmtCqr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263F2C32782;
	Mon, 12 Aug 2024 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479979;
	bh=gCxdRtfsM3yJS2jgclgqrI/U/f3HaQRe4lhcvVMXjGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcmtCqr7t1sO6kuaWeG71GmGR4DQX0th5QNdJj58Nb+ki4COWa+PuoxhJcc+s9jUK
	 IB8fK/xgHT3+QWTYi/0Yx87/xGvqMd16AZrO0FaCZCZJukoWAuoxSyxR75AWf4qWaR
	 bhJxfU4kFUYQUo9Uh2g0L/tZn0nkSPy6UcZ3foZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lefteris <eleftherios.giapitzakis@gmail.com>,
	Tamim Khan <tamim@fusetak.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 060/263] ACPI: resource: Skip IRQ override on Asus Vivobook Pro N6506MU
Date: Mon, 12 Aug 2024 18:01:01 +0200
Message-ID: <20240812160148.842000884@linuxfoundation.org>
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

[ Upstream commit dc41751f9e07889d078e3f06adb6e892c80b7c10 ]

Like various other Asus laptops, the Asus Vivobook Pro N6506MV has a
DSDT table that describes IRQ 1 as ActiveLow while the kernel is overriding
it to Edge_High. This prevents the internal keyboard from working. This patch
prevents this issue by adding this laptop to the override table that prevents
the kernel from overriding this IRQ

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218954
Tested-by: Lefteris <eleftherios.giapitzakis@gmail.com>
Signed-off-by: Tamim Khan <tamim@fusetak.com>
Link: https://patch.msgid.link/20240702125918.34683-1-tamim@fusetak.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index b5bf8b81a050a..b3ae5f9ac5510 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -524,6 +524,13 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "N6506MV"),
 		},
 	},
+	{
+		/* Asus Vivobook Pro N6506MU */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "N6506MU"),
+		},
+	},
 	{
 		/* LG Electronics 17U70P */
 		.matches = {
-- 
2.43.0



