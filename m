Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC3E2BB1B;
	Fri, 15 Nov 2024 06:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653882; cv=none; b=XwZoUVDc3s3Dg8XrLgNTFTvCprhFHbANwHL9calZa3p0slDqPXEmnvBJlUAU6PspLlQ0lnwfCghCfx9pfLYCUCSabIzgKEZqjbiF1gATK7UCmSLTTCsX8jlEBBXkAZDy52SKlkNUM3NJEYg8LsNpdwDTFn1Lu5I/qDBQQ8thaCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653882; c=relaxed/simple;
	bh=BrYjxwXZUME6GbBdEgZxb24SLTqw82z6qG3ue9+D3Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAR5hKd9HwS/Zy2TSbxBbQOYmFecSBx0DbE82wK3espOLYuWVmwPhJwjQ4GDl6CsYx0ijfUUtUEOBGxFDYmz0JRs0MURiQdNeVid9AUupV8It88UGtI/k1aCalxeKOdSmzLx0pKEbQT87CSTE3YEFfY/wMl6YmvY4Hde8nEBtKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTgkw7KF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTgkw7KF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2953FC4CECF;
	Fri, 15 Nov 2024 06:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653882;
	bh=BrYjxwXZUME6GbBdEgZxb24SLTqw82z6qG3ue9+D3Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTgkw7KF1ZeimaFd8FUXR3iZACV78b5hLeFmU7nlyMkmoU0WNToiwS00pAyEqVOx2
	 2K+BXA2UQ+6An0D5yVDpdfP5kpJTBGC8okzw4Bc6mAYfMXJegt3UgqyrznfHbsm/kh
	 lYMD8olKhGSEzcyhO527dhSLMse4blr9TV2WcJBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 30/82] media: cx24116: prevent overflows on SNR calculus
Date: Fri, 15 Nov 2024 07:38:07 +0100
Message-ID: <20241115063726.649969656@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -741,6 +741,7 @@ static int cx24116_read_snr_pct(struct d
 {
 	struct cx24116_state *state = fe->demodulator_priv;
 	u8 snr_reading;
+	int ret;
 	static const u32 snr_tab[] = { /* 10 x Table (rounded up) */
 		0x00000, 0x0199A, 0x03333, 0x04ccD, 0x06667,
 		0x08000, 0x0999A, 0x0b333, 0x0cccD, 0x0e667,
@@ -749,7 +750,11 @@ static int cx24116_read_snr_pct(struct d
 
 	dprintk("%s()\n", __func__);
 
-	snr_reading = cx24116_readreg(state, CX24116_REG_QUALITY0);
+	ret = cx24116_readreg(state, CX24116_REG_QUALITY0);
+	if (ret  < 0)
+		return ret;
+
+	snr_reading = ret;
 
 	if (snr_reading >= 0xa0 /* 100% */)
 		*snr = 0xffff;


