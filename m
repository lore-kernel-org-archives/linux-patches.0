Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11FA377A92;
	Sat, 17 Oct 2026 16:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253842; cv=none; b=aq9c5bkL5D7amWUpk/CrZOaSnflLNmaBecmoDxWHGblQA6deK6dF6dFySNw8GDA1tujq9eYOBxDJXBhO5rParzMCBpwxQ1gsSFGAApAWIqEdUllQlJ/d4rKS2Ey7f4enbrkV+lJd4Fum+BFCqAcOsgGCDGtxfHUbaxoP6ymTq8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253842; c=relaxed/simple;
	bh=JHv5i0LEooqGalwcwpX3heHSecBUg5IqVkGdMMNfoas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NzxYxcyyKS1Jym2pZYjHULeoWgJTuPnme7iyNirvr4x1JL7FP36Cl3pUCp8DMoRkhZQda8LvIIzqRgAX75TGUeT2gIFxNHpxkIgfmPBUD9BufW4VwLDoOLEJsjw+oo7xrsgaZ93a5BdMpToYmqO+Goihndc+HkN4TfDKkjnnFR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKL4l0P2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKL4l0P2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D5D1F000C4;
	Sat, 17 Oct 2026 16:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253841;
	bh=qgX3ouEeePQF20HYIf/4UhKbzeodsVCYCY1KFvsrfEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKL4l0P2ALjKA/tLAmlw3mAGDGtXXaFs8OG4G1oLBcJXdabaRJt2Va1jxeJXTnzyf
	 pJEES6GN66Tv5pS37uJxVaHV6Rn5/nZBT0SoNJnduO9ldHSDhINpV3/atavkYdESX7
	 VW54NDYKuapE9RcbIFe/96gV8nIjbgO+YJU19cHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A9dric=20Bellegarde?= <cedric.bellegarde@adishatz.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 244/869] ASoC: qcom: q6asm: drop DSP responses for closed data streams
Date: Sat, 17 Oct 2026 17:51:25 +0200
Message-ID: <20261017160043.316514933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



