Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4054124DCF6;
	Mon, 13 Apr 2026 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097561; cv=none; b=s89/qmtp6iw3funMmB/Xj8lmILYyf+uh6h2JOhA1KP4Psvy0eF/+Buw5b4sE7XnFJ1keqnCYUTh3dNVSWK6ny3fWewRAkOmTA30X1roP9BZJmx86ckxZKIpCyFdaE4oUSPGDru2BibObEm8P+Gj6KmERb9M0baZAD7oosvOWpdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097561; c=relaxed/simple;
	bh=QR6+tJei5/Rg/CUEmkujhe0cBRjDhxAsYtKSQCeJhdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekC3rCyfOscKrQVVPVcUBTJa6kTKC4EP6o88pi4J8HnC9xS0YzhjEdcW000lSr9GiW0J8DtLc8ZTNS6KIHz+qPq/qju11qr7/WcYAdAscam2jfhJTj5AWQVRZy7C76YzXBsWD11D4XYzkEWUi8VFPSaUcYEiOtK4yQJrEimVS18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zf/zfHA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zf/zfHA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CF0C2BCAF;
	Mon, 13 Apr 2026 16:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097561;
	bh=QR6+tJei5/Rg/CUEmkujhe0cBRjDhxAsYtKSQCeJhdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zf/zfHA7GcYLWUq/EeCfRkjJ+AN2G94Ah+k/2Arw448PMpxNQmZmnWxBjqXgWkuA+
	 o69QZmZj/bFEZ61eGNIS9EWQLkvjEH5fNb6DlKxj0TQD9sbcopLUuR33HKjvx1/I4E
	 sD2vpo3rg62SZVDeO1e56UYA8YoWD+zbbaCo1Pi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Tomasz Duszynski <tduszyns@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 184/570] iio: chemical: sps30_i2c: fix buffer size in sps30_i2c_read_meas()
Date: Mon, 13 Apr 2026 17:55:15 +0200
Message-ID: <20260413155837.350164477@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


