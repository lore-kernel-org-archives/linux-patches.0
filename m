Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064022;
	b=NPe+QaxXJaOD4AkGRwvI7u6Oe2bjtQrpRNdfZtWSj1t2FXzVFYMkewswdACX3jeHPcwI
	 PS39yo7gEE1G9xsooka6AIaNX8IabBgkl8Uqz3UIHs7bHJQkHrXLdl5XFV5cWb4Op/6/R
	 UFIpRlNpWOaLH2rbqNqGWvfpVpR8jZgZlWt4CDwdDg4hqUE35uQO06d4Mq2At6QZp3bZn
	 pswb6S0kjO0m3iKPcHhUHczVBigrEuy/VMJoEFHdIBo5sPBov8G/h7mjP0aj9QwZBbhy/
	 cdNmKg52VnXGD2kcJNBwX/S06qHkik9Fgc6DffT5W47SCnVdLSC/9Q/5HKAyY4R3FOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t89zsWHqqyAvg7tb4qPG75EYPQvze/Ce51PdbQMZpig=;
	b=lDA3q92OnzmJD7WAQWR7cYScD5tE55Y0ef6nN7cYDnLdR0nX4KDYKTt2dARZisMOcm/D
	 XIXPqOJHfzFpvqqeKh9EYrZFPcEIN0Z5IVpn/8Hd6ObKaR7rmjojaG+4LwIZgfr2h9o1V
	 8/B3Gx4nYvaVx/VksTRgVwn1CZ8QaYf7odG0REquNxfAGnMJrUjr3KLVQ88PzysZjwPc9
	 Nfpp1ApvCEy+fYG5b8er5rfCZEChyhtDmYg9J5u5qnGnUehBxRloMS97NGMZ6OHlJc2nB
	 WrLK0oVy2iotjUa5AsBYkVs8g5/7kjX6ilxALjikZ0Mkt49ukOF7ueBepbctcUMPtBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQTGY8io;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819496082BED;
	Sat,  7 Nov 2026 15:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YQTGY8io
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346E01F008A1;
	Sat,  7 Nov 2026 15:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064022;
	bh=t89zsWHqqyAvg7tb4qPG75EYPQvze/Ce51PdbQMZpig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YQTGY8iowtShqunAx28JfodAia4AQYYiOnaGO7oL4hZVi3IIWh1F3WrGfk/jvO7F/
	 6eJiWRfP0PrZmWHxsG4gxRbAielDu6s2I/HN0N9dCnZ3/dPUCXWqj8w0G3OtwUg3/I
	 3qjorg3rDtAUhIk1UtdgpMigw7Y3wveRzOWMcNAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0198/1257] regulator: core: Fix c_rdev reference leak in regulator_resolve_coupling()
Date: Sat,  7 Nov 2026 08:41:34 -0500
Message-ID: <20261107134945.032051377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit c41b69e9f76fd9632662714c1d37860468e8d773 ]

of_parse_coupled_regulator() returns the coupled regulator with its
device reference incremented, but regulator_resolve_coupling() returns
without dropping it when the coupled regulator belongs to a different
coupler, leaking the reference.

Fixes: d8ca7d184b33 ("regulator: core: Introduce API for regulators coupling customization")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917142535.2156720-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6a4008f387b5e..e813aeaa64ef5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5861,6 +5861,7 @@ static void regulator_resolve_coupling(struct regulator_dev *rdev)
 		if (c_rdev->coupling_desc.coupler != coupler) {
 			rdev_err(rdev, "coupler mismatch with %s\n",
 				 rdev_get_name(c_rdev));
+			put_device(&c_rdev->dev);
 			return;
 		}
 
-- 
2.53.0



