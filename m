Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245752EAD10;
	Fri,  9 Jan 2026 12:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960834; cv=none; b=pVIQUSnWbo0jtyx55BdFpddJUGMSTaFrkavdUSjwuxjbMll0qYjMBIG1XVs6o6rVfomrueWa7AqM0X6FYfU/h7H3XlHhQ7c9uY1RtxqH/Ptwi2fpznZ0U4/5pibtMHRW6LuhnyiU+y8eXdqVBd4ShUkbv4Wl/4xwUgSbU25FBCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960834; c=relaxed/simple;
	bh=BSTyfSfNsVXkJUaZFS9JY1fG5OehZhSgC16YIErXyu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MY2gyosaMuVLUTk9GUnRgm4KsPldQPok/4+y7V4t4US8NAskWG9FNtpl+umCxp5I1qzwjhEwxuJm+zMJ3GJGdRdF4zq5x1LsNt7ZyIVRq3qVOR33r30CFLgCnMVY1UAh5gvAncscJbTWshcGz4BkppgPVm8Ir5FcWAQDKk3YW6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvLiIJxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvLiIJxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F76C4CEF1;
	Fri,  9 Jan 2026 12:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960833;
	bh=BSTyfSfNsVXkJUaZFS9JY1fG5OehZhSgC16YIErXyu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvLiIJxSs81Eu4NsEjY6oXRa5/nRpIDLLR86Dexa3fpc81gAb7tfG3wUhR29oIdLD
	 daFDvedv0h7gBQOtL2c6micoSa4+V0Qdennnl2dgAA44CIUHNC9HagRzKEN0orKk35
	 XV+K51V1oTtQQE1geFX1uHKcPZ+aGQA6oKTD0hbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	olivier moysan <olivier.moysan@st.com>,
	Wen Yang <yellowriver2010@hotmail.com>,
	Johan Hovold <johan@kernel.org>,
	olivier moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 542/737] ASoC: stm32: sai: fix device leak on probe
Date: Fri,  9 Jan 2026 12:41:21 +0100
Message-ID: <20260109112154.383261898@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit e26ff429eaf10c4ef1bc3dabd9bf27eb54b7e1f4 upstream.

Make sure to drop the reference taken when looking up the sync provider
device and its driver data during DAI probe on probe failures and on
unbind.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: 7dd0d835582f ("ASoC: stm32: sai: simplify sync modes management")
Fixes: 1c3816a19487 ("ASoC: stm32: sai: add missing put_device()")
Cc: stable@vger.kernel.org	# 4.16: 1c3816a19487
Cc: olivier moysan <olivier.moysan@st.com>
Cc: Wen Yang <yellowriver2010@hotmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: olivier moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20251124104908.15754-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/stm/stm32_sai.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/stm/stm32_sai.c
+++ b/sound/soc/stm/stm32_sai.c
@@ -127,6 +127,7 @@ static int stm32_sai_set_sync(struct stm
 	}
 
 	sai_provider = platform_get_drvdata(pdev);
+	put_device(&pdev->dev);
 	if (!sai_provider) {
 		dev_err(&sai_client->pdev->dev,
 			"SAI sync provider data not found\n");
@@ -143,7 +144,6 @@ static int stm32_sai_set_sync(struct stm
 	ret = stm32_sai_sync_conf_provider(sai_provider, synco);
 
 error:
-	put_device(&pdev->dev);
 	of_node_put(np_provider);
 	return ret;
 }


