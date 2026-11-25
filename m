Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626251;
	b=oQht/M4V5MLz5k23yZqdFNaqG6TExEWiPJeoyC4T6NhqcUBrcMYmqYltiQGd5pQXk3hW
	 4fXgSHySo8EEHl7Aso1SmDoz4F5dcpw5z3wvTQ8RoPV5z9dLfDPJXFvaif4Krj7B9FhBy
	 a+f4Iv2jq2+6UTfrQm6TPSgMdIl5bzqTRvx8jfqXxEQBjfZCfx85/fukhkqFi0DP+kY5S
	 eq9vXn/IpkyXOF5vJiJISXAv08aGe5/ZfhWwZ75J+sWNB+4gKV/LxsrMVqm1bU/6F3O4r
	 Ss3BQuhkJVALdI3yLmC9w0WxulW5islI++arUka+ZJmL/OfHS9Qju91Nvd+6hURAhMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5+MsSRv/xPKKny9Iq+6zUiCHpx+zuOMd8CzB/6M1S74=;
	b=zoYkuoqmVK8UooqrLhWBkn/sea6uu4CitThRgz4yhX3/470nd+BiUHGU1C0FdGesYYCs
	 /+IMppNCIXAU/8iJgxbt5GXYK0mMwOD7+w0erwHOA7orPY6MVSI2Yy54Eaua0gtiIc2K2
	 flQGGcFAhJ2KO3G6aKJ2nrjy/CvL6FgKrFFLnFgLMSMICWqPrfGZDlLeqx8obTVmnva60
	 1DlZEoK1SJsolvDdO7oNs1mE9wDo33D43q+86ZR1glbcSDH3g2mlhvFQNJDouv4uOA1sJ
	 SWVwOyJxDG//cvi6B4viTgHeIszBOzCU4yr6k+dltqhCRn5K8USfwaC0GD73aPlh6eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VuV4qoOz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FBC606A321;
	Wed, 25 Nov 2026 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VuV4qoOz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D121F000C6;
	Wed, 25 Nov 2026 17:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626251;
	bh=5+MsSRv/xPKKny9Iq+6zUiCHpx+zuOMd8CzB/6M1S74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuV4qoOzwq8fZmGGk0gr5MC08PfJl8BSUZKvrTAFlPAou5FbXDVt7L45wy5X7JZVM
	 CMiyDW7IwGmCfNMlZ44uy9glQEKB/DFQuamOJhvqkhyEzEyeX6giijyJdrseVIqi0J
	 QGANP9diA2Ux0fPNTZhCHp1vJsYx4DnN8UzlVqRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
	Joshua Crofts <crofts@kernel.org>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 781/816] iio: accel: kxsd9: Fix potential use-after-free on removal
Date: Wed, 25 Nov 2026 15:38:49 +0100
Message-ID: <20261125143907.250833365@linuxfoundation.org>
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
@@ -481,8 +481,8 @@ void kxsd9_common_remove(struct device *
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct kxsd9_state *st = iio_priv(indio_dev);
 
-	iio_triggered_buffer_cleanup(indio_dev);
 	iio_device_unregister(indio_dev);
+	iio_triggered_buffer_cleanup(indio_dev);
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);


