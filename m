Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24889645;
	Fri, 15 Nov 2024 06:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652790; cv=none; b=kxYXh+k7DHSd5FLGE0PWz4MhA13v4Z+VJLyObmlP6QB/mbyBz165rbj1LXZzXPr/KUbQW1cL8Qg/zKlXXVR+Lnq9pUR5+XDgfz45bzHIkLBuxYnY8/QAjiTnRzxs5iYRVYyD7+usoJnWz3DU2/oARgNGzjRfZFnR8Cf0a8EPYrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652790; c=relaxed/simple;
	bh=JOs6rovnBUfsTAT8fo/tqdat6uboVw9PTP2Dho+KFVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NK9FtzYpo123q9UjxD6x1D3RiTAEOBr06isxIm2KbLX9eYTomprDZQWSoYMC13vyz6S8gI9rGzPzaeodMC2XEyGyBaHrMXsHUJJvKFzbyVq62Ta5qjJVIlc1YNRwtDfDmmmHN8lQFd82G8acY9HIxnK6O0sWU3Ui2V3yuV63DKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrcryjoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrcryjoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87149C4CED0;
	Fri, 15 Nov 2024 06:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652790;
	bh=JOs6rovnBUfsTAT8fo/tqdat6uboVw9PTP2Dho+KFVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrcryjoQElcdvi5NLtxdhOg+AGsBgCw2oZ54Ym8q8EQ7TyurHtbrZMVYFdmi8Tjga
	 F7Opc2ICVeTLjMwZaxihcDRnvS11AssYEQWcE7yHKXMRLcHXgxCH4/CNWDrajqLvB7
	 dg2G25BB1pTuNr96OjisAx+klGo8Wgy+BYZK1x5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 16/52] media: cx24116: prevent overflows on SNR calculus
Date: Fri, 15 Nov 2024 07:37:29 +0100
Message-ID: <20241115063723.442510487@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 576a307a7650bd544fbb24df801b9b7863b85e2f upstream.

as reported by Coverity, if reading SNR registers fail, a negative
number will be returned, causing an underflow when reading SNR
registers.

Prevent that.

Fixes: 8953db793d5b ("V4L/DVB (9178): cx24116: Add module parameter to return SNR as ESNO.")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/cx24116.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -753,6 +753,7 @@ static int cx24116_read_snr_pct(struct d
 {
 	struct cx24116_state *state = fe->demodulator_priv;
 	u8 snr_reading;
+	int ret;
 	static const u32 snr_tab[] = { /* 10 x Table (rounded up) */
 		0x00000, 0x0199A, 0x03333, 0x04ccD, 0x06667,
 		0x08000, 0x0999A, 0x0b333, 0x0cccD, 0x0e667,
@@ -761,7 +762,11 @@ static int cx24116_read_snr_pct(struct d
 
 	dprintk("%s()\n", __func__);
 
-	snr_reading = cx24116_readreg(state, CX24116_REG_QUALITY0);
+	ret = cx24116_readreg(state, CX24116_REG_QUALITY0);
+	if (ret  < 0)
+		return ret;
+
+	snr_reading = ret;
 
 	if (snr_reading >= 0xa0 /* 100% */)
 		*snr = 0xffff;


