Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F901714A1;
	Thu, 15 Aug 2024 13:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729846; cv=none; b=aYzhdD+ibbtjxzbewyd5A4gmGL9SwLl5FkHwqAY9A2Bbx8w6zrGsSZE04JJS1cNeJ2dvIBCUveL5x7T/rQGt4klkpMgwdv2/3Mg1ukszKeyDAp2lhljXjWNn0tGtxO4SidkxhhBQQJMTOoXUFoEisFGIVFdHtWh+kRLNerBHm0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729846; c=relaxed/simple;
	bh=EZKOunM+7VTaJm3XfYDjxWXtmU6oSTJs/tLdcuHaTdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSC2w4XjqKqrtj11tWjU33bMN0YAisbE7MsJ0Lmax4ajdU2nFlvc+Msd+NMSEjSnHiPG6COoa4cYUk5GybL0I3s59rRqxHox2SPEignkhH3RBrbaP0Iyv27t/AfyCj2FJZrxcPv7JHBwyxen+j7gc8SsbRUT0FlRXRA2VYr28A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jirZs01N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jirZs01N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD64C4AF0A;
	Thu, 15 Aug 2024 13:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729846;
	bh=EZKOunM+7VTaJm3XfYDjxWXtmU6oSTJs/tLdcuHaTdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jirZs01NXN2WXbZTjwdvKxwyW2vTfs1PKBt90mgsBzxG5Yn4Zl48WUDbA6QqHcDO3
	 zGw2e92LBtLrcJzRbozg5QQA32TgK71jKdv3FYhNplbXn4UZmJn4TyNBvwXdjM3zDO
	 biHxZXpOFmBsEPWxn60flGbooI9TvEkEugbCFR9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 225/484] scsi: qla2xxx: Fix for possible memory corruption
Date: Thu, 15 Aug 2024 15:21:23 +0200
Message-ID: <20240815131950.101042743@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shreyas Deodhar <sdeodhar@marvell.com>

commit c03d740152f78e86945a75b2ad541bf972fab92a upstream.

Init Control Block is dereferenced incorrectly.  Correctly dereference ICB

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240710171057.35066-4-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4634,7 +4634,7 @@ static void
 qla2x00_number_of_exch(scsi_qla_host_t *vha, u32 *ret_cnt, u16 max_cnt)
 {
 	u32 temp;
-	struct init_cb_81xx *icb = (struct init_cb_81xx *)&vha->hw->init_cb;
+	struct init_cb_81xx *icb = (struct init_cb_81xx *)vha->hw->init_cb;
 	*ret_cnt = FW_DEF_EXCHANGES_CNT;
 
 	if (max_cnt > vha->hw->max_exchg)


