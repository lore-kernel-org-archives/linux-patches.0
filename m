Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6B74ED19E;
	Tue, 13 Oct 2026 12:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893305; cv=none; b=CzT5ntBPoaNU/cZqb5JKrrH4eUwiZXxo2/Pm/+ljGoHO8Z0jCL6pMMLIPAwZbynQOAZWQLJgCBDWivWUCi0oMv03F+AJ11KtAWeIvGcEuDaBcbUI3YUqRakxzFMxf2Ekwmy0/efBLwxnta6B41plOPAjHn4LQDRcSI8MOIXufd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893305; c=relaxed/simple;
	bh=7Ww0ECYAZy0r6LcVH0lu7qL33E2k9PYzoNIe+kGcGYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EqZWSt3hKwRIENTfbOamgafwI2v1rFX87a6TiR5vw9uveaNlTgjVCTN94FI25/4Aen1yt5kGLyosQut0APEgKrk4ybXZg14cqN79Wr+nTyMUgFEiiiHz0SV5lTlZGlcYbnuzFXQpM+twg89Ek+qhBIWUwSV1LTo7Y7bfeM9Ol2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efU+JSfi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efU+JSfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F731F000FF;
	Tue, 13 Oct 2026 12:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893303;
	bh=XivZgAsNFc+B3EcIkDIa/0IXFpjW34WEYDyDLjwnjVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=efU+JSfiSE1gLR95SVZQB2AaQzuSSnqxwWASZGTKXymkhHZupeLtlJqRVzeZGMWfX
	 FdbXsrD+iSHbMuQTXTlhuM4htsPrbA0J+e6ULNmEO0o9EbOEpD+AyNP7ztwM0oYqjp
	 LHa2w/86PrARv/ef/ZzvAf90K+nsunDX+Z8YMYlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A9dric=20Bellegarde?= <cedric.bellegarde@adishatz.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 181/621] ASoC: qcom: q6asm: drop DSP responses for closed data streams
Date: Tue, 13 Oct 2026 13:32:56 +0200
Message-ID: <20261013112925.157988071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cédric Bellegarde <cedric.bellegarde@adishatz.org>

[ Upstream commit 8a066a81ee0c1b6cdbd81393536c3b2d19ccef25 ]

'Commit a354f030dbce ("ASoC: qcom: q6asm: handle the responses
after closing")' attempted to ignore DSP responses arriving
after a stream had been closed.

However, those responses were still handled, causing lockups.

Fix this by unconditionally dropping all DSP responses associated with
closed data streams.

Signed-off-by: Cédric Bellegarde <cedric.bellegarde@adishatz.org>
Link: https://patch.msgid.link/20260102215225.609166-1-cedric.bellegarde@adishatz.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6asm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6asm.c b/sound/soc/qcom/qdsp6/q6asm.c
index 4c3315d4e27da..60c81edd945d5 100644
--- a/sound/soc/qcom/qdsp6/q6asm.c
+++ b/sound/soc/qcom/qdsp6/q6asm.c
@@ -638,7 +638,6 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 			client_event = ASM_CLIENT_EVENT_CMD_OUT_FLUSH_DONE;
 			break;
 		case ASM_STREAM_CMD_OPEN_WRITE_V3:
-		case ASM_DATA_CMD_WRITE_V2:
 		case ASM_STREAM_CMD_OPEN_READ_V3:
 		case ASM_STREAM_CMD_OPEN_READWRITE_V2:
 		case ASM_STREAM_CMD_SET_ENCDEC_PARAM:
@@ -657,8 +656,9 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 			break;
 		case ASM_DATA_CMD_EOS:
 		case ASM_DATA_CMD_READ_V2:
+		case ASM_DATA_CMD_WRITE_V2:
 			/* response as result of close stream */
-			break;
+			goto done;
 		default:
 			dev_err(ac->dev, "command[0x%x] not expecting rsp\n",
 				result->opcode);
-- 
2.53.0



