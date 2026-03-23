Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA9C3ACA5C;
	Mon, 23 Mar 2026 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273890; cv=none; b=o3t55pTwYic/n1RKE3nA+GfvZY5PPtj7nQjmicwUGZMBKLLAtR0Qvuk+7jTuf1AFUX/IrxJJ62ZdNS26DQzS++FzWXjLcfOsZrb7IMNhByjIgk/2fb8wnaUUDb6x42hCK5MkuBX4Fhk5Qj2XOvOB9/dDGMtFkyEiuXtmsKyEjFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273890; c=relaxed/simple;
	bh=TvZnT2agLjimtQPk70caj+hHjwAukyQ6u0dVqrS0X7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Otiqzar2oAbnQs22+Dqlur9SUwyCtEXf+gl6qHoDUK+h89gEKjL8rdByYLPB2dISbhafCBLARzx4TNioZrYD9w2u8ZsWQXkygz+gVcwduGgkVZJzYobJ3XsCJiexUX+jxiYzQB8lk907NSDgIaDnqJKOHoKdMtBeZBtpINUAkOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzzTLtov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzzTLtov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42474C2BCB1;
	Mon, 23 Mar 2026 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273889;
	bh=TvZnT2agLjimtQPk70caj+hHjwAukyQ6u0dVqrS0X7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dzzTLtov9Yh8CYeOIvpdA0a3rtpvKrWn3e/tjp7P5QYykKVkJbXOL5XN8FYx603sR
	 bFIbaEqdPw2j2nnr4WWB9op4vpjloFXezXCbQs3WTL4KS3x8bGWp/4HMrHLbAAAxHZ
	 UWwJLcuP4LKrNjkIC/r9g+bqTYWK8oJVn3nHiufE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.19 042/220] ata: libata-scsi: report correct sense field pointer in ata_scsiop_maint_in()
Date: Mon, 23 Mar 2026 14:43:39 +0100
Message-ID: <20260323134505.919876187@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit e6d7eba23b666d85cacee0643be280d6ce1ebffc upstream.

Commit 4ab7bb976343 ("ata: libata-scsi: Refactor ata_scsiop_maint_in()")
modified ata_scsiop_maint_in() to directly call
ata_scsi_set_invalid_field() to set the field pointer of the sense data
of a failed MAINTENANCE IN command. However, in the case of an invalid
command format, the sense data field incorrectly indicates byte 1 of
the CDB. Fix this to indicate byte 2 of the command.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: 4ab7bb976343 ("ata: libata-scsi: Refactor ata_scsiop_maint_in()")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3600,7 +3600,7 @@ static unsigned int ata_scsiop_maint_in(
 
 	if (cdb[2] != 1 && cdb[2] != 3) {
 		ata_dev_warn(dev, "invalid command format %d\n", cdb[2]);
-		ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);
+		ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
 		return 0;
 	}
 


