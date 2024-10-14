Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC0CE571;
	Mon, 14 Oct 2024 14:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915928; cv=none; b=fiej15WcnI5u9KvhSaDfUl/9bpDQ6ApKC8MRObmv2afSxu4pM1EfWgxuquSJlXphEAdnadAim5nu7y7eL8qsCxvfWzFk4flNzGg35ehwY9MILrO8DBZiUvGjQxhf1NPKDzTpWZBqQJZgYY1E1WLTfUbtJnPfO/7Hr9fh9BBOE6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915928; c=relaxed/simple;
	bh=J03i1HQyM7iUdbvZSudJr0Ioru5sMhP5qg7smyfT7mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g80DyMDYaIsP4hiQXnNphqxKodFFi4sOalyOPvJkOm0oB98U2FgVsnDb1IsA9y9wYVTQOsvsFeYzRB0lyv7gA/tV08tfqCre/KojADNlT4ZgZAQ9WQxi1aQu3Bw3aX+oGi6hyQt0nYPce5l0Q0x1tkJzqFDUeLkEcT9GRV3w1w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKaYTkhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKaYTkhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7B1C4CEC3;
	Mon, 14 Oct 2024 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915928;
	bh=J03i1HQyM7iUdbvZSudJr0Ioru5sMhP5qg7smyfT7mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKaYTkhPwYglIy3/q1Lkmz2HtdkwhdQGo5yg+UuGaXfYdJ0hhRoe4D1oU+p6uQdJK
	 410c6g0LepTO9J55z1AvlH6OynavgzK2Hj6xDXs7zlT9MQmKoxKVNMfYF29bE5hzuX
	 fpdciLaMZdj0pkmJe/h8S4j1VLLzqdt6vz/fxtxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 040/214] ntb: ntb_hw_switchtec: Fix use after free vulnerability in switchtec_ntb_remove due to race condition
Date: Mon, 14 Oct 2024 16:18:23 +0200
Message-ID: <20241014141046.554056498@linuxfoundation.org>
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
index 31946387badf0..ad1786be2554b 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -1554,6 +1554,7 @@ static void switchtec_ntb_remove(struct device *dev)
 	switchtec_ntb_deinit_db_msg_irq(sndev);
 	switchtec_ntb_deinit_shared_mw(sndev);
 	switchtec_ntb_deinit_crosslink(sndev);
+	cancel_work_sync(&sndev->check_link_status_work);
 	kfree(sndev);
 	dev_info(dev, "ntb device unregistered\n");
 }
-- 
2.43.0



