Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A376882C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1119C433D2;
	Fri, 10 Mar 2023 15:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461454;
	bh=qRdkDBJzjniMX4/AR6INQbkg4Pgvj2AG6J3R29bhKbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CFonq/Y9eMoWbJOO/2SlpHIdy+meen5sjQRRJGi/KbKbwgVa3ETNGJGtFuzanyoN
	 sGeRaLRKx+aYubMILj76KO34j2rpSevtSiJzOtgKvyg8kwKvTnbFmlvzdVRJefn82R
	 7GFXN3o+7VIYqASiqcB2ljrR8UcxaUmGm96Jg1Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.15 133/136] scsi: mpt3sas: re-do lost mpt3sas DMA mask fix
Date: Fri, 10 Mar 2023 14:44:15 +0100
Message-Id: <20230310133711.259307848@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

commit 1a2dcbdde82e3a5f1db9b2f4c48aa1aeba534fb2 upstream.

This is a re-do of commit e0e0747de0ea ("scsi: mpt3sas: Fix return value
check of dma_get_required_mask()"), which I ended up undoing in a
mis-merge in commit 62e6e5940c0c ("Merge tag 'scsi-misc' of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi").

The original commit message was

  scsi: mpt3sas: Fix return value check of dma_get_required_mask()

  Fix the incorrect return value check of dma_get_required_mask().  Due to
  this incorrect check, the driver was always setting the DMA mask to 63 bit.

  Link: https://lore.kernel.org/r/20220913120538.18759-2-sreekanth.reddy@broadcom.com
  Fixes: ba27c5cf286d ("scsi: mpt3sas: Don't change the DMA coherent mask after allocations")
  Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
  Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

and this fix was lost when I mis-merged the conflict with commit
9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while reallocating
pools").

Reported-by: Juergen Gross <jgross@suse.com>
Fixes: 62e6e5940c0c ("Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi")
Link: https://lore.kernel.org/all/CAHk-=wjaK-TxrNaGtFDpL9qNHL1MVkWXO1TT6vObD5tXMSC4Zg@mail.gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2993,7 +2993,7 @@ _base_config_dma_addressing(struct MPT3S
 	u64 coherent_dma_mask, dma_mask;
 
 	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4 ||
-	    dma_get_required_mask(&pdev->dev) <= 32) {
+	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32)) {
 		ioc->dma_mask = 32;
 		coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */


