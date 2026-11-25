Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623778;
	b=SEmtU0rEq0xKB60RSS/YadYUA9VlTUZ7B36ns6gPF6aTUtG+7PCfnfXd6oOu5DSGlutP
	 PQCDjJKQ/gw8K/eWGN79nC+Kfr+THxAR1yZGr2GyZPHJsup1TNlwItiXYoC+JrLp0UPzk
	 IZKHXCCKT3kqJCReGVOtY47MKgTh0ufPVCAjxumm8znQB5VfifqE2HlCLzfZ0Vtx6zCom
	 S3HSlNP3bAB89TIUkDU/rvshYk36lR2zqa7D63ym2mQroCabY4ccSll4pkAvBs8tu6FQz
	 TLiLrPV9Y9TU34UnpqNePtk+ciOd/6F08gXZK/TJ/EmfqDCZjCvYqkjmAi96bj2f/ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3l5pzFBd/vxXqXG1v9DAZSuG9q3w5ARp7MUNA25Y6KA=;
	b=ImgVCoPO2rt/ch6UQezm6A++huuwDiKxQ7TDjn1CrfmLMAaZAQwKN8TDyODkOkbSp4gC
	 uh4mBp4fmpDlpzxedEKKkistzJHjjKdDrDmutXhv10tTBoQFmXnlvSxpR/JQdM0tintQL
	 Aw7HVrd0rFHtwwlsmRranAOFBUa1bSsnQSsAbyOMR3ECGjwYDUhYJW4fSZInI9cLUtkRK
	 Nu/6WVVkWt171o6VIvRycI+KRRfk47Yh6le9mbgwpTFmD9S1b0TGO2aguRKui6FY6uYyO
	 DVlnvJOKBZBrUc5lL1GUc4jLSCYIoNTWkcM2lFgf0sQVf+F8umovAtXpe2Z3NPlKS6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1g9MIji;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D908B606A323;
	Wed, 25 Nov 2026 16:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1g9MIji
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57F71F000C0;
	Wed, 25 Nov 2026 16:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623778;
	bh=3l5pzFBd/vxXqXG1v9DAZSuG9q3w5ARp7MUNA25Y6KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1g9MIjisKO2YWKCZbohp6wIrnriDZ3vn6DqE5koFsli859+7Y2D8CB9nxjIYROD3
	 rTmkkJcp5f101A12dFiVnGrzMAAa/efdGFXt6C0WVOZLFeAA/3tJZf7gcMUWj9Ed7i
	 gOhjUF+2dIUkctIxBeXw1JIVnKiiE1QFDtJkf+O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 966/990] iio: trigger: free the trigger ID after device_del()
Date: Wed, 25 Nov 2026 15:38:53 +0100
Message-ID: <20261125143844.611849277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changyul Lee <lcy8047@gmail.com>

commit d32bf759801e6df23038dc834622a122ec76a4dd upstream.

iio_trigger_unregister() returns the trigger ID to iio_trigger_ida
before device_del() removes the "trigger<N>" device. A trigger
registered in between can get the same ID, and its device_add() fails:

  sysfs: cannot create duplicate filename '/bus/iio/devices/trigger0'

For example, adding a sysfs trigger while an hrtimer trigger is being
removed through configfs, or the other way around, hits this because the
two paths do not share a lock.

Free the ID after device_del(), as the error path of
iio_trigger_register() already does, and drop the "Possible issue in
here" comment.

Fixes: 1637db44413e ("Staging: IIO: Trigger support added to core.")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -105,9 +105,8 @@ void iio_trigger_unregister(struct iio_t
 	scoped_guard(mutex, &iio_trigger_list_lock)
 		list_del(&trig_info->list);
 
-	ida_free(&iio_trigger_ida, trig_info->id);
-	/* Possible issue in here */
 	device_del(&trig_info->dev);
+	ida_free(&iio_trigger_ida, trig_info->id);
 }
 EXPORT_SYMBOL(iio_trigger_unregister);
 


