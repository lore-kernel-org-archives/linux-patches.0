Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1159B131E54;
	Tue, 23 Jan 2024 00:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969108; cv=none; b=ZzbZaIzv+EwTUIYWPyztE5eezX41vl8KNoaA96iazCwAGmxE5KTTZSJi8meU8OAofVXxKi96ZNVFH/hLFriiuMnCoYRuB4syEG/GgunRLr+OQoPYt4J9Z0u/YvZ+Oc2F7j5D/smVV5DbVsdUmQbzO8yMpvcZWFy2jFK5pmN/io0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969108; c=relaxed/simple;
	bh=bQniYTNceiKHXMM+f/qF2mhx77uEt7W+q7hW6+tWg58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDFiHcnV+bq+SP8KSx9LW7yY6i2T4BLeU+GOvR7+aCQuxvQDzCgDQWdMNP6iX7xgTVYXdXh4kUuaMEJ+SwiyOq52LqMM7q5xicjpBUdX1bhoE7Z3Z67nL019G5JoanzHOrCNIgQ0f0gYCh3B58Gn6VPg2BDyEqf7xYvIObw4i8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfgNScbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfgNScbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E8CC433C7;
	Tue, 23 Jan 2024 00:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969107;
	bh=bQniYTNceiKHXMM+f/qF2mhx77uEt7W+q7hW6+tWg58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfgNScbwmGundT2nVq4HBZe/cyLBMy31pkSyAKXtvm9vbxCtQd5kbJwu782nPkqH/
	 rFPSI49nIHeAI0Y4tKjPmsnfesOUahM+teP0v2uuu9jT7IG+jYftp4TwCWFQC4xhvl
	 cgzxiyH7gry9VH71LSwojhZoHv+T80lLTo/KeEgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 025/641] ACPI: LPIT: Avoid u32 multiplication overflow
Date: Mon, 22 Jan 2024 15:48:49 -0800
Message-ID: <20240122235818.885852475@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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
index c5598b6d5db8..794962c5c88e 100644
--- a/drivers/acpi/acpi_lpit.c
+++ b/drivers/acpi/acpi_lpit.c
@@ -105,7 +105,7 @@ static void lpit_update_residency(struct lpit_residency_info *info,
 		return;
 
 	info->frequency = lpit_native->counter_frequency ?
-				lpit_native->counter_frequency : tsc_khz * 1000;
+				lpit_native->counter_frequency : mul_u32_u32(tsc_khz, 1000U);
 	if (!info->frequency)
 		info->frequency = 1;
 
-- 
2.43.0



