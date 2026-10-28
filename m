Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208909;
	b=128TiwP+qtOQSiAvcqx+kZoA0dRmb782Pl06AnhHQBHS0Hj/2Pd0vkXmZKLIr4bkA3Gw
	 G0VmsN9ZffaobLizmaMr11yYZVMxZ9J16av7V28BoLFQhns20jsdPBox9/HGc/p7wSCmk
	 zndrOPsVD5ovZ4V4Yc5ByRMOcmZTPQF+aPa0nXy9t4iVqLkb/r/oNuOgTn6xiDcT4SWDA
	 I6dI59vEaJnPuFjphEK9IFbzMISI25QhxbjjHH/jmXyGW9x4ePd6ghQYGZtIIMv+bGKgs
	 I+o02VU4DBfQeWnjfDQpeiC+1OSry7D3L75rsXsMsrE+Uf7NKqrx5aCo3N4rqBII3AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O57MZawdsEwyGakWbQ9H/Lsj4HmAoUo/RMuqlBPoZcA=;
	b=SQWwKbSxPA/DvoMLVX2Ti/jzomPUCu38hI6+dicLKqRWS4sR+tBRKvFnawy8mEZafyfe
	 cfYyfhotXhDEm9dDZliPIVMRvrIUdiFNU8GTfGlfb5Er2/Uc3+kwSZfREw3v3cqyTvhV+
	 /bySIMCUSzOCwg1wEUq+4FYTUuZNMp7A1HSQWazK/XTnmwnXnLbqrFPlg24uL5r7HwDiv
	 WzD/5sPCw/0PjyYrZ7CVgR5guG3rGVhqZG67ikIjY7J16+BL39eIEs1wmw8te5y0w5Lwf
	 4+5g9UxCd/MEBfV7TLpG9Nag+sMK21dKnKRPNgA6ItDqiDcwzA+wk1ykhBZ4t0zbNmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGLcyfGp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551F2606A31C;
	Wed, 28 Oct 2026 17:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGLcyfGp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3D51F01825;
	Wed, 28 Oct 2026 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208909;
	bh=O57MZawdsEwyGakWbQ9H/Lsj4HmAoUo/RMuqlBPoZcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGLcyfGp2OG5inMhTmw82hEnEejmJH4CIgvQd9/SuVsrKi3ctdnwhoZegk8KlR7uz
	 3G13vVdtRauXGW8NDXmiZWpgqkp5YIF2liUs0J3oxBC/vUbPrlACEQSr9uHnv7i82j
	 DLYGgoDTEK9qzl8wDck0bGYm2maf5EURc+wnsa5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 242/516] iio: proximity: pulsedlight: fix iio_device left registered on PM setup failure
Date: Wed, 28 Oct 2026 17:56:34 +0100
Message-ID: <20261028170009.233315633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -297,12 +297,14 @@ static int lidar_probe(struct i2c_client
 
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
 


