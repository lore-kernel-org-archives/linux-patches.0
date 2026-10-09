Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C334CCDC0;
	Fri,  9 Oct 2026 14:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556824; cv=none; b=eFLbxdd5RLxffrrnIITUL9ZEws82eWAECdBK6I61FFzxi09JQZqJRNe3+e24BtZRZNlyL0VJVIrs8Mi6cVbN0c9A000BJJimcHqnBLbN+8wf205WvV/sP7AxNsf+TrGYDwoWD9DqmO2O3Bxfc6F8t1vdDnsY7HvOn4K+qjOZSEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556824; c=relaxed/simple;
	bh=e5Fkm9ZZ0MdaJW/pNGcpKEd6cRiRmGjGVbF+KjPuOho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILIhsmvZ8rkZ96WPkxnt4pnoSVEGBnN2GYSDvXff0J0uwqxa4Pf/js/WWTZqX99sGmFLu5hUZx1/JqGzBFFNQCdY9deuUCImTeQaxbSzT/4gj/BPfqbOPbRMoG97Y+HOlXJCjKSGMUHTKntvcddeqnZ/tcuiwQcKpkE0xjH5hlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2j+3GIM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2j+3GIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB001F000FF;
	Fri,  9 Oct 2026 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556823;
	bh=Et7Fv5slkHEwBdwusgzzrWPJxACTrkc9FAxqRZQr398=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2j+3GIMUxtWplW0VGRZJqeygNYEju4viPKYRkFiA5nkez4XUgRcTJU7XQ9vqK+du
	 9Uf+/ZuFptWOebh0Xk/VM0Dp149PDucdJePlNF4isJ48QT2HarGlhsQ21hi23OG4mi
	 vGbBC0NNGGgwJipVcRCdVgcUFSlLIgi4RHh+S3q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 299/403] iio: accel: kxcjk-1013: reject duplicate event disable
Date: Fri,  9 Oct 2026 16:11:00 +0200
Message-ID: <20261009140959.199612082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit dd30c10ff60d2b30386c23bb7c61cc97f2385c97 upstream.

The IIO core does not filter duplicate writes to the event enable
attribute. kxcjk1013_write_event_config() already ignores repeated
enable requests, but a repeated disable request still calls
kxcjk1013_set_power_state(data, false), dropping a runtime PM reference
that was not acquired for this request. This can underflow the runtime
PM usage count and trigger a "Runtime PM usage count underflow" warning.

Return early when the requested state already matches ev_enable_state.

Fixes: b4b491c0832e ("iio: accel: kxcjk-1013: Support thresholds")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kxcjk-1013.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1031,7 +1031,7 @@ static int kxcjk1013_write_event_config(
 	struct kxcjk1013_data *data = iio_priv(indio_dev);
 	int ret;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->mutex);


