Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B856F4E36D1;
	Fri,  9 Oct 2026 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557041; cv=none; b=bKBuOkqxaI3rPS2hQhI8wRu7U+EsxamOhqpQBluUqGydTi/KiE51zFRlZ0n/JfTaWQQFcYingoJmtEQtpAXk1IIDhUjsklqKItr/NbJBS+aaRslUqaoTIl+eFgliKdzoydAg1m++/eYSrxjwsttNdSXh0EcsXHWQExVMUUD0Hks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557041; c=relaxed/simple;
	bh=TM5xshiVTC93eW+hdiNZEebyhpkXE7XN5z9kc51JF3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maO4Aj/RhxGqy0YVR6PU1DaSPoOcGY6rUj6iW3vjq3jqs5orpY5ORCKvxLyfjAzWpCVzzw8fvKMlF/bioGAVmAeZ/7Aq5wy4XKK1N1PqhvpD2WBeArmsPJgUqeajGpVVQXqg2PHC9Bq7RmrXpsHvHwNfJVFTkH3FkJEtwQZhd5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oyEycfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oyEycfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB221F00893;
	Fri,  9 Oct 2026 14:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557040;
	bh=KL/D8jSMv3SO5XiuZJExYLqsn6tPCVklFE1+PfAdRs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0oyEycfDL4j6srCgIxqP2jLgMM5lBHnRfdSYAcgjAprufKiq1o8rby4Lt0E5qIXqR
	 4+dxZkNwcPZ2Huz/RXeVH6c7hSItTZN0wP1GL1AuNJ03izv1SDeecNnWTmbHCFRN1Q
	 xEMMnUTSrJTnWpCkW4VxuxeFpf2tS/dwIk+3yVCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 337/403] iio: proximity: vl53l0x-i2c: claim direct mode for raw reads
Date: Fri,  9 Oct 2026 16:11:38 +0200
Message-ID: <20261009141000.133608949@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit e24328974a88aa8541e94e8bb8dfa2ade1b3c45d upstream.

vl53l0x_read_raw() starts a single-shot ranging measurement and reads
back the result. Once the triggered buffer is enabled the sensor runs in
continuous mode and its data-ready interrupt is routed to the trigger,
so a concurrent in_distance_raw read disturbs the streaming setup and
never gets its completion, returning -ETIMEDOUT.

The original submission claimed direct mode here, but it was dropped
during review because the driver had no buffer support at the time [1].
Continuous (buffered) mode was later added without restoring the
claim [2], reintroducing the conflict.

Reject direct reads while buffered capture is active by claiming direct
mode around the measurement, as the vl53l1x sibling already does.

Fixes: 762186c6e7b1 ("iio: proximity: vl53l0x-i2c: Added continuous mode support")
Link: https://lore.kernel.org/linux-iio/20180911160300.GA9212@himanshu-Vostro-3559/ [1]
Link: https://lore.kernel.org/linux-iio/20240909101508.263085-3-abhashkumarjha123@gmail.com/ [2]
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/vl53l0x-i2c.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/proximity/vl53l0x-i2c.c
+++ b/drivers/iio/proximity/vl53l0x-i2c.c
@@ -221,7 +221,10 @@ static int vl53l0x_read_raw(struct iio_d
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
+		if (!iio_device_claim_direct(indio_dev))
+			return -EBUSY;
 		ret = vl53l0x_read_proximity(data, chan, val);
+		iio_device_release_direct(indio_dev);
 		if (ret < 0)
 			return ret;
 


