Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C924E80C2;
	Fri,  9 Oct 2026 14:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557024; cv=none; b=YKPitO25+Ykb00KFzThv+ecirfkrcTYJTi3wNwcChJL+kioYKMMEs3jtOXiW8JDVaOlLdlUqEEii8Od7pkslt84zhALffciE0Qw7Hk/Knk9CbPytvOdAlmSnbYCEnJglNAyL/HzXf3WSkBU8MItqH3Bww5iaMW11qAzC1kKqlt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557024; c=relaxed/simple;
	bh=VAlAVyB9Xmij8+yfmOjz61dW7eDDmbNm4lK4gJ6M92I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqWnEmBSmgc4X86Tt8YCwQFsRig8EQ2ZDxwk5pc/mKI5qRyFxzdpNWtph8MY5Cb7zc0L0ACuJ75vcERgFXYIyHl+wszSw3J56EWzG/GZ5XWxr89KLt/8AYv2wZ03famOJ+foe9bmWcVdAoat4Bb8e/YapUE6zFbjWPLpdeXyK7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfFJCP+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfFJCP+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A831F000FF;
	Fri,  9 Oct 2026 14:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557023;
	bh=gI6C//EKTMPcfc5yCLHkfpxgA2bde14XPJGlRoKSxoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfFJCP+TnZkrc5ohh9Aa+VeJQVNWYFwdK0Yr5vPnE9WXBByQhlNcchJc4qiqN3m0z
	 n5A1K3Rqg/XIlAb3oY2VXJpd7MQvPij6dWY5n6XOQWngGnKktqrmS6HezL9Us85bgt
	 Lz94O/mrY7H4HAAKD5FZqVJWHHV5kT5zrZF6K8Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 334/403] iio: proximity: pulsedlight: fix iio_device left registered on PM setup failure
Date: Fri,  9 Oct 2026 16:11:35 +0200
Message-ID: <20261009141000.060363651@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

commit 4daa9ca557b4b98ae1ad38a6d1deaa3e31eb8edf upstream.

pm_runtime_set_active() failing in probe() jumps to error_unreg_buffer,
which only calls iio_triggered_buffer_cleanup() -- it does not undo the
iio_device_register() that already succeeded a few lines above. probe()
then returns the error, the devm-managed indio_dev is freed, but the
iio core still has it registered: the sysfs/chardev nodes stay live and
point at freed memory.

Add an error_unreg_dev label that unregisters the iio device before
falling through to the existing buffer cleanup, mirroring the teardown
order already used in lidar_remove().

Fixes: 4ac4e086fd8c ("iio: pulsedlight-lidar-lite: add runtime PM")
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
+++ b/drivers/iio/proximity/pulsedlight-lidar-lite-v2.c
@@ -295,12 +295,14 @@ static int lidar_probe(struct i2c_client
 
 	ret = pm_runtime_set_active(&client->dev);
 	if (ret)
-		goto error_unreg_buffer;
+		goto error_unreg_dev;
 	pm_runtime_enable(&client->dev);
 	pm_runtime_idle(&client->dev);
 
 	return 0;
 
+error_unreg_dev:
+	iio_device_unregister(indio_dev);
 error_unreg_buffer:
 	iio_triggered_buffer_cleanup(indio_dev);
 


