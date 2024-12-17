Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A12D1F75B5;
	Tue, 17 Dec 2024 17:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456519; cv=none; b=fNbV1aCsgo7VvMPcyg1mO6OJ1GMxe8qEexMygsEzfTv2w7rA2ejopa7DvR13pZXr54pMH+f2rg3BwGoeiKdemCwmZUdI5sp3I3Q4KA4FluCcm9wn6/PyZDBGN5cB9ZmWQeNklHOWPZUtYBFN/2P5FuyRDdG72OXTzJRhdY+NUPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456519; c=relaxed/simple;
	bh=17TcA64umqNhMDXWzk5Heo21Hwr4nWMC7Er/Ww55ltI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUru10u5yhIWXe9bKi9AXlB1nRBjz2Py7g1pwgv56K5w73yExkI6AVRwG7EWUKlnI9yq0SBYj8T2niAde0bYGWOVcLW0fwFs3BQKZnbZ5fVVpdOK9l2O5wSE3wGTisHJivZw+wCDDdMNbwICH3oA5KF24EFwqVcFCzHWjXwpFIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1vwGi+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1vwGi+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01099C4CED7;
	Tue, 17 Dec 2024 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456519;
	bh=17TcA64umqNhMDXWzk5Heo21Hwr4nWMC7Er/Ww55ltI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1vwGi+oiKT8F34bGxWUxDcB285eLYC48VQNbXMbubsc1kCULuHyazxoMzYq6bz8y
	 4hlgxSzpH45B5rigL4jXtEx7qzkJ+LdJI+GBc1zbAtjdPpLHpR94XnHw0FMQrvvijt
	 Oa3EAvuo6zPU2lnHedijcNqotSEx0xT4ClSmOjeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	liuderong <liuderong@oppo.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 044/172] scsi: ufs: core: Update compl_time_stamp_local_clock after completing a cqe
Date: Tue, 17 Dec 2024 18:06:40 +0100
Message-ID: <20241217170548.093665571@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5566,6 +5566,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba
 
 	lrbp = &hba->lrb[task_tag];
 	lrbp->compl_time_stamp = ktime_get();
+	lrbp->compl_time_stamp_local_clock = local_clock();
 	cmd = lrbp->cmd;
 	if (cmd) {
 		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))


