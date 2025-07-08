Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0F82E091E;
	Tue,  8 Jul 2025 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993861; cv=none; b=DzjkYb8FVpYGQwam6MrLyU0oPYT1mWG3N8SIAx6HqLvdZvzjMUCbHa9hm3HNQgwi/k8kNXrdvp8utKGMcVdvo+MO5R7+n8pBMqnyvbA+iMkM2v2Jac6Lc0QpkVx3BXU8lIYUNW6OsenuQ+2ZiCNBicVLO0GUaON4m0eAjuYNZEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993861; c=relaxed/simple;
	bh=KzEX0cI4uE0oll/Sks0GnQHdhyENMugYeeggK4SMiTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+lK2mDCyVtEcqCN8LBaAdS4/RIZuo98DtMUdkTpBPtb4hM2/uDg+PWIAiep1E472VluNWLos6ZP1PPhsC4gIlDDhn2WsFOM9G31GJoNGx+avcWlt79XYP5lzB7MVOOmCsXK+/0xe19U72KlPUhSx+orJ6wd/YfOjaTVnlFRS6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQOVLDnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQOVLDnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65B9C4CEF5;
	Tue,  8 Jul 2025 16:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993861;
	bh=KzEX0cI4uE0oll/Sks0GnQHdhyENMugYeeggK4SMiTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQOVLDnciIy4zTGqs4QQyM9RyW3gtcK5/U3hh4vkEP136MsYNrv1FnuaWvFgO07p8
	 xCBMdBJoxbBcz9/i2cxaWCRhf7xP6/yPorOPkddqh1jHrNZ8Dsa3YnSnQYBITuy9BU
	 +a7RbPz5afvHZQeYJ9wjbO1lknO2s7COxEUO4by0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/160] mfd: max14577: Fix wakeup source leaks on device unbind
Date: Tue,  8 Jul 2025 18:20:42 +0200
Message-ID: <20250708162231.658689466@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit d905d06e64b0eb3da43af6186c132f5282197998 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250406-mfd-device-wakekup-leak-v1-3-318e14bdba0a@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/max14577.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index be185e9d5f16b..c9e56145b08bd 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -467,6 +467,7 @@ static int max14577_i2c_remove(struct i2c_client *i2c)
 {
 	struct max14577 *max14577 = i2c_get_clientdata(i2c);
 
+	device_init_wakeup(max14577->dev, false);
 	mfd_remove_devices(max14577->dev);
 	regmap_del_irq_chip(max14577->irq, max14577->irq_data);
 	if (max14577->dev_type == MAXIM_DEVICE_TYPE_MAX77836)
-- 
2.39.5



