Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217375;
	b=lExbpxeIFzSsIqyYMKVXJDxMAu9QovThom1mAkIiyjQ+zUjwC7owykpVjM/ymaimNpoX
	 WLEZztlmVOzMftssG7vfsdE1YL705HWlg1zCwARaRNWzUA6oDow3+JbAjG7lDIZVxAhGW
	 WMgtDRf7gsvLG1hH8tYUCoNyTG36AzFfjFSrsJeHvFOVokUOBUPI8z28vPsvmLAspw8Vo
	 ILwv4DOC2blq7ESgfD7bFMkOBmSe1fiagjf2V/U+7wVeG13hR6zBPAesqHTToJF8PnBQG
	 pbKtdkGXVjjStRaY741Qom+qzJ8sGBbo9owwmDYXIrB/2heInEdma3nGRiJt6G/O24w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rGa2fWpiDq9rV/4zEgeOgE5FqkYz6nD/CGCGBQAhPe8=;
	b=Z06vX5Yw7uWEoXLJ2lv6kkiUo7N5ZrKxG6ht+edvfeqVGQ+SZF6NlSgkSK0ruRTovC8J
	 6yGxJNS5Tgh4Knxshz6tkDi71WdruV/yjBwwbV+7HY6IoamSWprJBYN/9sr/CBbtlp8cm
	 M2dMo5xS96ITnp8gowKKd0cW66mjc1mHfW46a2UKFcsJYpeJj+FLRgqQvFD3Ui8ifHxf9
	 nPVv1aptQ2ushcsD/YDJ6e4d7a23/8uQ2ir0opOFqhlR9HrbiLHFpdRyZvtg7N/AYU8kL
	 qG+z16cSqp9a8ibrtGAbNf08VVvBe0eP2fJ7YL8/pZN61XqeFSkdehFXXuXVVpIZKBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeMUnKsk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F15E606A329;
	Wed, 28 Oct 2026 19:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeMUnKsk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622C41F031E2;
	Wed, 28 Oct 2026 19:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217374;
	bh=rGa2fWpiDq9rV/4zEgeOgE5FqkYz6nD/CGCGBQAhPe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zeMUnKskWtXuisNKAkJJKz/7lPGQLk5p5fSSIbbuEdLhzqgYS176kzCEs9G/gX1Y7
	 1Q524DhP03oVDvMwxwmCKf14s3Kh+TNmdOYY6rSSr5xT/G9oHe8gF8l9brxPcbMX9H
	 2tHbE6rynl2qDKrSBZn1ioCfSlm7EBMxcS+b6Y5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1838/1887] firmware: arm_scmi: Free transport channel on IDR failure
Date: Wed, 28 Oct 2026 18:05:34 +0100
Message-ID: <20261028170541.273393583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit d72e7e5f24687c0490aabf317653caffe0447aeb ]

If transport channel setup succeeds but the following IDR insertion fails,
the error path destroys the transport device and frees the channel info
without invoking the transport cleanup callback.

Call chan_free() before destroying the device so transport specific
resources such as IRQs, mailbox channels and mapped shared memory are
released consistently with the normal teardown path.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-5-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 75dc215f1ec9d..f0a9a1bfdf958 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2135,6 +2135,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 			"unable to allocate SCMI idr slot err %d\n", ret);
 		/* Destroy channel and device only if created by this call. */
 		if (tdev) {
+			info->desc->ops->chan_free(prot_id, cinfo, idr);
 			of_node_put(of_node);
 			scmi_device_destroy(info->dev, prot_id, name);
 			devm_kfree(info->dev, cinfo);
-- 
2.53.0



