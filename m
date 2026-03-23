Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A5D3B0ACB;
	Mon, 23 Mar 2026 16:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282740; cv=none; b=Tl1MuZeHU8tg9SI9Bh6q/tglevjjZrkFpiq3Nre9kIB3GQFskK6V19N8A6eFvEYgRJzUTfZm8j49WKL/8ILBJuy5WPJziJJwHAgUkRAtrFnJAPNfKyU+uabw94IZirLF0uZoIY6JMcxElxgLShIQvfrR2n/f0f4Pq0Va04GvafE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282740; c=relaxed/simple;
	bh=vox3dZRh2KiFVSNsoMI1q7u8XP5igeH+zd+1/FArLGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+0tdBJjtI8eOl8snYdppp8+U4FE+1JTQ1kdFoS93USYDUiammvLjMcxwxx8JjU5GkT0C5g1Z5kT9VY1u1TuEScaANpTTgy2zq4mqYxONIiAKQATyHbauA1zeSzuaWaFJGVLKoOHFpsZskZ3jgPtiPM293sAKl1fXhWZBUaEO9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rf+wfFMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rf+wfFMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0308BC4CEF7;
	Mon, 23 Mar 2026 16:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282740;
	bh=vox3dZRh2KiFVSNsoMI1q7u8XP5igeH+zd+1/FArLGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rf+wfFMbwWXE2lV2MCfWrvG6CcsVGFtPyIugvzcO/brHk5u86dySfysZhOCFU6vAG
	 2M6G/ibkXywKsSSG/7MocrFOCjTLmNuqoa090jajbFMlvo5r9NS8iw4YXyVbFVs1r0
	 gT357QU0ec76wco3QkIHFFoj/ibYqK+nm6E6uijE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Tomasz Duszynski <tduszyns@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 267/481] iio: chemical: sps30_i2c: fix buffer size in sps30_i2c_read_meas()
Date: Mon, 23 Mar 2026 14:44:09 +0100
Message-ID: <20260323134531.645527826@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 216345f98cae7fcc84f49728c67478ac00321c87 upstream.

sizeof(num) evaluates to sizeof(size_t) (8 bytes on 64-bit) instead
of the intended __be32 element size (4 bytes). Use sizeof(*meas) to
correctly match the buffer element type.

Fixes: 8f3f13085278 ("iio: sps30: separate core and interface specific code")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Acked-by: Tomasz Duszynski <tduszyns@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/sps30_i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/sps30_i2c.c
+++ b/drivers/iio/chemical/sps30_i2c.c
@@ -171,7 +171,7 @@ static int sps30_i2c_read_meas(struct sp
 	if (!sps30_i2c_meas_ready(state))
 		return -ETIMEDOUT;
 
-	return sps30_i2c_command(state, SPS30_I2C_READ_MEAS, NULL, 0, meas, sizeof(num) * num);
+	return sps30_i2c_command(state, SPS30_I2C_READ_MEAS, NULL, 0, meas, sizeof(*meas) * num);
 }
 
 static int sps30_i2c_clean_fan(struct sps30_state *state)


