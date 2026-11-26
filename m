Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705734;
	b=HHsaq1PoxPJFrjx1YLR3FlzPUDQ/TvOJOC3WinEJUiMo7/RpaGTq7PVA02Xd4DSslV/W
	 /+ygKumbknaS2nV+5nNvu/MbgGkX7nlUmkF0coa4IXMLYAf4/T1Cl8tyNSyq8i/opRmIz
	 GuNZl95VjGDbsw9lBANm4EhMcRasHf5EBWSA+mo4UPPYYzuq4TsVgmdOiwtZXK1LUV5N8
	 qPMe5M0ULXzmr52ZA3lH4GyL9dCauW8um5sZ1/VyLDMMzekE65R/HLBvdtcsnSSE2CvyZ
	 5Bp0prwj3U3SLxfyfhIKUPKltpOvkspfzboshlOqTWe0TEOq21bAa7uefMkKRK7oc/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LCI1L4zgsMdqiKX1MHkwYGT3WiYJmrBnwCSwZTHuxPY=;
	b=e75OJCXddLaC9CDzFdAFpt6A9QWXUTo/W6jP+ZWRvRtBN+zLLy52NLLXga7N8/pPwa5E
	 R3Jztzifri5mHyYyWJOdEWMYuZTnjsN3ifYIk4iMM0Uo3INpvfdpxR7PCOYJUbvQYPQ61
	 dnTJW3GjyzpHNwo0hid/4+dlGRY4egE5osaWuiMcpn7lRgVQJkmzGTCLaWMKP3PYtJ8cv
	 ouFJj+Ns0CDL6sjgnnH4qoakT80TAp3+xkWvw0Jz2ga0gtc3CI+Arpcj4RCs3XwvyIyfS
	 tDrzGm6/L53fOC92kioPh4u3ASiS3/eYVT227FdvD4v4276OJSMGO5dAtyupkyH+Nhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NSfQ1s6y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C1E606A338;
	Thu, 26 Nov 2026 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NSfQ1s6y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF47D1F000D0;
	Thu, 26 Nov 2026 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705734;
	bh=LCI1L4zgsMdqiKX1MHkwYGT3WiYJmrBnwCSwZTHuxPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NSfQ1s6y0FGXvQ6/WF79iKyEb+6PYwY8WwkyRHaJ/0CXVoakC0mZOiMHHP1IAxvyC
	 eI4QXCx6nM7CPIpFmWY1VskBOC7WYP6SW1FhY6xKPekq5RpgEodFJGPorsedlXkXvt
	 I3KXMtouHmMis2mPVdbxATNlCBBdFiH9wMIM1Ksg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
	Joshua Crofts <crofts@kernel.org>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 296/319] iio: accel: kxsd9: Fix potential use-after-free on removal
Date: Thu, 26 Nov 2026 15:41:04 +0100
Message-ID: <20261126144013.439909531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>

commit fd7334314f63a3a2a4927f209b2ca0e33d111840 upstream.

Unregistering an IIO device with an active triggered buffer detaches its
poll function. Freeing the poll function first can therefore make
iio_device_unregister() access freed memory.

Unregister the device before cleaning up the triggered buffer.

This issue was found by our static analysis tool under development.

Fixes: 0427a106a98a ("iio: accel: kxsd9: Add triggered buffer handling")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Reviewed-by: Joshua Crofts <crofts@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kxsd9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/kxsd9.c
+++ b/drivers/iio/accel/kxsd9.c
@@ -484,8 +484,8 @@ int kxsd9_common_remove(struct device *d
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct kxsd9_state *st = iio_priv(indio_dev);
 
-	iio_triggered_buffer_cleanup(indio_dev);
 	iio_device_unregister(indio_dev);
+	iio_triggered_buffer_cleanup(indio_dev);
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);


