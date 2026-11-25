Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625809;
	b=pDcp1/2PeXBg5snl54Jt20sYsJfrSZT9XOIXeI1GQiQaIroIZCAW26qoXzZb9GigHqFF
	 C4wX4kPcc1kyI1zGQv2zQ2eVlbAsqVQrDBm1S9AMWu7T8lSTEJOyPl9it1t3WfH/nT9ez
	 5thc3HWXgdJ8N1lmSNIyocfkfa+mdby8yc+KLbUvWCnb/PSqRRCvUq0f6mx9sefDziaSp
	 J4hjONaXwwXeNz/m23vjB/c/bkQqynDLMx9AmbENIUYKFyBk6EWHzvuE1kv0NfxHNlKwE
	 nwXTBuxsoJ6svAJTkzF/zct/nqtoArrw2supuRfU86PylbAyd+9yRlTIDPIT2PN1XhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KTEVrhclPGd8JnQOB+rr37n3rFBFnzrEC0eNdFpStHA=;
	b=WIgINY0iQSrjY818SDJV/RfhgezTLdK/N9WVlqESXvjUo9+U9ZT8e6uyR/Z4v5zyF0Oe
	 ozkgL1RgyLmYcGhsT8VEkNap/F70OaaNoqUbczoYdD3Era1jFmuG5MPLQpQJlh8YVhuu9
	 fYb6HChefsjTHPOVJjxh247i5NlCHAqG9QY3R21xScTrh2nVQOwlcdzcTkraj+ohQGeJT
	 xO65ycryKUplD++4ngh/5hWqb6HaW/JS9ZXvkcmyThUyusnzpY+thkO26ZYaSw1Av2Ij7
	 4LK7X4IKwhoXfMPOCfnuro5Th1Iw7gxsaFWftK7j2ZbuxnBFKV70t62FHyCaTsqEHeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhvc+OrB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67931606A31E;
	Wed, 25 Nov 2026 16:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhvc+OrB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D251F000CF;
	Wed, 25 Nov 2026 16:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625808;
	bh=KTEVrhclPGd8JnQOB+rr37n3rFBFnzrEC0eNdFpStHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhvc+OrB4v+C5wQI+p96h2Km2jCW+t7s7U2wqjgiVSb14lfU9/2n9V4DnG5qmUTOS
	 iShijH9twvhZdQjETKaoeRkRaNxioGNlQUo7+nUrKbGbGypg2nBc783l3VT68kVzot
	 msS5phrkT0rVM+emH71633ymDmlG94gsKuluPGys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Mazzini <pmazzini@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 637/816] hwmon: (sy7636a) fix negative temperatures
Date: Wed, 25 Nov 2026 15:36:25 +0100
Message-ID: <20261125143903.929236495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Mazzini <pmazzini@gmail.com>

commit fc8519fab34e162b0c29dacccf73031820878917 upstream.

The thermistor readout is a signed 8-bit value in degrees Celsius.

Fixes: de34a4053250 ("hwmon: sy7636a: Add temperature driver for sy7636a")
Cc: stable@vger.kernel.org
Signed-off-by: Pablo Mazzini <pmazzini@gmail.com>
Link: https://patch.msgid.link/20261108093602.329554-3-pmazzini@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/sy7636a-hwmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/sy7636a-hwmon.c
+++ b/drivers/hwmon/sy7636a-hwmon.c
@@ -29,7 +29,7 @@ static int sy7636a_read(struct device *d
 	if (ret)
 		return ret;
 
-	*temp = reg_val * 1000;
+	*temp = (s8)reg_val * 1000;
 
 	return 0;
 }


