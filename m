Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C73171A4;
	Sat,  3 Feb 2024 04:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933897; cv=none; b=QD5Uki1PxSV6NznfGjJxmDyzP87M7bXNJkjZcMfXbzSPvbZrCdBy4zHL3gkQDt+dsTXNm8cobIPdF5EsclPGCYQvTiNVY1ts3BJVIzp4CQQTX5hFuluOUMJP5ZqCfC8svuZa1grso5NfX0A4Z7wcGIPq9OCGEGoB/OZi+cXF6FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933897; c=relaxed/simple;
	bh=4qSYfVBcbauFAztjhdEOzRCSzsmzPslX/+jY4lJjEgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTU98A06MY4m24oM27oE3/sl6Ry3U4gAplnvc7o0beqn+0jXmrw0fO2Ngy8TmC906ewCylnUeJMT6/RbJkpqi07hipOvfaCfUmhQiOTqtmtxAU0yAi4Ql3V7DSNtRmqP1r6rRADh9jOuzuEEhctWgluLQu2UtpUvY0FC++xCbcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbEMf8Ah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbEMf8Ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E04CC43399;
	Sat,  3 Feb 2024 04:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933897;
	bh=4qSYfVBcbauFAztjhdEOzRCSzsmzPslX/+jY4lJjEgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbEMf8AhEr7asompB7eMoIgNkK+9lyds6jUPCwHIEnWqyzZWdtrDcYXO3nKypuemA
	 JfJa+HICg33/5LDlrmvYV5eor5xqewVUs0QqNHQZRes4UQ1SMmP/bhnR2qJQK57z3f
	 IUMPfh8TKqd8tSlkK+TgRClVUQLr82GrZsrOjzzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Mayo <benny1091@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 244/353] ACPI: resource: Add DMI quirks for ASUS Vivobook E1504GA and E1504GAB
Date: Fri,  2 Feb 2024 20:06:02 -0800
Message-ID: <20240203035411.423114467@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Mayo <benny1091@gmail.com>

[ Upstream commit d2aaf19965045f70bb2ece514399cdc6fcce2e73 ]

Asus Vivobook E1504GA and E1504GAB notebooks are affected by bug #216158
(DSDT specifies the kbd IRQ as level active-low and using the override
changes this to rising edge, stopping the keyboard from working).

Users of these notebooks do not have a working keyboard unless they add
their DMI information to the struct irq1_level_low_skip_override array
and compile a custom kernel.

Add support for these computers to the Linux kernel without requiring
the end-user to recompile the kernel.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216158
Signed-off-by: Ben Mayo <benny1091@gmail.com>
[ rjw: Link tag, subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index c3536c236be9..7d58d8b4ca76 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -482,6 +482,20 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "B2502CBA"),
 		},
 	},
+	{
+		/* Asus Vivobook E1504GA */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "E1504GA"),
+		},
+	},
+	{
+		/* Asus Vivobook E1504GAB */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "E1504GAB"),
+		},
+	},
 	{
 		/* LG Electronics 17U70P */
 		.matches = {
-- 
2.43.0



