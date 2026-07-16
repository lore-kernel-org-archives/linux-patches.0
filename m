Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C7B2F2619;
	Thu, 16 Jul 2026 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210569; cv=none; b=DEaumudI2OLToq1CDDHSJSNyrETf1fae3Q9eCyi3bTZ7TQ4iLliN9vDl/ydGuAlOmh2OmrNnmL8Vk6ar3Q2FhhshzLvoSKczmlRBXz3cB6EHbWje0QrigKE3LHVVG3F7QHDeiYL123ODBgRP/rdFbe8rheIzbmOam83mAU8FV5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210569; c=relaxed/simple;
	bh=Z/zlpF3CENEtulf0sS1JbZxLnkLFxOkXKUmkxbxFxtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyQJr+RsxbLKF+51Aw/o6VF+crSvCYw6+kzpdTqN4hyHr6LqJOrR6hYxh0NvqbVk5/B0M/IW90M2a3cPT6/XH1y/+qZlajBIlMw/hrwisgl+VzTfTEq/ZY6bve3GbYBh4pRkcyQXnUqgv9+xg1S7tdzYeu5OQdAqcKrTu7Zihiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6GbH8vI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6GbH8vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE681F000E9;
	Thu, 16 Jul 2026 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210568;
	bh=A7Myl3LNAFisfx/Gy51q0X8wwoGInmuzckm1mhAaMPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6GbH8vIUSFrxpdCWzqPI/+hLbne829GqnRY8sMsYjt6w+7Rz57f4JGvrSZ2kRtlg
	 cnsxwgEjglpCE2gDSFI30Y/VNUpVW4sV2BNl7l+QBFhnMYVgz/YFErSzHIoGqgvhB3
	 oyG3C25gA1IHuhCIuW6IV8SGO31PCPhwZKQlfhGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 090/480] iio: temperature: tmp006: use devm_iio_trigger_register
Date: Thu, 16 Jul 2026 15:27:17 +0200
Message-ID: <20260716133046.658032174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

commit 3c5eed894efd93d68d7f6a359a81ddef0e928774 upstream.

tmp006_probe() allocates the DRDY trigger with devm_iio_trigger_alloc()
but registers it with plain iio_trigger_register(). The driver has no
.remove() callback, so on module unload the trigger stays in the global
trigger list while its memory is freed by devm, leaving a dangling
entry.

Switch to devm_iio_trigger_register() so the registration is undone in
the same devm scope as the allocation.

Fixes: 91f75ccf9f03 ("iio: temperature: tmp006: add triggered buffer support")
Cc: stable@vger.kernel.org
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/tmp006.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/temperature/tmp006.c
+++ b/drivers/iio/temperature/tmp006.c
@@ -350,7 +350,7 @@ static int tmp006_probe(struct i2c_clien
 
 		data->drdy_trig->ops = &tmp006_trigger_ops;
 		iio_trigger_set_drvdata(data->drdy_trig, indio_dev);
-		ret = iio_trigger_register(data->drdy_trig);
+		ret = devm_iio_trigger_register(&client->dev, data->drdy_trig);
 		if (ret)
 			return ret;
 


