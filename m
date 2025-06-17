Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A752ED85E;
	Tue, 17 Jun 2025 15:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175374; cv=none; b=KdMFdY25KruCH5FLwvLxz0Hip/+UcPes1ChtcAVK2luxT8h+azUMW7P6U2CqxoIeWOI6jxo63LZuZ+lryUqbLNzj6jdRVOqmXpt53hMgre0GD1WMncJbUoGLDke2xFaWVZStOgy5WtyePqf2sw2cyjaVXOpkqOaFl5biHkCPaMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175374; c=relaxed/simple;
	bh=TcKK1Bo4NsEzzy7MP+tdN8eVUxea+HMb6+xlPQVMiy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA2p+JWa4EyM5RpxCmd4W2H6AuRJ6NN9zgOlR/kJn2TGfpMODTgnpg43OiGM3UzrPkecQVJHbnM/xcXH1LV+pFvq5s4aYzITr/ZaLYm4Ly1nryP2XNJxNyWhmfguzKLAR0ETmclPZHYW79+4ViO5vnWrYHMUXgUWx46r96+T2H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCM4xCwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCM4xCwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88578C4CEE3;
	Tue, 17 Jun 2025 15:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175374;
	bh=TcKK1Bo4NsEzzy7MP+tdN8eVUxea+HMb6+xlPQVMiy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCM4xCwTFf0dnPdngSJc0TWq+qXaial+3DfNcLllicxVy6F/Qsw9oDvvCBQ2lvpug
	 iJUsBClocRTc6o/f8JVNN5RfLZWraescN4Fv/zkvOjBeOpzQrAg/cRg5n9TFsNlsbS
	 iuQuxwYwReTU+2l0mEJjLpdaMyOj6IyX3dT2Q7x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 082/780] ACPI: thermal: Execute _SCP before reading trip points
Date: Tue, 17 Jun 2025 17:16:30 +0200
Message-ID: <20250617152454.853037920@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 3f7cd28ae3d1a1d6f151178469cfaef1b07fdbcc ]

As specified in section 11.4.13 of the ACPI specification the
operating system is required to evaluate the _ACx and _PSV objects
after executing the _SCP control method.

Move the execution of the _SCP control method before the invocation
of acpi_thermal_get_trip_points() to avoid missing updates to the
_ACx and _PSV objects.

Fixes: b09872a652d3 ("ACPI: thermal: Fold acpi_thermal_get_info() into its caller")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20250410165456.4173-3-W_Armin@gmx.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/thermal.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 0c874186f8aed..5c2defe55898f 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -803,6 +803,12 @@ static int acpi_thermal_add(struct acpi_device *device)
 
 	acpi_thermal_aml_dependency_fix(tz);
 
+	/*
+	 * Set the cooling mode [_SCP] to active cooling. This needs to happen before
+	 * we retrieve the trip point values.
+	 */
+	acpi_execute_simple_method(tz->device->handle, "_SCP", ACPI_THERMAL_MODE_ACTIVE);
+
 	/* Get trip points [_ACi, _PSV, etc.] (required). */
 	acpi_thermal_get_trip_points(tz);
 
@@ -814,10 +820,6 @@ static int acpi_thermal_add(struct acpi_device *device)
 	if (result)
 		goto free_memory;
 
-	/* Set the cooling mode [_SCP] to active cooling. */
-	acpi_execute_simple_method(tz->device->handle, "_SCP",
-				   ACPI_THERMAL_MODE_ACTIVE);
-
 	/* Determine the default polling frequency [_TZP]. */
 	if (tzp)
 		tz->polling_frequency = tzp;
-- 
2.39.5



