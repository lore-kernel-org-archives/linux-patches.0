Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060581;
	b=ZvLO2kfwtzgHsd0pqiXscTu0sj3y0ubmKWtRnn5VOTE6qXKdr86Xm/Fpt+0qu1WwDAYf
	 IVb/pS28TRn0OyyLnClnKTkqirlM53EdtisHz//bShZLhxBq4w9fnPGdDLlgoli0/ea37
	 Cn8jeNKckHvl3CuqKiMmhsm4ez7J33j9ewS0NiPfGlDoaPHR+BDx9IjClDAyTMrmHujoE
	 Y8VgSmJRM7gZGcznJanuZKxboL/iaOiv6XqUWhJx8msd+PiytA0Jk5kcslji5t/ok5cJ1
	 qgvqvnDw07RotllU2Aq3sFJB/hk/HWRanhUx7HAcVfSsnykUe6QjCs7NBnVTFrHMuMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6yM+d5KVdi5Qr3NG45Qd5ZHxqXxMdCd1widPwNGR3+E=;
	b=pGZNe50dP+3/l3qgBQMIWVmUsDqllzpBSjFavxnfR7ZNEcwfTe1l8UBzORmi9JNISnVj
	 zfzBl2cH2mKbHW5AfdeMqcDQMSawV747YfHA/RJBN0Al4zhnhs6RY0cYZj7tdcoQUgC1x
	 5Bb/+I4amUSW0Wc1KbhsPFMd577/SJZYMHvK1N0961ZRKNlC+ZjGrpQc7zt2OUVupmtVg
	 LrN7OyQKm2XLN7rFpjeUuFgLA5uMVVDC9nfugVafweKdoOefsmxj7ayhW4zGYx1H7OwFX
	 3pb0ZNSa7yuPjHS0qtqSQrxwcKrlusCt7+hVDvv4lkezLGyunaPejB9t+9jr44hzwoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l5/8QQVQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7612D606A32A;
	Thu, 19 Nov 2026 03:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l5/8QQVQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0821F000C4;
	Thu, 19 Nov 2026 03:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060581;
	bh=6yM+d5KVdi5Qr3NG45Qd5ZHxqXxMdCd1widPwNGR3+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5/8QQVQBtKCFq5nevvoIbm5/oY0/kZZdKhdW5ue70vK9+PzZjDaJ9jIKC1FoJAlQ
	 wVSZsfoVnwmhSNACiuejjxItWc/m3NevlGaPpMRyoC94cULHN5kU5CkMHgVkNJJXP5
	 bDxkOyJ/mG7s5p1zgJnldNm3imDQzCrGmbqT0i6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1251/1848] firmware: imx: dsp: fix mailbox channel leak on kasprintf failure
Date: Wed, 18 Nov 2026 15:54:49 +0100
Message-ID: <20261118150012.153052688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit e3631d0242842940f9e902afaea98202e56277e8 ]

If kasprintf() fails while setting up mailbox channels, already
requested channels from earlier iterations were never freed. Route
the failure through the existing cleanup path.

Fixes: ffbf23d50353 ("firmware: imx: Add DSP IPC protocol interface")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-dsp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/imx/imx-dsp.c b/drivers/firmware/imx/imx-dsp.c
index 4265e9dbed84f..74217c7a8b1e2 100644
--- a/drivers/firmware/imx/imx-dsp.c
+++ b/drivers/firmware/imx/imx-dsp.c
@@ -82,8 +82,10 @@ static int imx_dsp_probe(struct platform_device *pdev)
 		else
 			chan_name = kasprintf(GFP_KERNEL, "rxdb%d", i - 2);
 
-		if (!chan_name)
-			return -ENOMEM;
+		if (!chan_name) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
 		dsp_chan = &dsp_ipc->chans[i];
 		cl = &dsp_chan->cl;
-- 
2.53.0



