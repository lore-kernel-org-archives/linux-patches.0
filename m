Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D4537AA87;
	Mon,  9 Feb 2026 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647937; cv=none; b=Tsecx30qD7auDV9PBgH+OPdSA2PPeOXkB5ZPyNPQWEYqUzzwuT31Qn7HTyCoshjmxVKWYhINmO5GjrlPQvBrhOgY0Z90MpdGnR5QMT+4HW4AVZrkeZEp7fo68Ccpboc2Amlp+xKkHCh1PiG1QD0CPyDsSgOB70EB/KZ9YIRxkRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647937; c=relaxed/simple;
	bh=UOQnwwOdVvReLMPznh+RFPHfZxHHku9/Cm5JxYm+i1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFYIxaU0+ECsgAQcVfK2veHmic/sNuC1Jnv0vyLBWWdbnW9jesbK8OTz/s+oP1xF5vo5xDY86ViyuCen0gsb7xOgV0uGi4MMUV5wuRUu/Lhr84KFeyQ5VqmZnaYL5ZGolRQn+TqLzhdKnyw5dNuodyOm0KLpU5e72/R7qSYde64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThfSJlfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThfSJlfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69247C116C6;
	Mon,  9 Feb 2026 14:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647936;
	bh=UOQnwwOdVvReLMPznh+RFPHfZxHHku9/Cm5JxYm+i1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThfSJlfALADlwFiyoia6laJ52vC5kOypjdOjWVj6UzfF0CYVFFraTFZpi9pxHGnnB
	 WQTBf9fVc6et0sVyNub3tMe1CGjQV8wkHTJ9/NWFQWx3+Mdhp5Cz46BNa6x0/o3fIx
	 JYk77fCrxhOh0gx59NAD5ec9HTZEQ2WE7CztBA2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/113] platform/x86: toshiba_haps: Fix memory leaks in add/remove routines
Date: Mon,  9 Feb 2026 15:23:42 +0100
Message-ID: <20260209142312.810924537@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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



