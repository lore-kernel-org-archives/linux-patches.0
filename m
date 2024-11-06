Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608D21DE3B4;
	Wed,  6 Nov 2024 12:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895312; cv=none; b=IrYfT47LboBN8h4Ekd3PA3lF/EzFpiXOBQD39cV2fWgDWclu5Br+ydFZQqi4qz47ME4tF8Cr/Zk1xCafgYp6ATpBTl7CbqO9zjGgvRcfvDvgjQu+WxmYAMsuU60apUpeyJmNJqJzF3+Mo/LA8z9+NJA61Y1sX9RIMn0E9ZbBmLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895312; c=relaxed/simple;
	bh=3v8tg343IBvLouJt1zPspvx66rSmqZBb1omC5Pe9YAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYKgK8H7cJcMxn22RMc1VKlRNqD83lude2NKMfAzwKYm4TDc1C8zQYfLEtLw/deqqHukZfE+Qwg1kQvmLIsfBrEwvZNjCWM5kcflK90Yj2JJT0EX6OuX5XLaD6PWRB1S7EhHEUHHSy3BZjfsVKpJiERWBOpQncQyauOQMfxNgww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPChj4kX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPChj4kX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FCDC4CECD;
	Wed,  6 Nov 2024 12:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895311;
	bh=3v8tg343IBvLouJt1zPspvx66rSmqZBb1omC5Pe9YAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPChj4kXDnrlY2o2EMtc2vS7V0OW2PhUTnCDet6+0Crw+BOyIBhSL1DPG4CdJ9x1Q
	 NgyRNoigr7LJG1HpauCGWBGTkj8uBd0XLMUScZCpbXAtvwGPeVx7UT5aE4t9Q0OwJy
	 9ww0ROXsM2ozjK06/gjifU/+CO8MQBLwz2khwxwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 128/350] pps: add an error check in parport_attach
Date: Wed,  6 Nov 2024 13:00:56 +0100
Message-ID: <20241106120324.068735754@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 62c5a01a5711c8e4be8ae7b6f0db663094615d48 ]

In parport_attach, the return value of ida_alloc is unchecked, witch leads
to the use of an invalid index value.

To address this issue, index should be checked. When the index value is
abnormal, the device should be freed.

Found by code review, compile tested only.

Cc: stable@vger.kernel.org
Fixes: fb56d97df70e ("pps: client: use new parport device model")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/20240828131814.3034338-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/clients/pps_parport.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/clients/pps_parport.c b/drivers/pps/clients/pps_parport.c
index de49ae85adbeb..9710207bce7cc 100644
--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -159,6 +159,9 @@ static void parport_attach(struct parport *port)
 	}
 
 	index = ida_alloc(&pps_client_index, GFP_KERNEL);
+	if (index < 0)
+		goto err_free_device;
+
 	memset(&pps_client_cb, 0, sizeof(pps_client_cb));
 	pps_client_cb.private = device;
 	pps_client_cb.irq_func = parport_irq;
@@ -169,7 +172,7 @@ static void parport_attach(struct parport *port)
 						    index);
 	if (!device->pardev) {
 		pr_err("couldn't register with %s\n", port->name);
-		goto err_free;
+		goto err_free_ida;
 	}
 
 	if (parport_claim_or_block(device->pardev) < 0) {
@@ -197,8 +200,9 @@ static void parport_attach(struct parport *port)
 	parport_release(device->pardev);
 err_unregister_dev:
 	parport_unregister_device(device->pardev);
-err_free:
+err_free_ida:
 	ida_free(&pps_client_index, index);
+err_free_device:
 	kfree(device);
 }
 
-- 
2.43.0



