Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048933;
	b=FGZzvoDIUesOf4IngDzkX8otTwodcJGENB6Q0LlHqrog9KBRp2j6djABp5/z1rk3/MFw
	 yhzO/1P0u3awLvA666Y54BtnrzQcqvGj1HHzQuhjuTNlW4Km1Wr91fzYKn6XzGw+LSV4a
	 cnljO7KiDfPylgcUdp9JBa+I/h6RTnj/n3mhm++Jin1t3+J6RqJ9eET5Q2evzpF2eC7ZW
	 lCzPDIw7shC9QuS0q5wG9FBAArRM3BGDHIDW2tKmkOk1YC7ferYBXZvpLRvTKy7xF2Y1a
	 aFOrl95K7+T6NwD0aGAfwuHXyC1RnKR7jpiv2o22ohxl20CJ3hIEz7zibjjlcVsMoAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QY9K/Ipq+g7nZdAOn6gSjCDMs3562Gop1ZdMBVXIpdw=;
	b=TnfGxmUrVSI91jI2YMwM4TeBTcgHn62AdVTX84vIGPzykrMw3HKz+gpf2D8mOOlR7LNm
	 IcDK6iAD26yxYLtgu5sorfemJHjDMTe0/tFb3vDPZRF9mBvM3C2Xw25bSfrESHNcR07ta
	 ky7ERussefvajD1F3CB5RoolNM5lHRUanustkiMnyVe1dR+2IRKn5yR5qpt2flKKq8KE0
	 XO33Wu1jDBnHzTLnZ/+ErsDmpr2s9Mfvmw3wVU3RFDtIw6NXJnp86EOlkl6CrfgnDywah
	 CQ+9ptigP5/9wTAbP6DPbMkl/J8/0Hu5fSxZuOL+TGhQUVA5jiDRsTJAi4zBK7zrBYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9B79sMl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A7E606A325;
	Thu, 19 Nov 2026 00:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9B79sMl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644B81F000C4;
	Thu, 19 Nov 2026 00:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048932;
	bh=QY9K/Ipq+g7nZdAOn6gSjCDMs3562Gop1ZdMBVXIpdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9B79sMlbkKDM2zXkye5RpwgDSkv/0s6wrcgvC91REJnus+uJ66UE8qYTjQF0Frj2
	 CbTsK6U0zNeoBRRLp5g5H8WJ3aIgoqiGRkaXW6DJioFCbYNM2mGb0Pcepe6bHtdJHU
	 gD9zRkVnacUSrnzwy+CW5sgwJC/0Wz6puUEDezoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2164/2857] misc: enclosure: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:53:18 +0100
Message-ID: <20261118150319.320848110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 0f3b12bab74e13a2b8686a49c5b83099da61e032 ]

After device_register() fails, the embedded struct device has already been
initialized and must be released with put_device() so that
enclosure_release() can drop the parent reference and free edev.

The error path currently does put_device(parent) + kfree(edev), which
skips the device lifetime rules and can free the object while the device
core still owns a reference (use-after-free).

Fixes: d569d5bb3fd9 ("[SCSI] enclosure: add support for enclosure services")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260806070358.1599627-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/enclosure.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 1b010d9267c9b..ec836d7530f9c 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -147,8 +147,7 @@ enclosure_register(struct device *dev, const char *name, int components,
 	return edev;
 
  err:
-	put_device(edev->edev.parent);
-	kfree(edev);
+	put_device(&edev->edev);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(enclosure_register);
-- 
2.53.0



