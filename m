Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F273BF302;
	Thu, 15 Jan 2026 17:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498261; cv=none; b=CdEaNa9BVX4wQbO6ZIkfvmeLYRJH7dVFRG5OYVw2sTBFk9lTZK8XC6pnHR9l/UQJAV7raJOcopen+2tLXq2QkSyHC/8xadl1usLJPWtnDsUSqOf5UaOemFwGIiSuhwex5zLhijscC5kK+kkxt8pnvI5FBiQ1nt9s/Uzjxp8APlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498261; c=relaxed/simple;
	bh=omiyMzynNdnRpL9K4oS2TUAGHxRxU9EMFnkEEdZ+VFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWs/CQQ6AoHLjoXmGDiJlEXEyYysXQwvsFqS8hBJTLp+7LR5Bahvkz6k8elHtEOAVqMPfIJ4inwaWIGQWqAw/6GXVgIgZr0KjPXqVmXGbUiHoBzYl6DPBExZHjd3Cni5Pr/PmNYkZrq2r4T122Cm92T6k+7YeYBfwVqpGpiwh48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDVaIDP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDVaIDP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FF7C116D0;
	Thu, 15 Jan 2026 17:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498261;
	bh=omiyMzynNdnRpL9K4oS2TUAGHxRxU9EMFnkEEdZ+VFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDVaIDP/r874qDqaZmn+IxlI3Wz9ee0+4FI6hQlTtCDfkdKJmvJKm3xmcE9NQe7d5
	 QZDjsPXG5dHc0Tnh6EKXaBDWsMsAL2/blruRfBOl1tbpF5fyGHilfipJs9pxYDsib9
	 zw4vFjh4MYMk7Jgqr89EW9qElXl9IS7/X0BLFmk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	olivier moysan <olivier.moysan@st.com>,
	Wen Yang <yellowriver2010@hotmail.com>,
	Johan Hovold <johan@kernel.org>,
	olivier moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 369/554] ASoC: stm32: sai: fix device leak on probe
Date: Thu, 15 Jan 2026 17:47:15 +0100
Message-ID: <20260115164259.582543441@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


