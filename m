Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C68E23D288;
	Mon, 23 Mar 2026 14:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277237; cv=none; b=VqkEKLMpwKlyXXYjdjmTbWAMZW/v7vNSEZnMKTpyo5ENDoPsVPSYB0jVN1l8tGorQ6f4GXitr1IwNLvoHFsysu0LVB8TfXdbOWbisOGo69WZsf24kwm+MO+xb1d3hyuiyE546RnCc/CAqXmR/UBD8zjthjtrGrio0hHfY6933iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277237; c=relaxed/simple;
	bh=gOSCU4aHn4gGReZ/AY9u6GnFSbQAagjiJ7hoMxH3sMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnxeqcoDXWtMROGqibKT5PiR1o+N2bmSvGngRJ7Pc4VI1E7c18awAM/r2mGRtWHYXr1mkVxA2DK1+rCDLaDXGaEs7USpnjnZ98qB134vxYb9CSDT7s7SqsOgwv0yjcUqXM+kUroVEZqV9qmhG/8IFnVXklD2zQePsrbi+i2dIUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sa6kgSjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sa6kgSjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297C9C4CEF7;
	Mon, 23 Mar 2026 14:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277237;
	bh=gOSCU4aHn4gGReZ/AY9u6GnFSbQAagjiJ7hoMxH3sMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sa6kgSjgG+8gK7LeO3it/9/f3bt9hlVGrF7AgT+yG+qsndsKM/tIiPvpmdpB/ioKK
	 iiUZhnmC1LCMJxNg8oYJhfAQ4slHgqgZQiPZs9wwxk0D6sgxH4++YZs8VTYBjEgAaW
	 YJWLIu4zZ6nVzMBS+TNxO2hVzyDBukeiGDKZgr18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 365/460] ata: libata-scsi: report correct sense field pointer in ata_scsiop_maint_in()
Date: Mon, 23 Mar 2026 14:46:01 +0100
Message-ID: <20260323134535.534805763@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit e6d7eba23b666d85cacee0643be280d6ce1ebffc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3611,7 +3611,7 @@ static unsigned int ata_scsiop_maint_in(
 
 	if (cdb[2] != 1 && cdb[2] != 3) {
 		ata_dev_warn(dev, "invalid command format %d\n", cdb[2]);
-		ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);
+		ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
 		return 0;
 	}
 


