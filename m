Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3333AFAEC;
	Tue, 21 Jul 2026 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667167; cv=none; b=jSD4AQ0/baKh69HGaZ68VynYqvNH8S7dB7zqI/pxg4bBLDoXbmluBDT4h0rLIBeLMpWXZ437qDXmapid9/OqlCqgxSApwWPGzDwPfV0b5oCnTLxEvfhpkRI8bzlo9CVX8SK/8IbIAtyWpiPwy8OPe5uvQbnz6JqD/c0a1OvOx30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667167; c=relaxed/simple;
	bh=q5qeYh7yQYuVZetoOFuMwnGbz2f/0JBZtiTjORpYuEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0H7ikBgkLJL9iD61u9t9Leh2cJXT8KYS88Pux54ZTJ13VMXJH5HRym0O5wQLEqF5HS8bVy6ECqmZRQ+iAwo0AXAt8ozud22FBI2sBz+eynYiD97++YQ+LgJ3+6zDX2+SMM0DCGjS/ZZeWseTsninbPLzB8BgKTTn8XjNYWmYeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuCWaEkr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuCWaEkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ADC1F000E9;
	Tue, 21 Jul 2026 20:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667165;
	bh=Gf4BgzD/tWJh3mTaPdc7Nnb8n7QvjO1lvcT/UEp1zhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuCWaEkrRDkplcaOEl59xTdJlKb5RfyMZ/liGtLNcWUtBvAjiPx4g2Lex8M/NiK56
	 BcZzbAyiYSjZDGKxGcU/vlgYK5As1lS3G7vTLZUdI6NMdy4y7szdQxF5d6ya1De756
	 HQ32OjrpW1AoThHmzYnM7QdcQcnkE2+C7fSqoaek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 0957/1266] mfd: tps6586x: Fix OF node refcount
Date: Tue, 21 Jul 2026 17:23:14 +0200
Message-ID: <20260721152503.243444834@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 3001ed2b4e06da2276c42ace6551617065a5b1f9 upstream.

Platform devices created with platform_device_alloc() call
platform_device_release() when the last reference to the device's
kobject is dropped. This function calls of_node_put() unconditionally.
This works fine for devices created with platform_device_register_full()
but users of the split approach (platform_device_alloc() +
platform_device_add()) must bump the reference of the of_node they
assign manually. Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 62f6b0879304 ("tps6586x: Add device tree support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260521-pdev-fwnode-ref-v1-1-88c324a1b8d2@oss.qualcomm.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/tps6586x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -395,7 +395,7 @@ static int tps6586x_add_subdevs(struct t
 
 		pdev->dev.parent = tps6586x->dev;
 		pdev->dev.platform_data = subdev->platform_data;
-		pdev->dev.of_node = subdev->of_node;
+		pdev->dev.of_node = of_node_get(subdev->of_node);
 
 		ret = platform_device_add(pdev);
 		if (ret) {


