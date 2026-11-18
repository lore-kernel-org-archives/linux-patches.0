Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035321;
	b=JQUmSx1LTe0zeBWfJhTl+TTJc/0rb2yxcb79LZcgW1LACs+dCvt53PkO16nwflh7gsKB
	 9Rr+017Yuwa4IOdqcF4Ws3AK9/F1AckVXCSJlNgiDMgH5g4/u0f2MFPJVB0Rbp/eRASua
	 jHbZ4CCV9QYb3zg0/V0asS36nepclsXt4uXNgDQka9JK19m/rPwT94Yh+72bMrsNfeOLJ
	 Rov/3y/HLR/49gs/GD6rn9kgcaJ1m7TEHxC3l0axEOmVnU408J70QCvtozJq46/aicJ8J
	 gxKY6gkSDKP9g8RmTKCA4ZPWBSXj3PrV+omTFv2BQimGM64Z3uRq16wbhGVyjhWtlYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ba7GUMXiHlKka8AxScLmhKKlpIY6VudrHHwzJz3sfyA=;
	b=g4yOKcMY21ToMOjFaZhBCu5+EBPepk9DzFPHIQrmmfwIn55lySTzhaVbntMq82JeFQ/7
	 GU5K4JpQJNIloguvn4aTHC4qm0yUFAS1SHlTfCq3kYc73etrzc8DPsxyo0eAnCp3MuBkJ
	 4FZabSAe+D5L4Sn35LVbtfrU392qAarLtYdUmDa01jZgcwQsyuRtey7KN00NIuYGY0a/f
	 GShIvCvnnbcDSi4I6kWK4c5eN48YMQzsdEz3239YZ9Wgep/ilaPuWdmWKnrzPtibeF9BA
	 22pSv4U9fV5MTnje1SLAZJEGYexpmOAD7/amgi3Rq+M1zA8n2KMs5M5bSTdlKs1gqcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8g4CEsZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21E8606A31C;
	Wed, 18 Nov 2026 20:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8g4CEsZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF8A1F000C4;
	Wed, 18 Nov 2026 20:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035320;
	bh=ba7GUMXiHlKka8AxScLmhKKlpIY6VudrHHwzJz3sfyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8g4CEsZ/RLElrO0+Am4WpIz+TjuAz4haAwTSmsHIhlLByF0CtmHJSoRVgt+A0ZdK
	 UlnMym98VxOva2DzesH+P42TPBwbNBgGRe1Lrl2rduZB8tgXf3KD2z47ZcCMgleUYY
	 Q/aox4fyH5kijpqbHO+R+8F1zo/uspZgPWsxSxUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 0662/3318] EDAC/mc: Really fix error path ordering in edac_mc_alloc()
Date: Wed, 18 Nov 2026 15:21:24 +0100
Message-ID: <20261118150337.932193457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

The backport of 51520e03e70d ("EDAC/mc: Fix error path ordering in
edac_mc_alloc()") to stable kernel branches is incomplete due to a
different memory allocation scheme. In v6.19 and earlier, the device
initialization must be moved further up so that all jumps to the
error label are covered.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@kernel.org # v6.19-
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_mc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 952ebd94e0ece..9ab8f31fbab55 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -365,13 +365,13 @@ struct mem_ctl_info *edac_mc_alloc(unsigned int mc_num,
 	if (!mci)
 		return NULL;
 
+	mci->dev.release = mci_release;
+	device_initialize(&mci->dev);
+
 	mci->layers = kcalloc(n_layers, sizeof(struct edac_mc_layer), GFP_KERNEL);
 	if (!mci->layers)
 		goto error;
 
-	mci->dev.release = mci_release;
-	device_initialize(&mci->dev);
-
 	mci->pvt_info = kzalloc(sz_pvt, GFP_KERNEL);
 	if (!mci->pvt_info)
 		goto error;
-- 
2.53.0



