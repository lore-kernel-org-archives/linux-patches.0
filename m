Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DFB23B604;
	Mon,  9 Feb 2026 14:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647484; cv=none; b=sEpNRdJH0IMiPYWdapPNZLE7yFMJavKqUDjCZECsdrP+pexuZxpSGqU/1BoVruSffDlsN4w+7Nrr5RsixYivr731ke3wIhrYLKzITpo/eZEH9wgNtY5eMo33wA+k8kfQG3scfSI33i5R4Y5o7t/uYhRxbuSmw/l8ojycu9zCckg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647484; c=relaxed/simple;
	bh=Woox1MbkWpl18VcAFzrpkV4p51pP4Mjv5TAMbBsyb3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nG0LCy5+rzNFV2QcP8aYhBIyJkXrJd1DqdXzWCB9/OgXXeKUrBWLa2WlpIAKVkGn3MrU4mtsGAGyP4YsoLOckWa8Z1WwU8XLaGFJvPRHPPdXRwRqRyZcvAMadsgOAsmVZPqWuGjXvePySpb2krUjgUNyO78c9b/tDoORB+5uPRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrI4x8yn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrI4x8yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A09EC116C6;
	Mon,  9 Feb 2026 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647484;
	bh=Woox1MbkWpl18VcAFzrpkV4p51pP4Mjv5TAMbBsyb3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrI4x8ynmDdg5SZJb31R2xWIH7rTvauWO0+b2fCLzMSdxwDVmvkLl/+RDx1Zek2sz
	 hSmfthx1WjAB017XAykfApHgHw3HgHz9xEScjDNq8DG+c22dKWK0S8RevSmMNGfCNm
	 lPTXX7zbExl8vEqAOYWJxymBCUVxn29R3OQDXDAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/175] platform/x86: toshiba_haps: Fix memory leaks in add/remove routines
Date: Mon,  9 Feb 2026 15:23:06 +0100
Message-ID: <20260209142324.481243773@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 128497456756e1b952bd5a912cd073836465109d ]

toshiba_haps_add() leaks the haps object allocated by it if it returns
an error after allocating that object successfully.

toshiba_haps_remove() does not free the object pointed to by
toshiba_haps before clearing that pointer, so it becomes unreachable
allocated memory.

Address these memory leaks by using devm_kzalloc() for allocating
the memory in question.

Fixes: 23d0ba0c908a ("platform/x86: Toshiba HDD Active Protection Sensor")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/toshiba_haps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/toshiba_haps.c b/drivers/platform/x86/toshiba_haps.c
index 03dfddeee0c0a..e9324bf16aea4 100644
--- a/drivers/platform/x86/toshiba_haps.c
+++ b/drivers/platform/x86/toshiba_haps.c
@@ -183,7 +183,7 @@ static int toshiba_haps_add(struct acpi_device *acpi_dev)
 
 	pr_info("Toshiba HDD Active Protection Sensor device\n");
 
-	haps = kzalloc(sizeof(struct toshiba_haps_dev), GFP_KERNEL);
+	haps = devm_kzalloc(&acpi_dev->dev, sizeof(*haps), GFP_KERNEL);
 	if (!haps)
 		return -ENOMEM;
 
-- 
2.51.0



