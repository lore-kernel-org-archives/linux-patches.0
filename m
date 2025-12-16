Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968A4359F9D;
	Tue, 16 Dec 2025 12:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886704; cv=none; b=CBo2SfKogGdITzgo9yA5XP+CjiAwZHzVd+ALEs50RGgfdvjUoh5iQwETOI2YsWshbLOjsi7OmXu8PhcLXg03dV/SlkJfQl1xSR/dNiOMey9gk1PlcKEjmQON9T+hMYOzbNfNT9jxTKRQsc32hO7op0OL4mCU6K1IuDFrSpu9QZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886704; c=relaxed/simple;
	bh=gHQHSIRIuXx4IUX+aDkJm27DJE5yW7qTPfX2USZBRq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=my3NZjbuUuD/xgPhcg242k6QUvySw2PmrCSPLEPxT8VqwAjFv+F06WmK6q/b4AibKsnjaaibUdLvYad8pLsPnzTZACfTAfJF0Juf4ktdUeLKcABTcuLUY+TZ+hI6MSmF6D1sS0X0qWzJjBHICCVT+HtmWxF9/Qs1EVlKJYcvwfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3d7z8IH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3d7z8IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4BCC4CEF5;
	Tue, 16 Dec 2025 12:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886704;
	bh=gHQHSIRIuXx4IUX+aDkJm27DJE5yW7qTPfX2USZBRq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3d7z8IHaP99r2ln/CvcvaJxhj6J+8a3+O8cPrlpiM/pJDCtEF18udDZFYYGK5OIu
	 5k0jDR7ZU9TAgbO5/ZCmxtewTt1br8lVPSCYO/3yo18JtTDX5snvIh77DJ6P1WyCUq
	 FNPYUIZdOwzWoBGIgkeUdBPq4VDFs6xJScpqoKJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 492/507] scsi: imm: Fix use-after-free bug caused by unfinished delayed work
Date: Tue, 16 Dec 2025 12:15:33 +0100
Message-ID: <20251216111403.264133605@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit ab58153ec64fa3fc9aea09ca09dc9322e0b54a7c ]

The delayed work item 'imm_tq' is initialized in imm_attach() and
scheduled via imm_queuecommand() for processing SCSI commands.  When the
IMM parallel port SCSI host adapter is detached through imm_detach(),
the imm_struct device instance is deallocated.

However, the delayed work might still be pending or executing
when imm_detach() is called, leading to use-after-free bugs
when the work function imm_interrupt() accesses the already
freed imm_struct memory.

The race condition can occur as follows:

CPU 0(detach thread)   | CPU 1
                       | imm_queuecommand()
                       |   imm_queuecommand_lck()
imm_detach()           |     schedule_delayed_work()
  kfree(dev) //FREE    | imm_interrupt()
                       |   dev = container_of(...) //USE
                           dev-> //USE

Add disable_delayed_work_sync() in imm_detach() to guarantee proper
cancellation of the delayed work item before imm_struct is deallocated.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20251028100149.40721-1-duoming@zju.edu.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/imm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 0821cf994b986..8a099bc27e06c 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1260,6 +1260,7 @@ static void imm_detach(struct parport *pb)
 	imm_struct *dev;
 	list_for_each_entry(dev, &imm_hosts, list) {
 		if (dev->dev->port == pb) {
+			disable_delayed_work_sync(&dev->imm_tq);
 			list_del_init(&dev->list);
 			scsi_remove_host(dev->host);
 			scsi_host_put(dev->host);
-- 
2.51.0



