Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03361BE22A;
	Tue,  2 Jul 2024 17:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940380; cv=none; b=dQoVrzSr782qWLrBKOJeSB+iaXR/VyTyFOqvXHeBCSEQjZ5wi6YjFsObUC1C++hwAUKu3UQb+bEEyOYTlsm9q5QEKQ/uge6z4Kxt28ooL2EiGxZrKTxqx9MdDrEP41gI6nXmKlw5zM5Fheh9iPUNjc2cWdQHGMTGHcf+ZWx1X/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940380; c=relaxed/simple;
	bh=APuy7Mnyfbzcnw5aRi+qS/COaEeMueYfdMTYLidV5v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0sGRMuL7eEXlHamrMSNdo5QE6pIowp2vDvqlw/8EMzpxhgJDbUiLO8HUttjyMwxu2f/Ng/XUUzHTC9lZPo1Zh7ebMIftku7GAmDSA2uhNqFRXSa941FlmYvXBE1WkSL75MGOLaVgHOzmWMMhJXhk99Tu8Do1lAem1kK/1w3mmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxRL42eJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxRL42eJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA9CC4AF07;
	Tue,  2 Jul 2024 17:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940380;
	bh=APuy7Mnyfbzcnw5aRi+qS/COaEeMueYfdMTYLidV5v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxRL42eJP40TZleClD4HoJrKVHfxHoMEyj/YK0p66TVYpijP3CNkIvfQbZtyu78Mc
	 uv35jnoGT+PQC203UyU4t5aXipR3ucD0iDnxuCdaA9NMvYsO8/BVhXMHifuMTDZtxk
	 q9UvsJLeNMh9t4veEtEDVk6LpWBiBr6GLcuqcBtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Yang <hagisf@usp.br>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 137/222] iio: adc: ad7266: Fix variable checking bug
Date: Tue,  2 Jul 2024 19:02:55 +0200
Message-ID: <20240702170249.209332857@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Yang <hagisf@usp.br>

commit a2b86132955268b2a1703082fbc2d4832fc001b8 upstream.

The ret variable was not checked after iio_device_release_direct_mode(),
which could possibly cause errors

Fixes: c70df20e3159 ("iio: adc: ad7266: claim direct mode during sensor read")
Signed-off-by: Fernando Yang <hagisf@usp.br>
Link: https://lore.kernel.org/r/20240603180757.8560-1-hagisf@usp.br
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7266.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/ad7266.c
+++ b/drivers/iio/adc/ad7266.c
@@ -157,6 +157,8 @@ static int ad7266_read_raw(struct iio_de
 		ret = ad7266_read_single(st, val, chan->address);
 		iio_device_release_direct_mode(indio_dev);
 
+		if (ret < 0)
+			return ret;
 		*val = (*val >> 2) & 0xfff;
 		if (chan->scan_type.sign == 's')
 			*val = sign_extend32(*val,


