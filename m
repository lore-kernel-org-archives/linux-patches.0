Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4AC34DCCB;
	Tue, 26 Aug 2025 14:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218946; cv=none; b=dgw9Jk+FXIxiI+ET0uDNZOjvMMhQKwALypTB08D7CpO/C/ifqfWoGwTlhKgkhNmYljKvVaA4RkKfEnXbq2AFy9J4XcsH6gAba4CA8l7RQpHVNAeLpqaNCiH5U/Zd+iN59q/zPBuOzkoDNGoPDm/SYAM8swRVBVY5PZKf2cPLBq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218946; c=relaxed/simple;
	bh=zyJUoGb84GuPRm9w6GKNQ3jJtFxW00DAzs4Pl5DFR7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/bjrpQt25xDqnfd5PzoxTXlU91k7HTL7QgN/vhWAVih6UR5TQ++TE1YiRLVLUpeRP6U3Pm/1WgSyVixoiyMkda7fVtDqXA+fI9V3cZy/MAsaRcmFgU9z2TLAMaveexcIzxRGHu5Ydo6lz6XVq39Va7Qf7fFC8e6yRFituAL/WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlTPDxNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlTPDxNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C96C113CF;
	Tue, 26 Aug 2025 14:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218946;
	bh=zyJUoGb84GuPRm9w6GKNQ3jJtFxW00DAzs4Pl5DFR7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlTPDxNzIkPUgNt/QsEXWDrXaARXTcQUc2hab45rP9tbVOYfF77RNHDQMoSzUWpQp
	 gq311EFVMXrS0ZoRz97H6tBLCcbg36wdiAUVJ9AQIzOl78V9yhZAr5sVfij7j+5Z9r
	 QkO0cwx1hIeEGO9qEoM1WS3h7YNomuG0DlJL7Gqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/403] ACPI: processor: fix acpi_object initialization
Date: Tue, 26 Aug 2025 13:08:41 +0200
Message-ID: <20250826110912.257478643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ott <sebott@redhat.com>

[ Upstream commit 13edf7539211d8f7d0068ce3ed143005f1da3547 ]

Initialization of the local acpi_object in acpi_processor_get_info()
only sets the first 4 bytes to zero and is thus incomplete. This is
indicated by messages like:
	acpi ACPI0007:be: Invalid PBLK length [166288104]

Fix this by initializing all 16 bytes of the processor member of that
union.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Link: https://patch.msgid.link/20250703124215.12522-1-sebott@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index c8338d627857..9cbf0593da05 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -228,7 +228,7 @@ static inline int acpi_processor_hotadd_init(struct acpi_processor *pr)
 
 static int acpi_processor_get_info(struct acpi_device *device)
 {
-	union acpi_object object = { 0 };
+	union acpi_object object = { .processor = { 0 } };
 	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
 	struct acpi_processor *pr = acpi_driver_data(device);
 	int device_declaration = 0;
-- 
2.39.5



