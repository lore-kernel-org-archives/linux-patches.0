Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE591EBFF4;
	Wed,  6 Nov 2024 13:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898769; cv=none; b=lIb0o32NWT+dFwXSgOrCHNrKUCOki5WKnDIxGhnCUE6EKYdgNlymVwGI5nNbzY08FjADb744t0Qk7rnbEtjWIHk8Eoy2qch0Cu+mHWoOeKSCgN9XV0ThOyIZ+ejvQ7inU74igNULnCRrCZ0ZLNeeyZ1VfyO27UlJrr1yqIY7uQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898769; c=relaxed/simple;
	bh=C8BUso7La/1GsDTppKfc8BRiwsnMQWzxcKroVZvNODg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YP+LAAoRiz7lX06svU1zP9GXZMFiv4QSUE1eL+J2310DCLmOJGyWAJbYgsDgpA7nerPKwcjAu207OK73dmW3Jno9nYMxsX5/dcBVQ/QI0i1ZhmBzmETag46wMdqeOk/UoLMYw7LKWubBakphDNXZBOv0sxSzgH5dN05X50GdQAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1+RG7yr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1+RG7yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2657C4CECD;
	Wed,  6 Nov 2024 13:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898769;
	bh=C8BUso7La/1GsDTppKfc8BRiwsnMQWzxcKroVZvNODg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1+RG7yrmxZKofUaGgg3ZvNNinnnBaInNdWNha33cwYBJb0kuCIvLenwzICKFbjWU
	 Q69WtQAVyQ82Yke5EQ4HDqwLbmkeRh1un5VDCfcyiVBDFhhqL7q4p7ShKPhXn4S7Bt
	 5VIohZcDLusZEJUeGtDaA5Z/AjvSx6XVCki8nN48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 313/462] ntb: ntb_hw_switchtec: Fix use after free vulnerability in switchtec_ntb_remove due to race condition
Date: Wed,  6 Nov 2024 13:03:26 +0100
Message-ID: <20241106120339.256863765@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaixin Wang <kxwang23@m.fudan.edu.cn>

[ Upstream commit e51aded92d42784313ba16c12f4f88cc4f973bbb ]

In the switchtec_ntb_add function, it can call switchtec_ntb_init_sndev
function, then &sndev->check_link_status_work is bound with
check_link_status_work. switchtec_ntb_link_notification may be called
to start the work.

If we remove the module which will call switchtec_ntb_remove to make
cleanup, it will free sndev through kfree(sndev), while the work
mentioned above will be used. The sequence of operations that may lead
to a UAF bug is as follows:

CPU0                                 CPU1

                        | check_link_status_work
switchtec_ntb_remove    |
kfree(sndev);           |
                        | if (sndev->link_force_down)
                        | // use sndev

Fix it by ensuring that the work is canceled before proceeding with
the cleanup in switchtec_ntb_remove.

Signed-off-by: Kaixin Wang <kxwang23@m.fudan.edu.cn>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index 86ffa716eaf22..db9be3ce1cd0d 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -1558,6 +1558,7 @@ static void switchtec_ntb_remove(struct device *dev,
 	switchtec_ntb_deinit_db_msg_irq(sndev);
 	switchtec_ntb_deinit_shared_mw(sndev);
 	switchtec_ntb_deinit_crosslink(sndev);
+	cancel_work_sync(&sndev->check_link_status_work);
 	kfree(sndev);
 	dev_info(dev, "ntb device unregistered\n");
 }
-- 
2.43.0



