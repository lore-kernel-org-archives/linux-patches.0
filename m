Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DC7403B1E;
	Sat, 12 Sep 2026 11:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213566; cv=none; b=BHQSRp0OiVk27QVxtHMcvKQzy/7o8Y8nOnIRZhA158IlROsqJ/8qE7/Q852Qv6RvaogOxBmUrHZOr3VW7Z+OXNd5a0WwTQ55Q/hRnMaDu6w1apJNtJRmjMaQTonStQc366Kgpye8111FV4Gr19Ac85fbJZiSrB/IegYC1J4bm8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213566; c=relaxed/simple;
	bh=VzIvXkRsOXzHes3kC5ct5aJA9R6XRlIkZmuteZccCS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRJ9mBBv1/5R1A53T2JgofUTU0wZYwVN1vz1eWijWs0/WhYXelfraaxwTA3yrpDP3WLWTj5a1veBhV8ul6ZtbB5AcUY6A6j3OSnafaUi1YoSWkkMjBUjqL6DTSGCZ8JnzELaSMganALO+uy/MYKRASjf+oVJeMneuboWw7CCDXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhG9EJJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhG9EJJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3691F000FF;
	Sat, 12 Sep 2026 11:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213565;
	bh=JyKDDq7oNc0Qkj0gx1c8SOYEwkOZwsDEng7uA1P9HuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhG9EJJYjoIAu+DF8FxRSFDMAiUJsU0ty+NrugzW1+5Wkp8AM9c6355g6BMMa/bhJ
	 3E16YiD0TlUMXxNTssoy5/HeQAND/JW64pkPYefQvyxDGLBfnsgV2vkj/8FDiGOcQ4
	 LTXDCNQnqmEs5j2GBpY8rKiNhgMz/5fHdb8fIgYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0149/1376] iio: srf04: fix pm_runtime handling on probe error path
Date: Sat, 12 Sep 2026 08:42:55 +0200
Message-ID: <20260912065610.873141976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

commit a40b2e7a17f26e38ab054363c9c7cde149588357 upstream.

When pm_runtime_set_active() fails during probe, the driver logs the
error and unregisters the IIO device, but then falls through and still
calls pm_runtime_enable() before returning the error.

Since probe returns an error, srf04_remove() is never called, so
runtime PM is left enabled without a matching pm_runtime_disable().
This leaks the enable and triggers an "Unbalanced pm_runtime_enable!"
warning on a subsequent bind of the device.

Return the error right after unregistering the IIO device so that
runtime PM is not enabled on the failure path.

Fixes: 2251157b335b ("iio: srf04: add power management feature")
Cc: stable@vger.kernel.org
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/srf04.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/proximity/srf04.c
+++ b/drivers/iio/proximity/srf04.c
@@ -335,6 +335,7 @@ static int srf04_probe(struct platform_d
 		if (ret) {
 			dev_err(data->dev, "pm_runtime_set_active: %d\n", ret);
 			iio_device_unregister(indio_dev);
+			return ret;
 		}
 
 		pm_runtime_enable(data->dev);


