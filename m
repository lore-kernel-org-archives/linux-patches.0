Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3F91BDA95;
	Wed,  2 Oct 2024 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876989; cv=none; b=n80BHG/tIRg/8kEmvrCsnXLAwvi3V9NmUopC8lntB6xIdza38nSMdts0P3A+JuezlhaHxZZIJ/wXAQii75dWdERi2QQKlIz28FZxNj1ihijc4WZSo5SFrLNU0CRQ1GqWgzzZaBbfwn6jMWxeknt1CqJRMHO94kO/seieK8d7Hvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876989; c=relaxed/simple;
	bh=0Kql4L1RZSAZzOWcB7nvlFEJwyytydj6PYZ9ctGMc1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVS1W0DFC4YveH5X7iRMR8zrPBvb4qFCcmJE6lZ66IZKNxjSyWlAp7aKHa1ETpxEYGMv3FlbpLVyseveEDKTd+JlQYnWRgSc4YsmNoUFSPV50H6KhcPbi1v2QMORicIlfo6l2Y7QzMMyNWEF+o1i30E2tR4cPa2DloiiaMYLma8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+xRERlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+xRERlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39C0C4CEC2;
	Wed,  2 Oct 2024 13:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876989;
	bh=0Kql4L1RZSAZzOWcB7nvlFEJwyytydj6PYZ9ctGMc1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+xRERlbjfWyJX822VzOsIXVF8TP14xNm+M/VChIYBvu8Pve/F2GowDrA1GYNtMQd
	 9U4o7ke53IWSv//qO8pbShA5xxSrqYZcPAdJ2vIKmGL/zzeWehEZVNFB18Qs5v2M7i
	 a6WJEpy46ucv9Vw+M8SnCCv3+Ry25EkSqgull+C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: [PATCH 6.11 595/695] pps: add an error check in parport_attach
Date: Wed,  2 Oct 2024 14:59:53 +0200
Message-ID: <20241002125846.261531926@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 62c5a01a5711c8e4be8ae7b6f0db663094615d48 upstream.

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
---
 drivers/pps/clients/pps_parport.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -149,6 +149,9 @@ static void parport_attach(struct parpor
 	}
 
 	index = ida_alloc(&pps_client_index, GFP_KERNEL);
+	if (index < 0)
+		goto err_free_device;
+
 	memset(&pps_client_cb, 0, sizeof(pps_client_cb));
 	pps_client_cb.private = device;
 	pps_client_cb.irq_func = parport_irq;
@@ -159,7 +162,7 @@ static void parport_attach(struct parpor
 						    index);
 	if (!device->pardev) {
 		pr_err("couldn't register with %s\n", port->name);
-		goto err_free;
+		goto err_free_ida;
 	}
 
 	if (parport_claim_or_block(device->pardev) < 0) {
@@ -187,8 +190,9 @@ err_release_dev:
 	parport_release(device->pardev);
 err_unregister_dev:
 	parport_unregister_device(device->pardev);
-err_free:
+err_free_ida:
 	ida_free(&pps_client_index, index);
+err_free_device:
 	kfree(device);
 }
 


