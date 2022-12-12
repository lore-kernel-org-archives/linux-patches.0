Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456EB28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979B1C433EF;
	Mon, 12 Dec 2022 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852676;
	bh=a16utpOjsrL6ez7rzp76cnUx7fL7wLkHcVMwLoxXqwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzzuFqaA5iJuXBum5UzNoy4lixPFWhN86sgsNSJ4aQWAFpNsylWydfTSbCS98ZWZV
	 O5GkK52CdWyE+8D2d/hTNjeiA8/hD7nYJcxawj06M6IhxJh639wgPy/tPN8FY52mGF
	 /PIacIBxk8W3r+meJnSYX5HHlsdwad9QX0yjoGR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 130/157] gpio/rockchip: fix refcount leak in rockchip_gpiolib_register()
Date: Mon, 12 Dec 2022 14:17:58 +0100
Message-Id: <20221212130940.129172628@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 63ff545af73f759d1bd04198af8ed8577fb739fc ]

The node returned by of_get_parent() with refcount incremented,
of_node_put() needs be called when finish using it. So add it in the
end of of_pinctrl_get().

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index 9c976ad7208e..09cfb49ed998 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -621,6 +621,7 @@ static int rockchip_gpiolib_register(struct rockchip_pin_bank *bank)
 			return -ENODATA;
 
 		pctldev = of_pinctrl_get(pctlnp);
+		of_node_put(pctlnp);
 		if (!pctldev)
 			return -ENODEV;
 
-- 
2.35.1



