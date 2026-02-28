Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968C4377034
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301636; cv=none; b=BPlp2F9NQtzO7EVPzpBNQSCxufuooZ8iDsPSNeUAuHp1YoumU8ZXdy9Mgu1wwWNaQJTNNoat+bDz9ho+fTd5vWbSXf7LzDCZbAKsGWtg+p9+rwlqUcaM2bx261hTHjkXXdy+Jng84GMr9tV6grtOwiZ9e3zOMNlOpdUT8lVJbRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301636; c=relaxed/simple;
	bh=RvhD8zbGihcWsqvIXbzWA1Ifvnrg/yMHIYBvGwHru/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/8ETwIIWrfwAWJBV2McYQr4JAfUc+rNDIcnmh8r2zE0hv4tbSNNrdEUFR5KvTeiByrrSrvtyYKJ+y+RmRXw4kKZkS/sE5DE+qd5Sj41JlFbbjKANRgB3y/qZEIq2w6/IHCB+M4h0ZsnMMcaq9zhTQi3YYV+zKZbiJ/wF1dyljg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NSdfjDcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NSdfjDcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083B6C2BC87;
	Sat, 28 Feb 2026 18:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301636;
	bh=RvhD8zbGihcWsqvIXbzWA1Ifvnrg/yMHIYBvGwHru/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSdfjDcvLPfl2zzkEODixVBw6kNJi/34ll5CPxZxNcMWXM1kZ/O0MDrxlXc+iMqxK
	 gKoFXnp9GP2Ik6OFkgCm77s2od3Tks4QaaPUttOpnU1DpHfI88gTTCRdRsAuFDJyK8
	 A8I49TzaS4fOnj+BIh9JqaPEzarZUu9i4+zWihC5ZYeF3JzwR8OOP8ApadxFxaeJRa
	 SLLOifwF0I/WidUZygtqwEKhj8IO/sqlwGwTCDeDVezgtyLN/3HPVZzrLrLTsjb7nu
	 lFvyXQ8A/D7P+RX9zJC/Dmw12vJw5D5pL3bg443ODG8H3YK8BoxkrhU3e8wm9HqG6X
	 VGoKOKgnvw13Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexey Simakov <bigalex934@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/385] ACPICA: Fix NULL pointer dereference in acpi_ev_address_space_dispatch()
Date: Sat, 28 Feb 2026 12:54:11 -0500
Message-ID: <20260228180011.1568201-29-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit f851e03bce968ff9b3faad1b616062e1244fd38d ]

Cover a missed execution path with a new check.

Fixes: 0acf24ad7e10 ("ACPICA: Add support for PCC Opregion special context data")
Link: https://github.com/acpica/acpica/commit/f421dd9dd897
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3030574.e9J7NaK4W3@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/evregion.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index cf53b9535f18e..7788c27ccf461 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -163,7 +163,9 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 			return_ACPI_STATUS(AE_NOT_EXIST);
 		}
 
-		if (region_obj->region.space_id == ACPI_ADR_SPACE_PLATFORM_COMM) {
+		if (field_obj
+		    && region_obj->region.space_id ==
+		    ACPI_ADR_SPACE_PLATFORM_COMM) {
 			struct acpi_pcc_info *ctx =
 			    handler_desc->address_space.context;
 
-- 
2.51.0

