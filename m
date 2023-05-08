Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5698125DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218C0C433D2;
	Mon,  8 May 2023 10:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541941;
	bh=VXG/QJeMmaJ+Bh0OgxUFp0k+9xYxIsCzyPRBCwZ5ewI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCIz8O9gkAa0d0Bkle8kd7xHb+ieNAZmTrah02e2i+1Rei6RohOIz4bddJfLaxBuw
	 aoOR2bIucta1kuZmyzjCdTJz4LgPuz/vs48GYWwz/atmes8e3sybGlsaau/3ORziAI
	 1ZRt//tS9GGAVTC45Jq5a7AVcJvdq7fdvL3+0VWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 275/663] ACPI: bus: Ensure that notify handlers are not running after removal
Date: Mon,  8 May 2023 11:41:41 +0200
Message-Id: <20230508094437.172912232@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit faae443738c6f0dac9b0d3d11d108f6911a989a9 ]

Currently, acpi_device_remove_notify_handler() may return while the
notify handler being removed is still running which may allow the
module holding that handler to be torn down prematurely.

Address this issue by making acpi_device_remove_notify_handler() wait
for the handling of all the ACPI events in progress to complete before
returning.

Fixes: 5894b0c46e49 ("ACPI / scan: Move bus operations and notification routines to bus.c")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 7c16bc15e7a14..837cd86d0316b 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -589,6 +589,7 @@ static void acpi_device_remove_notify_handler(struct acpi_device *device,
 		acpi_remove_notify_handler(device->handle, type,
 					   acpi_notify_device);
 	}
+	acpi_os_wait_events_complete();
 }
 
 /* Handle events targeting \_SB device (at present only graceful shutdown) */
-- 
2.39.2



