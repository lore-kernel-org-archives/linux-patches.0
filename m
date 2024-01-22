Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C7E1292F4;
	Tue, 23 Jan 2024 00:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970989; cv=none; b=mK0BOEXvPMr42oJL2jmfsTzIyzptN64cxuUOxHfImbU5XrUrzBJwPMf74P8gK7vPT56nNimWP0ZOiDN0oS0YT0VNAP9KSH3+Ys6kWdZjO+StYbtOQiqzx5fJZEpEBgIcmhWBJR6oImnlBNrkMhGfwMnLBbAxVi5cPU2BYdi+xmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970989; c=relaxed/simple;
	bh=AHTLAjB39P2cA/Ikqw+TnTcSOW+TKoOgOVIUPKPgEAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NH9QNjIxp9ErHn/KcB1+yBD1jQWneFQeIPF5J3Yq68PtUWkE/ugP+hslIIvyxvrIFW+xoYSci0EbJTP74W8o37ZPLOB4xq0mzvsbK/UAvjz0Ju+u9Fi7PmqExkOBLRQzkq5fq7FwGr2gWI/n99I9r9M4k+65oPsoeBE0SMZvFnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdtbAedm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdtbAedm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CCAC43390;
	Tue, 23 Jan 2024 00:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970989;
	bh=AHTLAjB39P2cA/Ikqw+TnTcSOW+TKoOgOVIUPKPgEAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdtbAedmzqYiqgw9PxjMWe29gqFv8JL5sAp/VsKXV3tIXkq7myuIpsEbhnZwy+Te2
	 qdOycx2S69MKIHHExjoLNh0QHn7Jz30HUzE2twH9tMgEETxe+a4c7vumoNtht31LM0
	 6wdcmwKy/ctOsPPW5tNvJkzUWLp8kUiw6d4qvC/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/286] ACPI: LPIT: Avoid u32 multiplication overflow
Date: Mon, 22 Jan 2024 15:56:10 -0800
Message-ID: <20240122235734.487731038@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 48e5059d67ca..7de59730030c 100644
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



