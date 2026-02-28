Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6665336C9EB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302305; cv=none; b=W7ICr9+UNHjOS92/ziPpn1ONfr6zgiGQNfGcjczCWXCaGXdJpguwXavDJPVGFWXKSH5kq6RecFM/lXQStSnbMBPEbCTHDybww1+1OvXPR+oGNNhlr3kH0gNQtfgLUL5bl6eUn8S2JWQ27zJMuRC++T9HXDmlNbdbLizw7Ofe5io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302305; c=relaxed/simple;
	bh=gR6V1VEU0pXrNFO3CvO48kMIGTsFcx3wJHS2fA5+J5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6dyu2JGtQQyPPzVnNJYwICuPonL4GFpY5ndR4I1cxCAp8AvcSSiIr2lCeZpRNVHrMbv/OYmx7sift9ey3VgolUIclwv1ksJCUF0WvcK4sGCFyq8D3B9hU7lfEm6VxUIuXAdMp6aT+iqd2E5mwYy7vLffgej4W9ZzeuxLSoA4g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7GhN822; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7GhN822"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AC7C19423;
	Sat, 28 Feb 2026 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302305;
	bh=gR6V1VEU0pXrNFO3CvO48kMIGTsFcx3wJHS2fA5+J5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7GhN822GdQraMt+BV2uqPRna45FxRrEuMqj+t0gwFmHMWUe2r4c4rr9PD9aTht0q
	 r5Z4gWT2TSxFJaoNTJD/NVp2wHuykg+bfUA8BBsFLGUcON2+5m1w54YkNyvzWuSsPK
	 31Qv+9MdqCVNEiY8US3EDLBqr3of9c2HlVkfFdtTorPsvEISKLQmoavUYL1uUk7uoZ
	 dvemSzvVOS+0V/YQW1Cl5iPkwmK0RFTuC9Qv055SjMM2BiUyWrBTp/tv+z9J+/86yp
	 mAfIO8OV/JI2UhqnxoSmw1JfASyBUxgTO5gZX9rEqDxScVWhZKh1Rg7e3WxPg5184q
	 tEOiABQGFQxzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexey Simakov <bigalex934@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/232] ACPICA: Fix NULL pointer dereference in acpi_ev_address_space_dispatch()
Date: Sat, 28 Feb 2026 13:07:53 -0500
Message-ID: <20260228181127.1592657-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index b96b3a7e78e50..fd6471e764f1a 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -162,7 +162,9 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
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

