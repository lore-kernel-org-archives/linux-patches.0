Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1FF82495;
	Mon, 15 Apr 2024 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191557; cv=none; b=rCppevdOBVChDeFULJ7l5N15A2Px9H4a1qgaVQz6/SqYHBjUh+wHt2uw47CeH/oVS+5MqQmEc9WyD2dYekXoYYWQm/XcTgxVALXb9xxpy+KyCIhes0z7PXicZIYHaiIr5tH/CemMBAJVUZWZh3zqtR3bdjS2vXC7KcF7FLeY89s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191557; c=relaxed/simple;
	bh=qtlUSvimGm0p8SlJslNcdNKvc4DgWUNEEC+HV7/hDVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPgUcHHapncpfftG7gUlZtI4NG2W9mrvOxxlqrPuF0wfzuz3viY6rghZD0iyQ0BCKQoS8MUI7fshoMaWKcS9yoD4MbbIGKLQl9tDicQNbOdhs5qNNMIQ/lyKDa/JbYoX7UBKu+TDbR3PwVh7F2E3g+/oE7PH7D45aupeOXS/vUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYNPag2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYNPag2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1FEC113CC;
	Mon, 15 Apr 2024 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191557;
	bh=qtlUSvimGm0p8SlJslNcdNKvc4DgWUNEEC+HV7/hDVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYNPag2UP+eRrUM7SlBTnBm3EdnCQ/l9d5iKusA2EhWOKwFtM4+5pM4oF0zhhKQOn
	 xoOVVVykAxhBoXN5x4zah6Qon/iZicEp8uQw+aUb8IgOP0/VnsepYAoKQr3evVMe8D
	 pm/v/hg3Z4Dvr0qKRc4OfUFMPO9b+Qma61i5KhTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.6 002/122] ata: libata-core: Allow command duration limits detection for ACS-4 drives
Date: Mon, 15 Apr 2024 16:19:27 +0200
Message-ID: <20240415141953.442111826@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Igor Pylypiv <ipylypiv@google.com>

commit c0297e7dd50795d559f3534887a6de1756b35d0f upstream.

Even though the command duration limits (CDL) feature was first added
in ACS-5 (major version 12), there are some ACS-4 (major version 11)
drives that implement CDL as well.

IDENTIFY_DEVICE, SUPPORTED_CAPABILITIES, and CURRENT_SETTINGS log pages
are mandatory in the ACS-4 standard so it should be safe to read these
log pages on older drives implementing the ACS-4 standard.

Fixes: 62e4a60e0cdb ("scsi: ata: libata: Detect support for command duration limits")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2493,7 +2493,7 @@ static void ata_dev_config_cdl(struct at
 	bool cdl_enabled;
 	u64 val;
 
-	if (ata_id_major_version(dev->id) < 12)
+	if (ata_id_major_version(dev->id) < 11)
 		goto not_supported;
 
 	if (!ata_log_supported(dev, ATA_LOG_IDENTIFY_DEVICE) ||


