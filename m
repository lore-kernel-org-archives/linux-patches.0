Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03B7405F7;
	Tue, 26 Aug 2025 14:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218562; cv=none; b=bVWpZn0xcLP40LTRLYTPT0Xuok22UCj49+46GS8RKw5rkjHGXtUoobdOciRF5SEbGlCtsOF8/pewaGGLN6x2P/igeqX2E9DTqoGd0T9BZgzZFvYtrunghsZLMTJgMHSPYSQV/mA/873bSqfM1f59Vt/qXkUgs7G6NBQf0LN69h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218562; c=relaxed/simple;
	bh=a/iilQZQHUxo24Vj78b/8p5VNM9l9VQrEugQGUZHoLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6PNwftPYnpK7Wx3F7u56jio/0AOeeUn99HbBjx1IyhYatRCP89fOBIHg8QjkkAJqukkUPnNw238boOLdz6u+xHhgLYe/yLCWsYPil2/NbXOFjkB2DsqojmoAuI1Al3sCwHMCBxvTLxLZ29ibFB0DuBkOlMfy74O5zvMTpNHQto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtpTvjM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtpTvjM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3966AC4CEF1;
	Tue, 26 Aug 2025 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218559;
	bh=a/iilQZQHUxo24Vj78b/8p5VNM9l9VQrEugQGUZHoLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtpTvjM8ARRkaCyOv7nsfLV7INgeCLy5k8SddVI/PFJRdE/fqA0LhvQlcONMawf4A
	 1kUwcuNJaMLvhmbpZ90zdXoHS5fjhk8D/hQEHPFlHpc5LSVgeaXYc9VPUDla0ipf+q
	 PioLL5jzYQAnlMk2SIeVtm9zv0xEzxiZ+fqI8MJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Shubham Kulkarni <skulkarni@mvista.com>
Subject: [PATCH 5.4 045/403] power: supply: bq24190_charger: Fix runtime PM imbalance on error
Date: Tue, 26 Aug 2025 13:06:11 +0200
Message-ID: <20250826110907.075731305@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 1a37a039711610dd53ec03d8cab9e81875338225 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 47c29d692129 ("power: supply: bq24190: Fix use after free bug in bq24190_remove due to race condition")
Signed-off-by: Shubham Kulkarni <skulkarni@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq24190_charger.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -484,8 +484,10 @@ static ssize_t bq24190_sysfs_store(struc
 		return ret;
 
 	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(bdi->dev);
 		return ret;
+	}
 
 	ret = bq24190_write_mask(bdi, info->reg, info->mask, info->shift, v);
 	if (ret)


