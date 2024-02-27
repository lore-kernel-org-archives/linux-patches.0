Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADDD140391;
	Tue, 27 Feb 2024 13:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042006; cv=none; b=CkOGWL7tvDb169awlQqG7/++hQfB1a+3L7uOZf0I25sS2c8AH33vIaxB+cjrQbvOS9ZMmvI8b7w5X+JxspMQTJXnbiQYQYKs13LWb+fYFSyjT530z1jtkN/6nadX8XrQqjoGL0CmKoGRyxDpzkKRuphLbU9YBVq9A2n2sOYUsIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042006; c=relaxed/simple;
	bh=fnj1nQDTDSUdHp+AfFW7jhtjYgGzqR5YN/8dViKkEbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hubivjDb/HTR5UgrJdm70XRsnh/9Cc9HguE1wJatM3j1jsAIh/9W2DLlb/INgGGn8J8IylWDTQyHOcmIzYFFb0TKOwOBZFcxM340x2xNqnf+q4Q77FN/vUlFzY02S/dlMTNegKPw33JUt4EIPzL4C6Uxmy6d4KBbJ1WzGaoz0Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b17nD9Cu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b17nD9Cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1600C43390;
	Tue, 27 Feb 2024 13:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042005;
	bh=fnj1nQDTDSUdHp+AfFW7jhtjYgGzqR5YN/8dViKkEbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b17nD9CuAgBdWjbdDscUxMmGBlmr9B/KSIz7pBI+H5eTnyVjxdB66PwLNm1AXDOfB
	 3RJ3CUjCiskgBTwNuNv+cLyVIzCVtGKg/KwDEkoVBihJ9mp/MOaDbAlx884qK8au4y
	 YG3ySwRAzKePtDTOf7uOdaXFwW0lvlBg5bh9sRQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.6 144/299] ata: libata-core: Do not try to set sleeping devices to standby
Date: Tue, 27 Feb 2024 14:24:15 +0100
Message-ID: <20240227131630.504839931@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 4b085736e44dbbe69b5eea1a8a294f404678a1f4 upstream.

In ata ata_dev_power_set_standby(), check that the target device is not
sleeping. If it is, there is no need to do anything.

Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2034,6 +2034,10 @@ void ata_dev_power_set_active(struct ata
 	struct ata_taskfile tf;
 	unsigned int err_mask;
 
+	/* If the device is already sleeping, do nothing. */
+	if (dev->flags & ATA_DFLAG_SLEEPING)
+		return;
+
 	/*
 	 * Issue READ VERIFY SECTORS command for 1 sector at lba=0 only
 	 * if supported by the device.


