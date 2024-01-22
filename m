Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2C7EAE8;
	Tue, 23 Jan 2024 00:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970422; cv=none; b=aU9OTeohsLE+36g4D4DsLkZjychKNok1on9AW1pRG3Hk5MDrXpS4KBFgLwGZ8zxm8h3L1KJFPS+/qtLp4L9BwT+iPWrcIxXc/h0cfpJhovgS0ml4iS+Tc/4UwjP4rw0nfJT/H+alHngtRWv3hhiKLQQs08F0d4+QB3oxMqM3ZYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970422; c=relaxed/simple;
	bh=YIgznOFsPImxZcK4QacEACSw5o01yBUcfUOHOVx5xRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRyv15JsIhQrz0shnilHJ+Z+C/NHKAAkK8/UViT1C0wP3holv7nZKVH26lJwKPtX1IlEqiSfatk5v9DcswwEToqZBlg4AgEAs3AXVz4VVsOKCGIP8myTEY6z3UlyDwFqs2qfeH3kOoUAMW8Xc7wepGs6pW4st2hDcZw/sxWPlys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPT4eRIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPT4eRIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29977C43394;
	Tue, 23 Jan 2024 00:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970421;
	bh=YIgznOFsPImxZcK4QacEACSw5o01yBUcfUOHOVx5xRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPT4eRILCGUR2q0zFljkDLF8576Kcjhi94J5hc/3T1CY9x6hhdhUUfct9S+ura72q
	 oVqHlGKUgdsNIoFlhn4aQ0u1ArG+YeoIIG1siSTPy0IzYDidrrdlPxO6lidMrMLhwx
	 Ln1a4N+rdgFwGW1cC0qy5f0Ck8DjHTm1vO28att8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/417] ACPI: LPIT: Avoid u32 multiplication overflow
Date: Mon, 22 Jan 2024 15:53:04 -0800
Message-ID: <20240122235752.087435482@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Kiryushin <kiryushin@ancud.ru>

[ Upstream commit 56d2eeda87995245300836ee4dbd13b002311782 ]

In lpit_update_residency() there is a possibility of overflow
in multiplication, if tsc_khz is large enough (> UINT_MAX/1000).

Change multiplication to mul_u32_u32().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: eeb2d80d502a ("ACPI / LPIT: Add Low Power Idle Table (LPIT) support")
Signed-off-by: Nikita Kiryushin <kiryushin@ancud.ru>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_lpit.c b/drivers/acpi/acpi_lpit.c
index 50540d4d4948..2c015ecf7185 100644
--- a/drivers/acpi/acpi_lpit.c
+++ b/drivers/acpi/acpi_lpit.c
@@ -98,7 +98,7 @@ static void lpit_update_residency(struct lpit_residency_info *info,
 				 struct acpi_lpit_native *lpit_native)
 {
 	info->frequency = lpit_native->counter_frequency ?
-				lpit_native->counter_frequency : tsc_khz * 1000;
+				lpit_native->counter_frequency : mul_u32_u32(tsc_khz, 1000U);
 	if (!info->frequency)
 		info->frequency = 1;
 
-- 
2.43.0



