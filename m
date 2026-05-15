Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245DB3FD960;
	Fri, 15 May 2026 16:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861950; cv=none; b=DIgOrj4ReqduRr5vEFe69mz5V5HRyeAUY3Z0MbO/flvJpe4v7VB0EuTJTTqXSnx+ce4gPEIMkKpR33ixb43hq2hYobNj+Tr3NU0TdbrWJ2sYt+nenp4k9PLsjrlugsVDL96yZS3hUgaq3jQumDo+VEIQw1o2rxwdYjSAoKUwjbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861950; c=relaxed/simple;
	bh=CJyK+fSwzNoEO4peugsJupLVQK7QOxhVsQctyqc7hxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sy8lCRrT1ox/fZwsDrFF6PVwrFIckHZsnkHwIH5QWd97R3hlTowH+xTqPAAbscsL4QPqm/epO4fhIic7YOnXouMFokybjNWoUIG791Z4PsfVYYpjAXJt1+VFBUdG82QbvA58JiW1X9lofziSjiGgC6lhGgGVo9zsk/Sr1KMtRFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzhgYpwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzhgYpwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE87AC2BCB0;
	Fri, 15 May 2026 16:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861950;
	bh=CJyK+fSwzNoEO4peugsJupLVQK7QOxhVsQctyqc7hxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzhgYpwuztV1T1K4RpXGioPDYzf/HSr5LwCtGHqStJZBHdP6fzebU6fRImXIG5Ohq
	 tV35n9AhoLuHgpsrjhC0iHW+MfBufzt2hOhl2KV9YGR9dfNM8tlQrVP7+wvxRHixLa
	 jXcBRsZVHSozzUxPaInaKN+gr2H4zM/Kfy2k2QaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 049/188] media: dib8000: avoid division by 0 in dib8000_set_dds()
Date: Fri, 15 May 2026 17:47:46 +0200
Message-ID: <20260515154658.379669723@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@auroraos.dev>

commit dde3c37af95cd6fa301c4906f33d627bc9dd874c upstream.

In dib8000_set_dds(), 1 << 26 (67108864) divided by e.g. 1 apparently can't
fit into 16-bit variable unit_khz_dds_val, being truncated to 0; this will
cause division by 0 while calling dprintk() with debugging enabled (via the
module parameter).  Use s32 instead of s16 to declare the variable, getting
rid of the cast to u16 in the *else* branch as well...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: 173a64cb3fcf ("[media] dib8000: enhancement")
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Shtylyov <s.shtylyov@auroraos.dev>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/dib8000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2695,7 +2695,7 @@ static void dib8000_viterbi_state(struct
 
 static void dib8000_set_dds(struct dib8000_state *state, s32 offset_khz)
 {
-	s16 unit_khz_dds_val;
+	s32 unit_khz_dds_val;
 	u32 abs_offset_khz = abs(offset_khz);
 	u32 dds = state->cfg.pll->ifreq & 0x1ffffff;
 	u8 invert = !!(state->cfg.pll->ifreq & (1 << 25));
@@ -2716,7 +2716,7 @@ static void dib8000_set_dds(struct dib80
 			dds = (1<<26) - dds;
 	} else {
 		ratio = 2;
-		unit_khz_dds_val = (u16) (67108864 / state->cfg.pll->internal);
+		unit_khz_dds_val = 67108864 / state->cfg.pll->internal;
 
 		if (offset_khz < 0)
 			unit_khz_dds_val *= -1;


