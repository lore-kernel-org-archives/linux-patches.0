Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D46296BA9;
	Sun,  7 Jun 2026 10:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826632; cv=none; b=auz+NduXFiP8EysAMln5LhFxVXO37qixiko52DVPH8lmB0G0XX54SDtIXh1Wici81fyFQYhDJ10l3pf2UbmYeqLrBecgPKEUxylzgDw8AA11H3d907HO9PB54/BTIsU2xzXI7VdbeyuEi1wTvS+bXCR7Nu1mizLekDf2evH2viM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826632; c=relaxed/simple;
	bh=Olen5gYC+EqVr1KblwOGAj5INNmrnentHBP9NFSsT5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJ7bdPtJ5vZ3MFcarvuw8KXD7kuAhjEy6u96dPDRdDUdRY8aR8M59C98OwS2gHNZ8+B2QHWtcHJpy5CG2Gx8QDYmu5JlY8ULCIrpF/z1IcByCpK5Z2CGPAA6FCeLy2kLcfdbvILz7infRCKKK/N/HSMFXUVAj/ZyPdFQ1qTESnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei1+UNeG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei1+UNeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD511F00893;
	Sun,  7 Jun 2026 10:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826630;
	bh=tgrNDxuT8hoKzbaGJ/nLxGPeaw+Y4+oUVYt///eYau0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ei1+UNeGGmnOpDEFo7gnS7iCqGpB8h7oK3CDpeKzmK27tdowMKEN6/R8+PB7MbnkU
	 lEylhyFS4sjnSTLHuxvHF5MQYMuVtIAwO0Yhyo5p0BnSdXoCCCxrTMni+rnz6I9/Rz
	 9mL1jDRyIPqQXUdXOTS1mTFzaFTHHKE1KATK0CM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 002/332] ACPI: button: Fix ACPI GPE handler leak during removal
Date: Sun,  7 Jun 2026 11:56:11 +0200
Message-ID: <20260607095728.120450683@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit fe80251152fed5b185f795ef2cd9f7fe9c3162e0 ]

Commit a7e23ec17fee ("ACPI: button: Install notifier for system events
as well") changed the ACPI notify handler type for ACPI buttons to
ACPI_ALL_NOTIFY, but it forgot to update acpi_button_remove() to reflect
that change.  This leads to leaking the notify handler past driver
removal, which may cause a kernel crash to occur if ACPI notify on
the given device is triggered after removing the driver, and causes a
subsequent probe of the given device with the same driver to fail.

Address this by updating the acpi_remove_notify_handler() call in
acpi_button_remove() as appropriate.

Fixes: a7e23ec17fee ("ACPI: button: Install notifier for system events as well")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Cc: 6.15+ <stable@vger.kernel.org> # 6.15+
Link: https://patch.msgid.link/7954431.EvYhyI6sBW@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index ff30f993b15062..22f26d8fdb1f6e 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -690,7 +690,7 @@ static void acpi_button_remove(struct platform_device *pdev)
 						acpi_button_event);
 		break;
 	default:
-		acpi_remove_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
+		acpi_remove_notify_handler(adev->handle, ACPI_ALL_NOTIFY,
 					   button->type == ACPI_BUTTON_TYPE_LID ?
 						acpi_lid_notify :
 						acpi_button_notify);
-- 
2.53.0



