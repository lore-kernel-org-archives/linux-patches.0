Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A6822AE68;
	Tue, 29 Apr 2025 17:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949186; cv=none; b=X1DiYWi6AhZHDf0X3kqc2ggjpw07Qc1sCPP5h3UqrfGggK2sBnnhIiQl8isAchJ+V7UjuWwF+D7UTsfggvpf5Q/PCv/EXaNzmWjouXZ2oTZ9XoMfiNBxb0cyzFPzOKPR0PGj3nVBCrOTJUFtkaaN6/C0Q+mDbrzpnq1rTa93ZBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949186; c=relaxed/simple;
	bh=TPCCBjMHWZ8hQqKjbfQha56x60di6MR2XrK//Jwu9ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnhlvjB7Z3NJ/a7zxKnDjw8XBeIY5pt1rxZEXKMNAtCfzwQ/gO/VhvwLkYvquVJ6XVGPJP5utnzAjn02cycFgha7y0IaOpuoXmp9alJdBqqT/jy3v6YBzYoFnASk3Ah6dX8Uk2mPcDHAIGwEaiGTEOIYy8Tx8C4i4WdMM3SeVqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LME0CTA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LME0CTA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72306C4CEE3;
	Tue, 29 Apr 2025 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949185;
	bh=TPCCBjMHWZ8hQqKjbfQha56x60di6MR2XrK//Jwu9ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LME0CTA9294tNmyvEjLPVXw/znhProJk4VpFWeUYwIqmSLznnj6brjETNZTMv63tl
	 mVG468eDyHZuqRl1GKGikJd/6v239rvcBuSU+2uFdqYhUxDS0pojtubtkVRbKSVI2e
	 EcgIqr90S8SGrchamsLLcSdKJj3NQIF7AkM8aXDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BassCheck <bass@buaa.edu.cn>,
	Tuo Li <islituo@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 238/373] scsi: lpfc: Fix a possible data race in lpfc_unregister_fcf_rescan()
Date: Tue, 29 Apr 2025 18:41:55 +0200
Message-ID: <20250429161132.925764835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -6954,7 +6954,9 @@ lpfc_unregister_fcf_rescan(struct lpfc_h
 	if (rc)
 		return;
 	/* Reset HBA FCF states after successful unregister FCF */
+	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag = 0;
+	spin_unlock_irq(&phba->hbalock);
 	phba->fcf.current_rec.flag = 0;
 
 	/*


