Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F51879CE
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92A5C433F0;
	Thu, 12 Jan 2023 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533115;
	bh=tleNgnILAPUNwkcEzLlyro8UmvnvcSiE9oZBMaw01Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=062qrMTmOy6kZ+nxUdeXptzHLGb28AL69RlnHBS7jsczdeTD/yoKg1btEY9esFnqn
	 4gAZ8jtkRuw6vA8iU9j+mC6IAobIeY84RBRpjRKryW/0XENfPnc+v2JskSaLHU8l1P
	 XDxgy86U3tAYc8zz3G4f48APqmt7Sj43XBqGldoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Mendonca <rafaelmendsr@gmail.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 344/783] vfio: platform: Do not pass return buffer to ACPI _RST method
Date: Thu, 12 Jan 2023 14:51:00 +0100
Message-Id: <20230112135540.260647440@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit e67e070632a665c932d534b8b800477bb3111449 ]

The ACPI _RST method has no return value, there's no need to pass a return
buffer to acpi_evaluate_object().

Fixes: d30daa33ec1d ("vfio: platform: call _RST method when using ACPI")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20221018152825.891032-1-rafaelmendsr@gmail.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/platform/vfio_platform_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index e83a7cd15c95..e15ef1a949e0 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -72,12 +72,11 @@ static int vfio_platform_acpi_call_reset(struct vfio_platform_device *vdev,
 				  const char **extra_dbg)
 {
 #ifdef CONFIG_ACPI
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	struct device *dev = vdev->device;
 	acpi_handle handle = ACPI_HANDLE(dev);
 	acpi_status acpi_ret;
 
-	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, &buffer);
+	acpi_ret = acpi_evaluate_object(handle, "_RST", NULL, NULL);
 	if (ACPI_FAILURE(acpi_ret)) {
 		if (extra_dbg)
 			*extra_dbg = acpi_format_exception(acpi_ret);
-- 
2.35.1



