Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED2E2D739D;
	Tue, 17 Mar 2026 17:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768373; cv=none; b=n4rhw3/Vbbn7vVH2K3sB2Dc6RP7CFLSwhW4j0StdElC0zeVzhOTtUeNw7jius4gktcCPrzDUGEWc90ZW1Qcf+oDiIl2ehpXYGv57s7gLjkXOwMx01ROecK6ypaY+TXzDvmdCA4x2rtFHrzmyX42Of0GCzuTchVkMpcIbK5P3iow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768373; c=relaxed/simple;
	bh=R3H/QbZoKf3SFCe/Huygzks2gBQqAho9/rGuQPxc6/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ol6ayqk4/t31KWH7XoTVSoP2825E4PAGgmpxnxeWtK7yXcBdByD16AZhWg2ei9yfgIaiOKxpwB/dmkDcbfBhpONcVAiLGz6MINvXTOW9ZPrWEMsXEdI8pHt2kIJEeNZL5DrHSlcM1YaslQei1jfqGGoYuRIatsARBVIWM/ba1Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FguOhAz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FguOhAz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D017C4CEF7;
	Tue, 17 Mar 2026 17:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768373;
	bh=R3H/QbZoKf3SFCe/Huygzks2gBQqAho9/rGuQPxc6/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FguOhAz7e7OngXSCYU8g7bVUkgWDgeUMzd6xOLsizwk3aIz4fXCpSRVY9Bl5Sq09G
	 q//B1XTe8YYZTG5Vzl+NCMu5fvc2wRh136AfA4FqMdblah6JAS3RFuVcfmMspnDhGI
	 ws48L0TPICNDqIBCuFAhNin8rLNmjaPFcxLT8Yes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Tomasz Duszynski <tduszyns@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 295/333] iio: chemical: sps30_i2c: fix buffer size in sps30_i2c_read_meas()
Date: Tue, 17 Mar 2026 17:35:24 +0100
Message-ID: <20260317163010.333258254@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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


