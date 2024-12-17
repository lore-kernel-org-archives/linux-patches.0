Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490DF1F75A6;
	Tue, 17 Dec 2024 17:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455964; cv=none; b=Sc+aJkcR49ZqofYQEC/eaVUyyMZDpYENV91jmo4cdUnTGoiR0Vts1A81piuXGBHZ9X/RgEaLvlixo4LvqzUfxDv8jTd4J8YELjqRz0yF3iP2HqcawLAIPHzO3K5AKv9qFOgrG4LqrbqV1gjrr5EtWIionMHYIW+KC2IBWkTpnQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455964; c=relaxed/simple;
	bh=xUjXYTbM/QJvZCKBh/nnWRWudFsyLrL1fVDQPNwzIiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9iKxveK7X0NBC1/h3Fn77k/rWMFudXdi8YiyoUnHsvbmFTu5EcxhFm47xGQqtBpkKpt3j9HuGNVXQqnICRrcrmdfOEiJXY/gsHcOSFPuou49nH75C3iMN/w76y2ZI5cBlsIQ4zIHMk94X/omZGLplX/90cEcho2UUmrbrwq8fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7hn6+Iw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7hn6+Iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F70C4CED3;
	Tue, 17 Dec 2024 17:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455964;
	bh=xUjXYTbM/QJvZCKBh/nnWRWudFsyLrL1fVDQPNwzIiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7hn6+Iw59gt3o5LCr5fzbk/z5z95FGsQvElUWGKGsOylQq6yc4p2RDotTaxLz2c5
	 IOJ+QJYkJMpX3nqVmClThhnpLqMA5pwbP4nNn9GytdFhg1PZgYaWhpsz42CJmIJ/F8
	 SRKyApnl4hZvEKLKjks2cdbeFDxvOOOBq5QM3wk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	liuderong <liuderong@oppo.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 015/109] scsi: ufs: core: Update compl_time_stamp_local_clock after completing a cqe
Date: Tue, 17 Dec 2024 18:06:59 +0100
Message-ID: <20241217170533.998884171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: liuderong <liuderong@oppo.com>

commit f103396ae31851d00b561ff9f8a32a441953ff8b upstream.

lrbp->compl_time_stamp_local_clock is set to zero after sending a sqe
but it is not updated after completing a cqe.  Thus the printed
information in ufshcd_print_tr() will always be zero.

Update lrbp->cmpl_time_stamp_local_clock after completing a cqe.

Log sample:

ufshcd-qcom 1d84000.ufshc: UPIU[8] - issue time 8750227249 us
ufshcd-qcom 1d84000.ufshc: UPIU[8] - complete time 0 us

Fixes: c30d8d010b5e ("scsi: ufs: core: Prepare for completion in MCQ")
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: liuderong <liuderong@oppo.com>
Link: https://lore.kernel.org/r/1733470182-220841-1-git-send-email-liuderong@oppo.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5439,6 +5439,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba
 
 	lrbp = &hba->lrb[task_tag];
 	lrbp->compl_time_stamp = ktime_get();
+	lrbp->compl_time_stamp_local_clock = local_clock();
 	cmd = lrbp->cmd;
 	if (cmd) {
 		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))


