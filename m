Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE72E381AEB;
	Mon, 23 Mar 2026 14:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274611; cv=none; b=Bg1ZmK0TyrCMYEQCJt2wjNKZnZbF6QnbvpzE30iuvEsiLkiWMNd5VM24cauADnPw9Ui4Amwydf/p/90wkO/3PPkoEbpdmf8XM65OpdIGAPAIgJ/owNMtEiu4DhXluoeWlvEZ+z6ml5auGJQw0Y6JMB6SAjTN+J2hK3Zx/BcNt1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274611; c=relaxed/simple;
	bh=om0WnHu5ylxOvEfx9WSPsajyhAnyEw8o8sPuFcuXt7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+eY7GGJMiJO+wwMernSaf1TKQ/0NPu76vb+kjnRrErKpKoN7B/ORH1ITIMFMTT4fPsEKwUOuU59wYfJkfb7JJ0NSBN0bMfEs1bKR0rU1dHmP3pf9tHX9bhHseJi2Sv+V9Jix4//OPsymY/E9HD6CjQRqyKJ3oYNsOiUO++KBoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERghv9D7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERghv9D7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51872C2BCB3;
	Mon, 23 Mar 2026 14:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274611;
	bh=om0WnHu5ylxOvEfx9WSPsajyhAnyEw8o8sPuFcuXt7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERghv9D78Z4OtqnfPT7lmQ5Vg7cSIWuasR+Kh5SPyvIPn1vifHHO/6H0XRS6PoLb1
	 Kk3uIGVOOiClDZ35dQjEXRyts3s7SaiTNQczdPzRtWRs0UlVWCrWSieduX6IIFA8sk
	 wOR4rgoz7w18MdALz1fxih38Ia4hEiNwhlYeAF7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.18 052/212] ata: libata-scsi: report correct sense field pointer in ata_scsiop_maint_in()
Date: Mon, 23 Mar 2026 14:44:33 +0100
Message-ID: <20260323134505.414694682@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3599,7 +3599,7 @@ static unsigned int ata_scsiop_maint_in(
 
 	if (cdb[2] != 1 && cdb[2] != 3) {
 		ata_dev_warn(dev, "invalid command format %d\n", cdb[2]);
-		ata_scsi_set_invalid_field(dev, cmd, 1, 0xff);
+		ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
 		return 0;
 	}
 


