Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9151DEFE3;
	Tue,  8 Oct 2024 13:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392514; cv=none; b=s6G+XAg9Bx4jwVVoOG2Oc7Hf0jUkOaljpdaJWjxkXliTfFpUj5tsYZDJF2aqFIRPc2A7P0GVMOZmBsNOjHjIkbGEHVN5K/aUm1vwYdH4rpVCRyDe3vmDzvUqJzkl5Yys8FJn1HNhLG/HnqXdejLp+Hj+4rCTF+K48ZpdH/ZtFGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392514; c=relaxed/simple;
	bh=TzI+lqDij1uGJD2jt2xfzJaZSEWlLxeJy7NLgl9C9eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QK4/UxEbwcM7HluhqGdcDN7VRhSqrR9kvO+giMVaeXqXmiJr4ZUMZM2i55O23ffQkU0fwxf/4bWS04k8SnNu4Op4UipgnDzbjzWKY6j/FcXiIFF6SBkSC2Z2IzlH62ooBkjcdXB5eRFMaqWpjVMHVk2knLmHD4YjxdDPc4VAQUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVmJ2CPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVmJ2CPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91D3C4CECC;
	Tue,  8 Oct 2024 13:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392514;
	bh=TzI+lqDij1uGJD2jt2xfzJaZSEWlLxeJy7NLgl9C9eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVmJ2CPEh5K8zR+t/Fmgxtsh7A6W1tP9AkyzOCcyGSnnAjkuaAxODvpOjPXcxMb/L
	 IqlO2wPlYIrhyrntdqlasTkEkNIeHvFX3eOlhKX5aJQOVkGh3S0SrWUs7htL+eUAql
	 zP5luQ2TcRsfte9CpJfijb5/6dNQyL+KQrfEgB64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaixin Wang <kxwang23@m.fudan.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.11 437/558] i3c: master: svc: Fix use after free vulnerability in svc_i3c_master Driver Due to Race Condition
Date: Tue,  8 Oct 2024 14:07:47 +0200
Message-ID: <20241008115719.467967245@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

commit 61850725779709369c7e907ae8c7c75dc7cec4f3 upstream.

In the svc_i3c_master_probe function, &master->hj_work is bound with
svc_i3c_master_hj_work, &master->ibi_work is bound with
svc_i3c_master_ibi_work. And svc_i3c_master_ibi_work  can start the
hj_work, svc_i3c_master_irq_handler can start the ibi_work.

If we remove the module which will call svc_i3c_master_remove to
make cleanup, it will free master->base through i3c_master_unregister
while the work mentioned above will be used. The sequence of operations
that may lead to a UAF bug is as follows:

CPU0                                         CPU1

                                    | svc_i3c_master_hj_work
svc_i3c_master_remove               |
i3c_master_unregister(&master->base)|
device_unregister(&master->dev)     |
device_release                      |
//free master->base                 |
                                    | i3c_master_do_daa(&master->base)
                                    | //use master->base

Fix it by ensuring that the work is canceled before proceeding with the
cleanup in svc_i3c_master_remove.

Fixes: 0f74f8b6675c ("i3c: Make i3c_master_unregister() return void")
Cc: stable@vger.kernel.org
Signed-off-by: Kaixin Wang <kxwang23@m.fudan.edu.cn>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/stable/20240914154030.180-1-kxwang23%40m.fudan.edu.cn
Link: https://lore.kernel.org/r/20240914163932.253-1-kxwang23@m.fudan.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1775,6 +1775,7 @@ static void svc_i3c_master_remove(struct
 {
 	struct svc_i3c_master *master = platform_get_drvdata(pdev);
 
+	cancel_work_sync(&master->hj_work);
 	i3c_master_unregister(&master->base);
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);


