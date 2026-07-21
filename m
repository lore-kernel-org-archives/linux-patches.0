Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF5947606D;
	Tue, 21 Jul 2026 21:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667701; cv=none; b=IAeDAz6868XJ0jKUVZxsa7NiS/sE8lmV8KXC04mXGslEjZ8a36PZ4ZcF/ZvVsI0dD+J2hIxHNG31k2oDgad/OUfch21TW4gyk6EkklbB16Ro+TVHbL6dE7N0/0I72yfoLr4nVTZaVK8qCPRl7st511HpASsY7lUPgw0tnO1Xt2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667701; c=relaxed/simple;
	bh=QTwBtUDl+I3jzycH6/n+d3mrRz/HWMk1JbqsGaRx4U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO9rtEYy78TKVVtZd+yMi+5zdXGUaHYwiupWn2LF5iKGAR2sMDzJll/Qe4OWty3RIzS0eQD0xYgbNawbi2GmgC9p77ykok7Pi2s7m5NAky37+Is92fAxbyUEBib7TRAkONXmdpEpWsBRol1oHMfMG58IMIq1IMXuH/O0cwElEms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/qcIhlO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/qcIhlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D561F000E9;
	Tue, 21 Jul 2026 21:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667700;
	bh=O5Hyr6Jg9b6uDhETet4r3lRQPo2+h3gFZYo7qF1NTlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/qcIhlOFKGheoIa4ZSixJM57KbQv4kpCKZIQuSremZUeAb0zkn/qAmtF+nVNYVSO
	 vTN5roVpviBaQxrCEPtefj+KXTD3BUrBm1VQzvbdXp9X0+ErA1diOvJVXBI3jxbIs/
	 ZeHoQLxBoUhTNy2y80Ow1y3CbJKyd9qPojJZjIXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1161/1266] iio: pressure: mpl115: fix runtime PM leak on read error
Date: Tue, 21 Jul 2026 17:26:38 +0200
Message-ID: <20260721152507.765548444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biren Pandya <birenpandya@gmail.com>

[ Upstream commit fbe67ff37a6fd855a6c097f84f3738bd13d0a898 ]

mpl115_read_raw() takes a runtime PM reference with pm_runtime_get_sync()
before reading the processed pressure or raw temperature, but on the read
error path it returns without calling pm_runtime_put_autosuspend(). Each
failed read therefore leaks a runtime PM reference and prevents the device
from autosuspending.

Drop the reference before checking the return value so both the success
and error paths are balanced.

Fixes: 0c3a333524a3 ("iio: pressure: mpl115: Implementing low power mode by shutdown gpio")
Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Assisted-by: Claude:claude-opus-4-8 coccinelle
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
[ moved pm_runtime_mark_last_busy() together with pm_runtime_put_autosuspend() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/mpl115.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/pressure/mpl115.c
+++ b/drivers/iio/pressure/mpl115.c
@@ -106,20 +106,20 @@ static int mpl115_read_raw(struct iio_de
 	case IIO_CHAN_INFO_PROCESSED:
 		pm_runtime_get_sync(data->dev);
 		ret = mpl115_comp_pressure(data, val, val2);
-		if (ret < 0)
-			return ret;
 		pm_runtime_mark_last_busy(data->dev);
 		pm_runtime_put_autosuspend(data->dev);
+		if (ret < 0)
+			return ret;
 
 		return IIO_VAL_INT_PLUS_MICRO;
 	case IIO_CHAN_INFO_RAW:
 		pm_runtime_get_sync(data->dev);
 		/* temperature -5.35 C / LSB, 472 LSB is 25 C */
 		ret = mpl115_read_temp(data);
-		if (ret < 0)
-			return ret;
 		pm_runtime_mark_last_busy(data->dev);
 		pm_runtime_put_autosuspend(data->dev);
+		if (ret < 0)
+			return ret;
 		*val = ret >> 6;
 
 		return IIO_VAL_INT;


