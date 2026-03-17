Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F68280A21;
	Tue, 17 Mar 2026 17:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768409; cv=none; b=AZs0LxZybySkekx/75aCdUETGJWMqBtV9yyPNNhpiayBqW03+x/1wGsEpyLU7VUatykq6aoLEzAqHSG24KQF7UegrqvYisotnmh9XuY71WtMu31eJUy/qmBXiQBDyBMw4Ch7CuJbXtl7A15rXgV0TgCMJuUlsDQjKwT+40p/6A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768409; c=relaxed/simple;
	bh=EtNhiCMB6BeZFiX5peJ2mdkZukb6f8+00ZQpaXeLYFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGzVrloWwp2AtwmdUU9lVhlw6dhNEpxYKgnRWyixEgbeEh0MD5BMlEOPCJPO8l6pXLEzldYVE2iOrwCoqqL2Fid/N7fIR9iJi31u9ppDmet/qkkfgNDU2BIkyMzdyiMlo7jLz0yKkSrvFrh4aPZdOQVK/x2BFf2AiOPMgRH+Y4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zubsi6ZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zubsi6ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEB2C4CEF7;
	Tue, 17 Mar 2026 17:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768408;
	bh=EtNhiCMB6BeZFiX5peJ2mdkZukb6f8+00ZQpaXeLYFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zubsi6ZBNo+Zpb+JNUS44B7XYchhaTt5EFuMtOn3LUI/qYQ+P2Avdx+apEjUnYVom
	 ByToZVQoprBHjEufGQAJWAKgsZK3VkTKdiJCrqaehmWxMGGWVGIYisf/Pq1ahPQSG8
	 l4gSUbORVmnpP/YCNyR6dakN3Jiq2pSdxOuafmqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 302/333] iio: gyro: mpu3050-i2c: fix pm_runtime error handling
Date: Tue, 17 Mar 2026 17:35:31 +0100
Message-ID: <20260317163010.590904220@linuxfoundation.org>
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

commit 91f950b4cbb1aa9ea4eb3999f1463e8044b717fb upstream.

The return value of pm_runtime_get_sync() is not checked, and the
function always returns success. This allows I2C mux operations to
proceed even when the device fails to resume.

Use pm_runtime_resume_and_get() and propagate its return value to
properly handle resume failures.

Fixes: 3904b28efb2c ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-i2c.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/gyro/mpu3050-i2c.c
+++ b/drivers/iio/gyro/mpu3050-i2c.c
@@ -19,8 +19,7 @@ static int mpu3050_i2c_bypass_select(str
 	struct mpu3050 *mpu3050 = i2c_mux_priv(mux);
 
 	/* Just power up the device, that is all that is needed */
-	pm_runtime_get_sync(mpu3050->dev);
-	return 0;
+	return pm_runtime_resume_and_get(mpu3050->dev);
 }
 
 static int mpu3050_i2c_bypass_deselect(struct i2c_mux_core *mux, u32 chan_id)


