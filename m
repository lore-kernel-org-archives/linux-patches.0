Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C941A76AC;
	Mon, 14 Oct 2024 14:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916442; cv=none; b=CFmT3Oyi0Jza173pm8vGFsKpS1/RsxNMXsggSmdedfKh9O0QsiS2S6C5/vCRiFrbiWOfMH56uo6B2cdyt+URX11D9RAuZtvH/6U8GExnCQ9AXnRUGMCLV79mpp5l2ElDOzyz25y04ZNQNnREl7GBYKJN3L8fhx6WyqDENe0xOJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916442; c=relaxed/simple;
	bh=V2Lw0eKe4pSx9y/9ijMiKEzJir7uoNVg/o2UrYvfPGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeGnGbVVn0BsLildQQOCCfhFoWzZH1SwClRGUmSyErvU9o5KxdF+ZPHRJiqasumLiLtcYJqRFDMbs91Dj6OMlfwYXtk9ZDDNox291Dp8EeT1/aERiJ+KwGnwUzZZ7bo+spBYeKmt8X0lb2PuKJTbWtcM9t1yH/dcE/D55Hx++6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuvjaMmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuvjaMmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765AFC4CEC3;
	Mon, 14 Oct 2024 14:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916441;
	bh=V2Lw0eKe4pSx9y/9ijMiKEzJir7uoNVg/o2UrYvfPGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuvjaMmANaQ9eBRM9ZbEApMb0ytMWsKmr6rL9D9SqHHQU5tfh1TDVi9S4g0Sm45sF
	 s6mOcaDmsGZfEAnTkioO5mcTy+aUuDXo1ESnGIWlEUjzij7Prl6G8cMf7iBe/pqnRL
	 VZDs2+yUWXsGsdp0tf4uhQk/cGkUOd8od6I/BcOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Michael Schmitz <schmitzmic@gmail.com>,
	stable@kernel.org,
	Finn Thain <fthain@linux-m68k.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.11 184/214] scsi: wd33c93: Dont use stale scsi_pointer value
Date: Mon, 14 Oct 2024 16:20:47 +0200
Message-ID: <20241014141052.163049622@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Palmer <daniel@0x0f.com>

commit 9023ed8d91eb1fcc93e64dc4962f7412b1c4cbec upstream.

A regression was introduced with commit dbb2da557a6a ("scsi: wd33c93:
Move the SCSI pointer to private command data") which results in an oops
in wd33c93_intr(). That commit added the scsi_pointer variable and
initialized it from hostdata->connected. However, during selection,
hostdata->connected is not yet valid. Fix this by getting the current
scsi_pointer from hostdata->selecting.

Cc: Daniel Palmer <daniel@0x0f.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: stable@kernel.org
Fixes: dbb2da557a6a ("scsi: wd33c93: Move the SCSI pointer to private command data")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Co-developed-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/09e11a0a54e6aa2a88bd214526d305aaf018f523.1727926187.git.fthain@linux-m68k.org
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/wd33c93.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -831,7 +831,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 		/* construct an IDENTIFY message with correct disconnect bit */
 
 		hostdata->outgoing_msg[0] = IDENTIFY(0, cmd->device->lun);
-		if (scsi_pointer->phase)
+		if (WD33C93_scsi_pointer(cmd)->phase)
 			hostdata->outgoing_msg[0] |= 0x40;
 
 		if (hostdata->sync_stat[cmd->device->id] == SS_FIRST) {


