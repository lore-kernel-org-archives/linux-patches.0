Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D80D2772A;
	Thu, 15 Aug 2024 14:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732392; cv=none; b=AVIuOQSWlknoZumPhRd4ly3zKfoz/BBoPamjYMjaguWYzqloBEIbXHRRv47gJQfnqmCRR3QTbXG+HZN3RnPH15gAMDrhAOs897sSRrUXBi0LKnmKEHGvu/D4aYs0FV2BkbNEAk69WOc0oTwKXYXthw5o09JcUOxKpFFRJ+nds3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732392; c=relaxed/simple;
	bh=+OQa2j1MZG4sxqQ+w7gUZpdv9m3DvE7pzFGn84wbBWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvHw1G9dQBjTvs/KM73WkHo6B2qQ5b/4KaaRLxnReAmJD92FT+CtKwqVLCirpYq1QRGTnNcWSTGDztMdVyVERQpXXdFcD7peV6dgHPvPye3Qmecq8YOi0GWqKY7ZzObsCHTBCB6w8KNe7jZrdx09A8SAVOi0XnjF42/GEyN2Lu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=doXym4do; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="doXym4do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDCCC32786;
	Thu, 15 Aug 2024 14:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732392;
	bh=+OQa2j1MZG4sxqQ+w7gUZpdv9m3DvE7pzFGn84wbBWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doXym4doV8pNauSpjNN30QDwbeMQfDswVLRi5e3vDTmuvVw/evmqz/ubpQUsfsUmS
	 50davr4HGBRuZVx0s+e6L2fb3D/f84G7ySowdpQmJFeVCSr0GDHABCMjmgaGVDlNwX
	 rabh40xhtFJ81sJvvTHLUPHE5m3vkpmXhnXNdCjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 166/352] scsi: qla2xxx: Fix for possible memory corruption
Date: Thu, 15 Aug 2024 15:23:52 +0200
Message-ID: <20240815131925.688518313@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4453,7 +4453,7 @@ static void
 qla2x00_number_of_exch(scsi_qla_host_t *vha, u32 *ret_cnt, u16 max_cnt)
 {
 	u32 temp;
-	struct init_cb_81xx *icb = (struct init_cb_81xx *)&vha->hw->init_cb;
+	struct init_cb_81xx *icb = (struct init_cb_81xx *)vha->hw->init_cb;
 	*ret_cnt = FW_DEF_EXCHANGES_CNT;
 
 	if (max_cnt > vha->hw->max_exchg)


