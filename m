Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BA626137F;
	Thu, 17 Apr 2025 18:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914679; cv=none; b=CrgpIQWRe3syNP5cK58AvjMCYJFCBe1KYbapj6t1CNwIcPZ9Fd6fJpv4q+kBgWTcTG5hUyaWGjsHK+5Ygr723HC3vvsPckUQW22ypLXnDE3KqcQk0Z8baIyL6yyF3jtiZFl8gfDfQJp6o+CI0xQysnKrz0NxxqS5xZYSBtBEYTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914679; c=relaxed/simple;
	bh=icEA0vu/1CNPOsz2cNw4TFmXLsgQ9OgGC/uaO97D1GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+n8UJGSDBzLLaSNT4Fmq5VIByoAiguguiqbGIszuMGqzX+rFw5L957HMDNhrf8/UHdkYoWb9dGX9SIjnwoP1bl32vxTxD0wXAOaQLyQOyGfvVVpyM9JLBAwZZOgIHizQlQYg8s02kROGF4Epd+og8xE6n0ZVwMQQTx93SNCkhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfW6ZBAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfW6ZBAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EDDC4CEE4;
	Thu, 17 Apr 2025 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914679;
	bh=icEA0vu/1CNPOsz2cNw4TFmXLsgQ9OgGC/uaO97D1GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfW6ZBAIfd4lGZwATk/Ub2Q2jafT/8H1aS9mzrZXGPPlWmUl7vkQkFH9CBZtP3qOr
	 bXOMWSqYNmGoWPMiQAwYjl5fhYz02a//35fKOnEK/hdxu8ZHUl2SmS3dSYdwtRWifL
	 xBvFG+bfimiXRdeKvN2UmTZc0ukVLIFPXZRB5vzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH 6.13 295/414] mfd: ene-kb3930: Fix a potential NULL pointer dereference
Date: Thu, 17 Apr 2025 19:50:53 +0200
Message-ID: <20250417175123.297527320@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

commit 4cdf1d2a816a93fa02f7b6b5492dc7f55af2a199 upstream.

The off_gpios could be NULL. Add missing check in the kb3930_probe().
This is similar to the issue fixed in commit b1ba8bcb2d1f
("backlight: hx8357: Fix potential NULL pointer dereference").

This was detected by our static analysis tool.

Cc: stable@vger.kernel.org
Fixes: ede6b2d1dfc0 ("mfd: ene-kb3930: Add driver for ENE KB3930 Embedded Controller")
Suggested-by: Lee Jones <lee@kernel.org>
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250224233736.1919739-1-chenyuan0y@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/ene-kb3930.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/ene-kb3930.c
+++ b/drivers/mfd/ene-kb3930.c
@@ -162,7 +162,7 @@ static int kb3930_probe(struct i2c_clien
 			devm_gpiod_get_array_optional(dev, "off", GPIOD_IN);
 		if (IS_ERR(ddata->off_gpios))
 			return PTR_ERR(ddata->off_gpios);
-		if (ddata->off_gpios->ndescs < 2) {
+		if (ddata->off_gpios && ddata->off_gpios->ndescs < 2) {
 			dev_err(dev, "invalid off-gpios property\n");
 			return -EINVAL;
 		}


