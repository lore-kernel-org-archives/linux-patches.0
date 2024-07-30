Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F2783A17;
	Tue, 30 Jul 2024 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359319; cv=none; b=hNb8xQy+lqy/NlTpaMI41IpdKapb4fb1ieY+cx5G6EdyQfqMZUJGHpaktFZ/g/KlrLO6WrzhxiYpB3FrSzOnvpyj47Oi3odEofO3dK1Luj/nDEFeKFZO6coe6qhEcsByInehte25lYLifixaDKIQmBvBb5KbRF7RfI48zs0k02Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359319; c=relaxed/simple;
	bh=DJTWFR+Fzsx0uVRaZ521vDSZLXyFaCYlA0xXVMiYye0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIL85pn74GqwM1YUY37Oblu/eETSjnyWgCwa59O3Ek/LqkX5HvaT/dXYFHd0KIGusnoNDXbsMFEw8b9RkCDMYltSAf4ih8V/dds6B0i7LfYdUByav8FvvYzkKu6l/0YqhPlKNFt9aUKfanM1UkPvbQctUizPy6AWnDRjZRvJFSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1IVX+nW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1IVX+nW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90FDC32782;
	Tue, 30 Jul 2024 17:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359319;
	bh=DJTWFR+Fzsx0uVRaZ521vDSZLXyFaCYlA0xXVMiYye0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1IVX+nW7o2Is3vO1YTCy6V351qKN/khoIE233/LxBeVT4Cq6bWk0eBQfMVPwSr5G
	 GLfVr9prGiKjD6yt2vwAHuluv/czZen0ozaPshpNq66FzbZ6KyoIV6Iqez9Dh8dQw+
	 4odnQlSDQqH9uzapdkJchhZEy4sBjYCsJ+/NfWDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 461/568] scsi: qla2xxx: Fix for possible memory corruption
Date: Tue, 30 Jul 2024 17:49:28 +0200
Message-ID: <20240730151658.039066774@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
@@ -4688,7 +4688,7 @@ static void
 qla2x00_number_of_exch(scsi_qla_host_t *vha, u32 *ret_cnt, u16 max_cnt)
 {
 	u32 temp;
-	struct init_cb_81xx *icb = (struct init_cb_81xx *)&vha->hw->init_cb;
+	struct init_cb_81xx *icb = (struct init_cb_81xx *)vha->hw->init_cb;
 	*ret_cnt = FW_DEF_EXCHANGES_CNT;
 
 	if (max_cnt > vha->hw->max_exchg)


