Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209F61AF0B0;
	Tue, 15 Oct 2024 13:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998376; cv=none; b=FeLmeo70aQdlj2Q6cumnaxeuiZappfq/Fp9welvwfNnxRfgqQs9HRg/1t2IwHz0clvqZGgKJslPdXUTl+DM1yg8Axqzp8nGZuBXX3wT8Ov5bdtyt04HL5XRn7NB4/BcAE8LJO1PKYeVh9GzSzd3G72pgHgYMWb0jfAB1F+CZlsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998376; c=relaxed/simple;
	bh=k0dOGt6o9e7kgYOXlF06VL+Vz+wdrZd+IlG6s0k4Png=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AocJG8xE4+6B0dentDB8yM3pYLkzkj4SxzpwfSLOTwJ5UX+6Uk3U+vTrRXIJ4mDKCvBvr8599ymYPy3daD6/nd/eAf80YMvflmffocdBalawwYcCGQ29oJmMhUIPbYul0h6Ev6nlErv15IDgFmbxS5jzixYifZ2hxb3W+Mdl3rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1U8mbMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1U8mbMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0554C4CEC6;
	Tue, 15 Oct 2024 13:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998376;
	bh=k0dOGt6o9e7kgYOXlF06VL+Vz+wdrZd+IlG6s0k4Png=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1U8mbMppiEBn8Few8KZeAW4zAbeVW6SPqHF3RN45nobFAVmPGrFAUQp1h4eGv+PE
	 z7cHaoUmcVP1yXXeee/3w/Oi3OvTsUCkIMAyuVKcPi1VPdfRpiPGGS4xtBDQ1lD9Xm
	 lvXLY3APqoS3cH5GNq2DDXiQrnpxdWa+D4rsDRjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 459/518] i2c: i801: Use a different adapter-name for IDF adapters
Date: Tue, 15 Oct 2024 14:46:03 +0200
Message-ID: <20241015123934.721759750@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 43457ada98c824f310adb7bd96bd5f2fcd9a3279 ]

On chipsets with a second 'Integrated Device Function' SMBus controller use
a different adapter-name for the second IDF adapter.

This allows platform glue code which is looking for the primary i801
adapter to manually instantiate i2c_clients on to differentiate
between the 2.

This allows such code to find the primary i801 adapter by name, without
needing to duplicate the PCI-ids to feature-flags mapping from i2c-i801.c.

Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 4baa9bce02b67..3d5ef84482b25 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1895,8 +1895,15 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	i801_add_tco(priv);
 
+	/*
+	 * adapter.name is used by platform code to find the main I801 adapter
+	 * to instantiante i2c_clients, do not change.
+	 */
 	snprintf(priv->adapter.name, sizeof(priv->adapter.name),
-		"SMBus I801 adapter at %04lx", priv->smba);
+		 "SMBus %s adapter at %04lx",
+		 (priv->features & FEATURE_IDF) ? "I801 IDF" : "I801",
+		 priv->smba);
+
 	err = i2c_add_adapter(&priv->adapter);
 	if (err) {
 		platform_device_unregister(priv->tco_pdev);
-- 
2.43.0



