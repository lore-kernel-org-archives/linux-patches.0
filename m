Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E033F4E36C0;
	Tue, 13 Oct 2026 12:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895365; cv=none; b=Nec1Y3wIAmztZ2mTd4UDdDXWr2bfPRT5ub3+tS3zkSYNTDY7+kkghKlRtg+telG1HD0R5iWCV0YFiIXIFFb0rFpw+9NhvnIZl06s3B0BNPcS0cums8j6nKu+PdYE7VDF/b3SU9lNVNkaDvO6UOldhGYsUwZMGmx3w+i2FNXCvQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895365; c=relaxed/simple;
	bh=2MuKHI5fiut5JMDMqSoql+OkmGQmFbEMXSxDOU+2q90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrcixM0SioOAVvr1KWaAiMn7H4S9ZTMsiW4VV4ElfeTNYhzyhogBBYOjmjKGp1Ou/x6ZgGqpe5fI13d2UslL6xaACGXUxscJCQNCBliEfeR9Z8A26qLNhURXQA584Z6hi6Lkh/n8y/EJFDqjyAGsYfsmUSYjtJT9lfOmBuvuJLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZNc7y+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZNc7y+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0ED1F000FF;
	Tue, 13 Oct 2026 12:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895364;
	bh=Fc/L/OjjQZqQplwCbFB4LRHGXSU6Qk+58H80VLNC/80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZNc7y+OBcDIhFy49bJvK3IE8e9Zer4I4+XcXaFm6o5XGTBQWC82UtFGjKtGJ4xAy
	 5+9Hc0QVHJ1Tnlel/QmNHsYmR8IYqnIy0NwEIDgyfCEL2XfTl1BFnKIDJUV92tF/4B
	 1sIeVYUjOMeKkjftArsTukYPl9j3ixbIXtbZsag4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 250/497] iio: proximity: pulsedlight: fix iio_device left registered on PM setup failure
Date: Tue, 13 Oct 2026 13:36:57 +0200
Message-ID: <20261013112913.824896363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -298,12 +298,14 @@ static int lidar_probe(struct i2c_client
 
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
 


