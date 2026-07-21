Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71B1471243;
	Tue, 21 Jul 2026 19:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660796; cv=none; b=jFbX+FkoLUTLNr1g/sdQWcClWVeHfQaN9FcGfUug0Uq75cepSnSBj2pQlwy/giYL3KaRv/HvmiMDD5L+cmkkWQhLdAuKAHCSx2HLMOYk3DGxzLkJuLOKU3mOR33wMmTI0g2nbkKhFGPGYk7jpelZxIz8vQH81e0WCfNZ+CCQqWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660796; c=relaxed/simple;
	bh=mEbrBOkg13HZWBVXnXQyesQySkLCr3rn9d1d4AjsAS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyR3KOf+y68vJkvSNtphUDlI/9lPo9M2ct2JsVpRn8FNFQtTB1LpLYpKE7SII1eQIo7i9W6Ek2zbWmy4UmlPl/cYjajOf2fsfqDoUKK/CqyqztXtyyy8wpt00cCRleSiR3EhK8FPCf0wK+X0QfDy8iXi96tt1FYYIDBxyXW3sh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEOIuoF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEOIuoF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380EA1F000E9;
	Tue, 21 Jul 2026 19:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660795;
	bh=dr/j/qvnazH31CXghn9JrdQz8BebmcLPZoHKx2a0xSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEOIuoF3T+N7RPlx+Wa/HS62q1agZxM4LEvihFpJn4qL0xHdMr0MAZbnvY4AJAlG6
	 4i4hYViRhMqj8yIVg8F32eevKIZB9s/b6kEQH2E/jZ8TxYJNgkmMQNwpkQ5Ef1wszr
	 t+9t8YZugy38LPPLZ6vJ8dTvpuYtoRePw/97h65A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1116/2077] ALSA: usb-audio: qcom: clear opened when stream enable fails
Date: Tue, 21 Jul 2026 17:13:09 +0200
Message-ID: <20260721152619.143535603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 3c7af07943b2718087ae791cad450af5cf646d90 ]

On enable, subs->opened is set before the service_interval is validated;
an invalid interval jumps to the response label without clearing it, so
the substream is wedged at -EBUSY until a disable or disconnect.

Clear subs->opened on the enable error path.

Fixes: 326bbc348298a ("ALSA: usb-audio: qcom: Introduce QC USB SND offloading support")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260618025126.1862954-3-michael.bommarito@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/qcom/qc_audio_offload.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/usb/qcom/qc_audio_offload.c b/sound/usb/qcom/qc_audio_offload.c
index 621dca3587f853..ed833a43db6354 100644
--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -1625,8 +1625,13 @@ static void handle_uaudio_stream_req(struct qmi_handle *handle,
 	if (req_msg->service_interval_valid) {
 		ret = get_data_interval_from_si(subs,
 						req_msg->service_interval);
-		if (ret == -EINVAL)
+		if (ret == -EINVAL) {
+			if (req_msg->enable) {
+				guard(mutex)(&chip->mutex);
+				subs->opened = 0;
+			}
 			goto response;
+		}
 
 		datainterval = ret;
 	}
-- 
2.53.0



