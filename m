Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8B73ACF16;
	Wed,  8 Apr 2026 18:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673248; cv=none; b=lhJthGIwa2UEnhrrgE5Fb9b5h/9d+9qX6tN35TOhXlt61vENQjoLZaAFHZyJWlXSH3PviTZCGc033QMLForGHInxca+PxNILSRF730RIxsFUU8XMj/A1uKUwcg7sZ/KZBjpRBDZe9Kt4iJzsgk5c1w+3jyVCEGp7/blra/FY3T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673248; c=relaxed/simple;
	bh=Gvmp4vxoS7jnbX9dxUj+Ej6+8LgjNVXeWRQIt4ifYcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVaForUu/dJCUZBZPiyDg83Okwsl8iTmq54VO3MVuTBapDExG0QiVWB5BZJcxluOYVjAvbi1uq60Se3uoeX93QOxquAg74YtP8AnbT8jq+eZLrRW1MPWKr5HH/JDdlXa7lKB+MAl8pTR3v1mSLwrsZTkmGLl5WERSpXJlBSMVZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqQ4nx8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqQ4nx8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBB5C2BCB1;
	Wed,  8 Apr 2026 18:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673248;
	bh=Gvmp4vxoS7jnbX9dxUj+Ej6+8LgjNVXeWRQIt4ifYcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqQ4nx8OSCU1rb5o81NLnNOM94BcncMJxr8723LMyoZM8XThqUcR+b6Xq7Zh9D4zj
	 rvaC/NLMJo1HzJcuTL6WloV6xk4/am2oReoh80vEDWgYY2PTmAaN+lVbP/1c5yg7xI
	 kUlYs3hDoa4z2ivbS/YDvSXKv6LDCdgBGyWXCUBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 159/277] iio: adc: ti-ads1119: Reinit completion before wait_for_completion_timeout()
Date: Wed,  8 Apr 2026 20:02:24 +0200
Message-ID: <20260408175939.807761475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit 2f168094177f8553a36046afce139001801ca917 upstream.

The completion is not reinit before wait_for_completion_timeout(),
so wait_for_completion_timeout() will return immediately after
the first successful completion.

Fixes: a9306887eba4 ("iio: adc: ti-ads1119: Add driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1119.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/adc/ti-ads1119.c
+++ b/drivers/iio/adc/ti-ads1119.c
@@ -280,6 +280,9 @@ static int ads1119_single_conversion(str
 	if (ret)
 		goto pdown;
 
+	if (st->client->irq)
+		reinit_completion(&st->completion);
+
 	ret = i2c_smbus_write_byte(st->client, ADS1119_CMD_START_SYNC);
 	if (ret)
 		goto pdown;


