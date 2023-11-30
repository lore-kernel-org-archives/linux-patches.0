Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B59482CB;
	Thu, 30 Nov 2023 16:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8pX884O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114A7C433C9;
	Thu, 30 Nov 2023 16:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361539;
	bh=i43QYNS5OHqQRJ2JK66P4B/mioa7czyut2Fk5eK2SNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8pX884OLOno6eMh0eVoMWDmDvZG00ZHsnb7BE6WBKuEsZUkL72R2UvfgwWTvTXnj
	 RjC2bxLKhkHQrP6fQmH5uJX0nbxKwh4T/WG6VLDNgxNN3sDtkBakhoaA0hs5x1KxaS
	 h0CR2h/jkKgUAEKGADepixQiVf51N7oTAg3ActPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Owen T. Heisler" <writer@owenh.net>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 063/112] ACPI: video: Use acpi_device_fix_up_power_children()
Date: Thu, 30 Nov 2023 16:21:50 +0000
Message-ID: <20231130162142.320627123@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit c93695494606326d7fd72b46a2a657139ccb0dec upstream.

Commit 89c290ea7589 ("ACPI: video: Put ACPI video and its child devices
into D0 on boot") introduced calling acpi_device_fix_up_power_extended()
on the video card for which the ACPI video bus is the companion device.

This unnecessarily touches the power-state of the GPU itself, while
the issue it tries to address only requires calling _PS0 on the child
devices.

Touching the power-state of the GPU itself is causing suspend / resume
issues on e.g. a Lenovo ThinkPad W530.

Instead use acpi_device_fix_up_power_children(), which only touches
the child devices, to fix this.

Fixes: 89c290ea7589 ("ACPI: video: Put ACPI video and its child devices into D0 on boot")
Reported-by: Owen T. Heisler <writer@owenh.net>
Closes: https://lore.kernel.org/regressions/9f36fb06-64c4-4264-aaeb-4e1289e764c4@owenh.net/
Closes: https://gitlab.freedesktop.org/drm/nouveau/-/issues/273
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218124
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Owen T. Heisler <writer@owenh.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: 6.6+ <stable@vger.kernel.org> # 6.6+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 0b7a01f38b65..d321ca7160d9 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -2031,7 +2031,7 @@ static int acpi_video_bus_add(struct acpi_device *device)
 	 * HP ZBook Fury 16 G10 requires ACPI video's child devices have _PS0
 	 * evaluated to have functional panel brightness control.
 	 */
-	acpi_device_fix_up_power_extended(device);
+	acpi_device_fix_up_power_children(device);
 
 	pr_info("%s [%s] (multi-head: %s  rom: %s  post: %s)\n",
 	       ACPI_VIDEO_DEVICE_NAME, acpi_device_bid(device),
-- 
2.43.0



