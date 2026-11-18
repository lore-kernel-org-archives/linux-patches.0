Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025064;
	b=jAumvrpT9A7vHbdAcuMmHsoTn6Xi6LhCdExeXN2oV/dyoUHqWevc7XGIvhtCfNn/Aonk
	 D5pEAzltqkiRHSSkvMsaz7lIngpCoXZT0M3wRTlwB/u5fFvmfbxkoP2oMCB0ONnnZwKFE
	 S1cSVlmqk7+RsvBGouVjy02NuDoEdZy1ziebTyVsn0WZloaQw3x0QPbneo5jBWvVZa6SX
	 p9d34RaocN60GF/oEjQfX2ewiWg+2ppTUdMijxQRybJ2PPbr9D8lEK21UFPfoLMoNvq+g
	 xGZ9vuTR1SmoGJWYxwQJOmTbQH75586RlsldeydsKCMChosuSUrRysoGR7aN9Pavwew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D0C8HWHMegBOICZcdc5hUx8cH+JZJMLmLG3SezwXY+Q=;
	b=Gv9V7lb+31feT/un0RJrQMEj2uQ2IXo3YNAEBtHUW3BPvpeUWZVXADjqySDrPXqBb1aO
	 EzbJdh5Wb8HcGod4sEcwAyrk+2Qi+BDKDruON9u3SuaNWiFWP2bXF5WEQf6k3Du59aWaJ
	 mz8tXGZ4lBpfrQEr+vEcrlVnohc5TmzUvxmzoLJmY7j06t7mjdGMfDUD7vu3oSnWwYuGH
	 8gG+9jPFFIZ8VFPfEiSMh021y/mn+4dz3QBrPZb4wnl7NodWiQSyTxcx0Ga2Y8VNqpjO7
	 CSPqjxz88ZWyqCryueU/ShpSg/Dc0X6PYilRIghttWd1WkbPGtIyTwN+9NsppMYeDSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UlmKXU2K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D06606A320;
	Wed, 18 Nov 2026 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UlmKXU2K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2501F000C5;
	Wed, 18 Nov 2026 18:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025063;
	bh=D0C8HWHMegBOICZcdc5hUx8cH+JZJMLmLG3SezwXY+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UlmKXU2KXqzUOgtfgJDUDL+zH65+G1E4H5BEebSaDDWiWNbx4oxOwaNRBZxamHhtX
	 gFseuDvSzaGCRFrq0Wc1obC336gseFXRmSIDbUYVnE0PtpPZ/0V/vG0QkHS4rRg2ZE
	 Zw8FlahOD03yYikUm0D8psyYmxiu+oAPCCaJ77iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0930/2151] misc: enclosure: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:44:25 +0100
Message-ID: <20261118150156.375029460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ca4c420e4a2f7..9532ad8f8b4e0 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -148,8 +148,7 @@ enclosure_register(struct device *dev, const char *name, int components,
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



