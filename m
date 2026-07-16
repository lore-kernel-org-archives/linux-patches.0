Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA0A431A3E;
	Thu, 16 Jul 2026 14:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212223; cv=none; b=VtiiPdRrFyeVTv/cAA4Vgwu1mCx1TGe2/ewTwKAyxofYtESJ44/JQ2GVTgHpEoB4fJez9evH631fNMzbCLZo6lXS7ikd/RO2yubiddiVuj+akVV/pTOIzhVj3vEoEnMiBsaUm7pSYa1SBmcg+KSTGaKO2Y9ql7q1Do97kuhXcUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212223; c=relaxed/simple;
	bh=YLHmGY2GLD5UforIuxAvRWR2eWgy9K+rgtz5aoAOcx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J08MWbTryk02SlQObWNS9UlN5JOJvSyUWX7pI+NGgRybsWYqQttvvtDEPfaqZhfa4lSKvZYAwU8MDBiZxmSdvRy/JXAICIyjzAnGKSxQE1Agyg9cLYYZCLJR8EiGpqfRv3fie4msqbGaDSvIuUZ/2ibLaRrsSpnxkGcuPjaQgIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M23/MFih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M23/MFih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39D61F01559;
	Thu, 16 Jul 2026 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212221;
	bh=CvFPqb2mlC3jsQqFT75gqSdKwvGRKt4NXXtiYbRFMoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M23/MFihXZPaf4cACWUKfB4mwQySbZPDDQ/NGqn8Fq7wNorSq+Zc8vyBib6IxcYN5
	 aAtt66kgGftp/oA8VWuiKUK1AXm0PPZodZbHhp/cuJjyh4R79dQVGT1v+/xTPlm4jb
	 7XZ/mj791642yZvyf/qfyOWUquF56nn30W9LwIKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 246/349] usb: typec: anx7411: use devm_pm_runtime_enable()
Date: Thu, 16 Jul 2026 15:33:00 +0200
Message-ID: <20260716133038.861087156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 0ef7cc27da8b9e315a4a5a665c68c44206f5e559 upstream.

anx7411_i2c_probe() enables runtime PM before returning successfully, but
anx7411_i2c_remove() tears down the Type-C partner state, workqueue, dummy
I2C device, mux, switch and port without disabling runtime PM.

Use devm_pm_runtime_enable() so runtime PM is disabled automatically on
driver detach. Since devres action registration can fail, route that
failure through the existing probe unwind path.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: fe6d8a9c8e64 ("usb: typec: anx7411: Add Analogix PD ANX7411 support")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260701114006.75738-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/anx7411.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -1538,7 +1538,9 @@ static int anx7411_i2c_probe(struct i2c_
 	if (anx7411_typec_check_connection(plat))
 		dev_err(dev, "check status\n");
 
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		goto free_wq;
 
 	return 0;
 


