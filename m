Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623838;
	b=Q4M59Jyaf/JbEdZKeccVnShdef6CTHLISmTkqdUkYYpPetFzrdFZrAysH4lOmHvz2IWk
	 OqjdZs7E1GIcywfrxvGB7bLUo5iNXa+wbE+1W6DGVD3Q798MlF5Ex/poo15Crvn9pZGfK
	 E7RIsumswKjZDvyOS0pgiI25Z8caLMVSpDg/81QES+AuSa60YNKyjdUY4XIizkgRikqmq
	 ASHWCKGjAv5eWpA343hmYfNxEXIbx0C9b/LUNyp+37RVR8QREZV3WA+O6ASoApieiXmsW
	 FkEDzfJxaWP5gz7Ch1SRMdEHUq1p7wLVl23459Q0RJQ5amTsElG96ny6X0WhBXXKdyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8dxNR7ih1V+AoNG4B++wodwcyVuB0ctYtNjvoUrbMSw=;
	b=bQBHCPQToiOlfEMqhyH8pBG4XkO3IqI7SD5OsI7mJox8UMkvIFn47T9IcM+P0LgzfWA8
	 4scpuuE2tBSU0/SyspIkzbylzvpLfg62CAd8KCs+SYJFtRgalyxgs41jxh/On8sJ6p2oK
	 oyoycYuMf8hRboITB8iGB551g4cxhFz6c+SRNt/zTYohkt1wJJbBaU095dGBadUMUNeHi
	 GVmjddK4UJaKyjCmDCeLVAdheeod174Fto3piOBwQ+N7cScjdRQxNFwMlSTwjs+kF0+46
	 SFcvefgPyuo0YC+cKchFL2zKkortaWrV36Tz9RdHdpnA0EpQYfjsfSyUP9TNcSelqSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKYdAHtm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DCD606A321;
	Wed, 25 Nov 2026 16:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKYdAHtm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322EC1F000C4;
	Wed, 25 Nov 2026 16:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623838;
	bh=8dxNR7ih1V+AoNG4B++wodwcyVuB0ctYtNjvoUrbMSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKYdAHtmEewuWG7GNvGI3+ymROoalOlshyyP8enNnYKUBdHYMzCL9V1JT+olmZZl6
	 ULG0pcEN8Ope7iw/oaTVkwvtIh+haRqzmRziykmlVcRs6H5UNw4vShm36M5a2IyxDV
	 CzqUfp0WGn02NrCPEwrK/x1qqtzf1l6T6WyOLzjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 989/990] mtd: core: avoid double-free of OTP NVMEM device
Date: Wed, 25 Nov 2026 15:39:16 +0100
Message-ID: <20261125143845.143068733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 26300879cd8e4612dce66bb8f6ff7cd35fcf3e59 upstream.

If factory OTP setup fails after the user OTP NVMEM device has been
registered, mtd_otp_nvmem_add() unregisters the user device but leaves
mtd->otp_user_nvmem set. On an error, the caller unregisters it again.
For -EOPNOTSUPP, registration continues and normal teardown unregisters
it again.

Clear mtd->otp_user_nvmem after unregistering it.

Fixes: e0489f6e221f ("mtd: core: fix error path for nvmem provider")
Fixes: fe0b8213c012 ("mtd: core: Don't fail mtd_otp_nvmem_add() if OTP is unsupported")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdcore.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1082,6 +1082,7 @@ static int mtd_otp_nvmem_add(struct mtd_
 
 err:
 	nvmem_unregister(mtd->otp_user_nvmem);
+	mtd->otp_user_nvmem = NULL;
 	/* Don't report error if OTP is not supported. */
 	if (err == -EOPNOTSUPP)
 		return 0;


