Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53DE757EF;
	Mon, 15 Apr 2024 14:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191031; cv=none; b=GHzWZ2wEEnwFfSVEOB8cjQsE8hDhwHU9fw8xdXVViTliggrKC/Tcn68+NPIbLVW+cjBJpbH7CSNeDejyLW8vHouUsOQmFnErDkHVVVwpc2nBlY55zGBPfJqd7ofbxp2ulYizXVjMhCGIhCC7ajOYJcFBFuB+0IZWWC+slzO2mXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191031; c=relaxed/simple;
	bh=S9lJRs6VhYci0V7VPNzR9RDFJt+QY98j78j78bmNXTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtP00Y7Lr/oWpC381MdNkmDKWHFa2ycqU+JGFYWBxbRKMTbNH3c3coImgZl17Lo6QfLaaqfshvZ7g5wD0z5aVooO9wB6p5Dvaz4PgbVuo4L/rbiHyrsn3iTcR+e5QEgP6gaip0FH9bDajivwmB2J83KoP7UNGuY764BTkjXvtqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVauiMIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVauiMIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08117C113CC;
	Mon, 15 Apr 2024 14:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191030;
	bh=S9lJRs6VhYci0V7VPNzR9RDFJt+QY98j78j78bmNXTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVauiMIlqrlTR1VlLQ/TpzfJzL0ZuHmBQDB3AM8h+BkPKj1+19wJ0rxmtTGkrF5Vb
	 VKH+5zgpYbDOZSmb+ONNVDOJ9fstdgXN/3z/+T6Cx2JgwJo2t3qjFPPqSNH6fNmrOA
	 flk1x1IAHpAZAEtPaEl1BBVPlevLP+WmP8R1WwTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.8 002/172] ata: libata-core: Allow command duration limits detection for ACS-4 drives
Date: Mon, 15 Apr 2024 16:18:21 +0200
Message-ID: <20240415142000.050775740@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2539,7 +2539,7 @@ static void ata_dev_config_cdl(struct at
 	bool cdl_enabled;
 	u64 val;
 
-	if (ata_id_major_version(dev->id) < 12)
+	if (ata_id_major_version(dev->id) < 11)
 		goto not_supported;
 
 	if (!ata_log_supported(dev, ATA_LOG_IDENTIFY_DEVICE) ||


