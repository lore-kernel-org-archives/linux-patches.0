Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87E041836B;
	Fri,  7 Aug 2026 15:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115512; cv=none; b=ZBq0X7wumu2nucDkNzWlW+xJk55d2cfsD88RIBRnsI62qZXjSBvtPOfJ4Sn6DxMeqs0H0WQLvvnJ6ECrJiNIpHh02JuhCm0o/MBtRPqyjZ2blpVjxEs4ClmHz/Ju9MDB/MXXTExXcT84H7dtXiusMQ/Nn3d2AWgsZ3/+MJEkXg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115512; c=relaxed/simple;
	bh=WpjSm2fr+cJZ8y9A8rEiYDjh/E7ax1Xidv4icM3D96Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBAJrSPyeZp1OGvExryGGiYazdIS8xeVhJkRhjOi6oQSFlYrR7FRCOOkD5iF9m6sptaPBa8n620nY/ecd71ZWNnuj7mC3yCbU+ekP5+t3x8RmuUZr+RZfmU3k0u+e0JUhnWgxcdxLtJEfb6T1nZDd7RfA00dh47XKmjwdHGiiO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOz43HJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOz43HJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B1B1F000E9;
	Fri,  7 Aug 2026 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115508;
	bh=BC03s4Xht2b0sNjkEYjiO6Gf+40SQO7dogGrH28EU5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOz43HJvvgWJvnNLU23VOYaFfTvtbv8AwKDTUMGX6P3wqfUBKtFUNmW2Bac9AWJIw
	 gKfHd/CnFEUV2Now6Oiy4FpZw4fVC+759mNm+LKtpqfmehHiztNJZ8kvu+DeyFnaFZ
	 GXLirkYEMnjidjQPwqNVRMNkHimWgCD44NHO8n9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 301/396] can: kvaser_usb: kvaser_usb_hydra_get_busparams(): fix memory leak in kvaser_usb_hydra_get_busparams()
Date: Fri,  7 Aug 2026 16:37:41 +0200
Message-ID: <20260807143430.760483107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 941eaf9a6d3b33dea49f2c0a1da7546a03b6ff71 upstream.

The memory allocated for cmd is not freed after the call to
kvaser_usb_send_cmd() in both the normal and error paths.
Fix that by adding a kfree() immediately after the call.

Fixes: 39d3df6b0ea8 ("can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260722103906.108571-1-nihaal@cse.iitm.ac.in
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1626,6 +1626,7 @@ static int kvaser_usb_hydra_get_busparam
 	reinit_completion(&priv->get_busparams_comp);
 
 	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
+	kfree(cmd);
 	if (err)
 		return err;
 


