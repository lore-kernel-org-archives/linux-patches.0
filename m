Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062139;
	b=zO9++Kbfbqtuu0mrjEgaMl2YIuA3rGXr2ZjSoSuuQyPlLDqXUeRKjaxWEkq/TnGzS65d
	 W8R0J05i30gm/2YQ1A3NMvI3020V5IMe2HUhpKYjVhW586ddfZRN8eScfmDGuxguHHnoS
	 Hfw4i4PjHL8mN38SU0aMOiBdhm2ykVoD8VKMNCyTmdFe2e/SEWCa4JDS+r7KJUjn2eTPj
	 U34iRfXgh51Smfaws2mf/UhyPrab/uukklxXIfDXP82ACtZBImOKHl/qUakS9pDLd9drb
	 DqSdcjHoiLYf/0M2SISr5Yfz/VQtdt/n1WVC8QZufbyh299l2h60kn8mfxe9z0U2Vuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jitSmH4wXqrSdNzeMo6bpaUABAC0YwWZLZOz2MaQyxU=;
	b=suaxwf8B3FyoxQQVSqDrxq3rYhO3VF3stIC3hAIScCffN150OlWnC1di38rzS6op7JE4
	 TcbhhottILepvC8ddfwx8cSrgb4HdEm81KdQ1Qg3ld4/CpJNxzJTOMnoIbRtiJbgXzNfh
	 jMjMZvOoMjW/jDQf7qIAqTOUuweFQAsfDWFz3Bz+3cIFVYeo+oykcrHrFDbKs7VM2ADlS
	 pNdULfl/KdTKpScYeCAzj59FxTNe5PRJmVBlanHJrONj4Rj8j+xBCjsXmzaMqO36lzbHu
	 x4N97QGg9iwTUtyNReCLxNfDxgWKp/iq4NGNi4xwjaw4lg20gKrpgXrnftv+6twt9BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BwvTUDev;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1D4606A653;
	Sat,  7 Nov 2026 14:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BwvTUDev
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF501F008A1;
	Sat,  7 Nov 2026 14:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062138;
	bh=jitSmH4wXqrSdNzeMo6bpaUABAC0YwWZLZOz2MaQyxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwvTUDevuIBGPA671Hihd5h6WkRRA9cGgLKRy8x7Bv2YYn8WicI5RMYKg4sXQ1hD2
	 JnYo1/ORRdRivab9F4HXtMF3cyaqfd0p0ZFOpqvhKv0grSX3xF2YuYyzIx90bsXJXT
	 EDXwL1dr0TTO0Vjl5NQBPb7Vr5Yx8dUQzbXMUxso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hal Feng <hal.feng@starfivetech.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1104/1536] clk: starfive: jh7110-isp: fix refcount leak in jh7110_ispcrg_probe()
Date: Sat,  7 Nov 2026 08:52:00 -0500
Message-ID: <20261107135028.710616922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 1c4f9480473917558908c083d1293b4ebb3d50c5 ]

In jh7110_ispcrg_probe(), the error path for pm_runtime_get_sync()
failure directly returns without releasing the runtime PM reference
count. The call to __pm_runtime_resume() increments the usage count
unconditionally before attempting to resume, and does not decrement it
on failure. Thus the leaked reference makes it impossible to suspend
the device later.

All other error paths correctly jump to err_exit and call
pm_runtime_put_sync(). Fix this by replacing pm_runtime_get_sync()
with pm_runtime_resume_and_get(), which properly balances the
reference count on error.

Cc: stable@vger.kernel.org
Fixes: 81279f5d0812 ("clk: starfive: Add StarFive JH7110 Image-Signal-Process clock driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Hal Feng <hal.feng@starfivetech.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/starfive/clk-starfive-jh7110-isp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/starfive/clk-starfive-jh7110-isp.c b/drivers/clk/starfive/clk-starfive-jh7110-isp.c
index 8c4c3a958a9f4..ace2c2eeac90a 100644
--- a/drivers/clk/starfive/clk-starfive-jh7110-isp.c
+++ b/drivers/clk/starfive/clk-starfive-jh7110-isp.c
@@ -140,7 +140,7 @@ static int jh7110_ispcrg_probe(struct platform_device *pdev)
 
 	/* enable power domain and clocks */
 	pm_runtime_enable(priv->dev);
-	ret = pm_runtime_get_sync(priv->dev);
+	ret = pm_runtime_resume_and_get(priv->dev);
 	if (ret < 0)
 		return dev_err_probe(priv->dev, ret, "failed to turn on power\n");
 
-- 
2.53.0



