Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5C322D7A6;
	Mon, 10 Mar 2025 17:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628566; cv=none; b=DuXYPS/UR+Xm7IzPP7G5dPJOs99iqtrw3eM8vEkJk1fBx8O2UY9W8uuEMTLMunzWsXCahjvyszB19rFlkGOurPQtYJaMLyM7rfXTQhOMMYijOhqgoNGGRKPNho8YjrwIMtDHH0G+DDI09uGPzTWWhJqAh34JOxwhEVwiBYlrf9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628566; c=relaxed/simple;
	bh=poedcQ9qPCeJCZdbI6VXhU2Eh909UDy0N2HzZwAUeRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lfu+I3FhJlAQiXVggWcMtUIFeeITWfzfBHPVnfe6Vwn7YEVgxvo3kG3GbCNnJyOnOiz6ElJBeiwBehru9JL1vQ5nVGISPacMCuu0URSjvWk/QODygewzO11hlrQxA4YxtjvrD6xL0MJHUuyImcX26B4XnEsHF+d6T0xwHDj5fik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiJ7McKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiJ7McKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD02C4CEE5;
	Mon, 10 Mar 2025 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628566;
	bh=poedcQ9qPCeJCZdbI6VXhU2Eh909UDy0N2HzZwAUeRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiJ7McKNFsaQF+M/0+qNq3NWjEDdDAJIWm39bicML3lOrXFU1cUOhofLzbHUAGcqN
	 uXDz/8yWzENsYaolDQZvxShznps6SCocbZX8Cs+az0OOyaLETS0EM1FlZ4JJUuhkpu
	 s12vakmwQhvin8ddshLS3e72xV9gSkwJoQZaRlsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BassCheck <bass@buaa.edu.cn>,
	Tuo Li <islituo@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 6.1 103/109] scsi: lpfc: Fix a possible data race in lpfc_unregister_fcf_rescan()
Date: Mon, 10 Mar 2025 18:07:27 +0100
Message-ID: <20250310170431.654951558@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tuo Li <islituo@gmail.com>

commit 0e881c0a4b6146b7e856735226208f48251facd8 upstream.

The variable phba->fcf.fcf_flag is often protected by the lock
phba->hbalock() when is accessed. Here is an example in
lpfc_unregister_fcf_rescan():

  spin_lock_irq(&phba->hbalock);
  phba->fcf.fcf_flag |= FCF_INIT_DISC;
  spin_unlock_irq(&phba->hbalock);

However, in the same function, phba->fcf.fcf_flag is assigned with 0
without holding the lock, and thus can cause a data race:

  phba->fcf.fcf_flag = 0;

To fix this possible data race, a lock and unlock pair is added when
accessing the variable phba->fcf.fcf_flag.

Reported-by: BassCheck <bass@buaa.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Link: https://lore.kernel.org/r/20230630024748.1035993-1-islituo@gmail.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -6942,7 +6942,9 @@ lpfc_unregister_fcf_rescan(struct lpfc_h
 	if (rc)
 		return;
 	/* Reset HBA FCF states after successful unregister FCF */
+	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag = 0;
+	spin_unlock_irq(&phba->hbalock);
 	phba->fcf.current_rec.flag = 0;
 
 	/*


