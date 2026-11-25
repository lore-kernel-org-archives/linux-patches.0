Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623705;
	b=NDXdyWvwGlvDZkQ1vzx1eLupp0IVpLF130xUvAzfqYQ1Bfvhrdu36AKydMN3ZGrQvNpX
	 lbVjdL8qpN2+ylul9m6ilp8srCDj6FUQZm2m93Smsn/LK4/vyf6XxhDVRI6PzZZsHnKXH
	 8sOMD6cxIHwUEpREzVdvWB4lnXUYCoL13EmCsO5S2E7McRR/EAojkh9ED9dksv9kgcou1
	 1IC37bzdfUneJXspvYuzziRllrPrJkI8GOU2/zjobzadx46tl20W6Kqq66uwTWbmnc+qd
	 8Py0nif/jOjBsrVhAPhWqkl9SsZb7IzE0Xtom3ipuGNoSdfyLN3pCy03f/LGEcaII2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/pyij3NP/Ux8dIt7auFNEsxczAg6xdiH0hc+uXSER3k=;
	b=fdurkjW3EufUouPZnqrEosCxsXJ82k2vZDCcyRDNR7omF9HbO3F11DeRPSpAFVDBJK3W
	 ovlE+2YAXXhVyl61vZNTjvNiQyIX0i21+RjGVS+pZVVps3kTjiuz4TYnPl8bMIkIqZTMQ
	 /eC8Zs7MwAFatJOU/96UFwGj29rIPR9fUoOcBOgSdSSNRbMkHyjnBkmA3WlqUx7h4QB8W
	 4FTvN8nv2eWo5lN5c6j84jyRNgEfH65igOoFnYyZj83AAKET0JYySmESmZN7SHK8oUW0Z
	 MG8xxT09veeQ5nxpnEHM6QU9Fr5xTQDUUiXSkJ7GvxwHvAgBBLVQUzlx1JZct1uA7DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fi//z0OD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF824606A31E;
	Wed, 25 Nov 2026 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fi//z0OD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6591F000D1;
	Wed, 25 Nov 2026 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623704;
	bh=/pyij3NP/Ux8dIt7auFNEsxczAg6xdiH0hc+uXSER3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fi//z0OD/Cd07Vm7hNDeJHsNeqjvpU5nRf6IV1+IKjENaUT5tU6UZ4iqCg52LNoIx
	 KasCzFovkP3EXOg/JwrNrXvyRc5R26uGUzfaor6PSkUn6TMd4a/mtucG/n0/rbK8Ar
	 7l2UE/x8P9xDE46B/HJY4nkgsFuZOrcHoP82mzvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
	Joshua Crofts <crofts@kernel.org>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 945/990] iio: accel: kxsd9: Fix potential use-after-free on removal
Date: Wed, 25 Nov 2026 15:38:32 +0100
Message-ID: <20261125143844.126472154@linuxfoundation.org>
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
@@ -478,8 +478,8 @@ void kxsd9_common_remove(struct device *
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct kxsd9_state *st = iio_priv(indio_dev);
 
-	iio_triggered_buffer_cleanup(indio_dev);
 	iio_device_unregister(indio_dev);
+	iio_triggered_buffer_cleanup(indio_dev);
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);


