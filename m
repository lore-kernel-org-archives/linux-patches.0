Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437D955896;
	Mon, 14 Oct 2024 15:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918585; cv=none; b=cUxzFH5VMPRZHwN0h5bbdIgZ3foQxc2QhG7k4TQUtX04PMyZiB4e5LCHxl58b0A3zCsooLKclNvfQOLcVEB1moBJg75PsnCv49sw93ceqxQyNWRIXsw0anE/GawfuqSpdN2PwZzadbBcQvKtEfr6aFnJSq9OuV4WqWcrSDcMsCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918585; c=relaxed/simple;
	bh=G/ODsql+BsGtRi8UeWV93wq9gQIAnQj4FyJqKVjlAkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHWYbJ9PTG6p7QSaS0ebr93vfgfz+iydGob8w4uyfgKiEVXMaXRsnVH0yta3IBXmN41J4cdwOkHuEV860Hr10uZgmVWtu41WjsA/uFsr+YlyQ7tst4N4BuUjBUOLP2QfyRVybhVnWBWMGRGTfTLe9emDgWxO/HJjbqMhHrqqKjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8uIoooW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8uIoooW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D86C4CEC3;
	Mon, 14 Oct 2024 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918584;
	bh=G/ODsql+BsGtRi8UeWV93wq9gQIAnQj4FyJqKVjlAkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8uIoooWgmWVyTGcrjDhwYhGLJYxMMTnwOMZXqK2CT/9LNjTapjf8ttXUWessnlGI
	 kZtHK9KN4Fr74kZTIc/uY8pQ62Z35tL3VBesXjatcijqvuHOCfHb33hBHmRpfdT0Ql
	 O3yxbwc9ltlEWKUmrj2rpoYn8ShCSTtjv9AB4WZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 332/798] hwrng: bcm2835 - Add missing clk_disable_unprepare in bcm2835_rng_init
Date: Mon, 14 Oct 2024 16:14:46 +0200
Message-ID: <20241014141230.994356500@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit d57e2f7cffd57fe2800332dec768ec1b67a4159f upstream.

Add the missing clk_disable_unprepare() before return in
bcm2835_rng_init().

Fixes: e5f9f41d5e62 ("hwrng: bcm2835 - add reset support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/bcm2835-rng.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -95,8 +95,10 @@ static int bcm2835_rng_init(struct hwrng
 		return ret;
 
 	ret = reset_control_reset(priv->reset);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(priv->clk);
 		return ret;
+	}
 
 	if (priv->mask_interrupts) {
 		/* mask the interrupt */


