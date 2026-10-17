Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F370D39EF2C;
	Sat, 17 Oct 2026 18:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260473; cv=none; b=afR1vj+OuzBFNYMLOJ7y0s2jrHT+99aG+za3RGKAUmyRwd2bRVEZcRV7U/vrlRglNuh+3pOkPmlCJTVZkAm+J/jh0XYLEuyLKDIsYCbjkt0vFOjEZScu0Y2AbgWjXmnCUc3bGYkKTdPksD5vEcumprSinNv7sjItBG1j/aWipHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260473; c=relaxed/simple;
	bh=Hgycgi0kqtqXLp1EPcl+azeZok5oRWtc7DEffBm4a7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQQ2IcK1+ni4w0aR897+d/e41jVP5CTqRrTe1vHSF1VwE86xMfJxIzwG2yWuwj/rE+vX4ZS8yV/+kIz0FgXoj5lGx9rJAiln0warbWQzSnHn2MS5kEs7KUn9OAks/bS5DwkbcqZIusRCLFzWfVCDl0CXp4iYKohfN816TDuW8qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZq2ToLV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZq2ToLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279201F000C4;
	Sat, 17 Oct 2026 18:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260471;
	bh=CAmLh0gVgiG/OWYYp0Aa3wXPw9K4yvZmu4YFQQlHZ5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZq2ToLVZyleNyXVZUrI1yaGoJnkdemHrXvS+bgyLXMjFCDBEIdctJIwhl+zsCPZu
	 rJcxcdU30SnVzAYe1SvWzVGc4c0xu85O78afCTS1AlAQg7OXpIFcfGeK1YpSIHgaYT
	 WjcjdVqNH5m9GS5L2aKMoGcxIwh+v6ZF2+N/gLO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martino Facchin <m.facchin@arduino.cc>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>
Subject: [PATCH 6.6 1557/1674] ASoC: qcom: q6asm: handle the responses after closing
Date: Sat, 17 Oct 2026 18:03:49 +0200
Message-ID: <20261017160511.065065144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit a354f030dbce17ab3cf299660a38b162d97f7151 ]

For record path, multiple read requests are queued to dsp in advance.
However when data stream is closed, the pending read requests are rejected
by the dsp and a response is sent to the driver, this case is not handled
in the driver resulting in errors like below

q6asm-dai ab00000.remoteproc:glink-edge:apr:service@7:dais: command[0x10dac] not expecting rsp
q6asm-dai ab00000.remoteproc:glink-edge:apr:service@7:dais: command[0x10dac] not expecting rsp
q6asm-dai ab00000.remoteproc:glink-edge:apr:service@7:dais: command[0x10dac] not expecting rsp

This is same for both write and eos.

Fix this by allowing ASM_DATA_CMD_READ_V2, ASM_DATA_CMD_EOS and
ASM_DATA_CMD_WRITE_V2 as expected response.

Reported-by: Martino Facchin <m.facchin@arduino.cc>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Tested-by: Alexey Klimov <alexey.klimov@linaro.org> # RB5, RB3
Link: https://patch.msgid.link/20251023102444.88158-6-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 8a066a81ee0c ("ASoC: qcom: q6asm: drop DSP responses for closed data streams")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6asm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/qcom/qdsp6/q6asm.c b/sound/soc/qcom/qdsp6/q6asm.c
index 9f53cffe5184e..85abf2ce091fe 100644
--- a/sound/soc/qcom/qdsp6/q6asm.c
+++ b/sound/soc/qcom/qdsp6/q6asm.c
@@ -637,6 +637,7 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 			client_event = ASM_CLIENT_EVENT_CMD_OUT_FLUSH_DONE;
 			break;
 		case ASM_STREAM_CMD_OPEN_WRITE_V3:
+		case ASM_DATA_CMD_WRITE_V2:
 		case ASM_STREAM_CMD_OPEN_READ_V3:
 		case ASM_STREAM_CMD_OPEN_READWRITE_V2:
 		case ASM_STREAM_CMD_SET_ENCDEC_PARAM:
@@ -653,6 +654,10 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 				goto done;
 			}
 			break;
+		case ASM_DATA_CMD_EOS:
+		case ASM_DATA_CMD_READ_V2:
+			/* response as result of close stream */
+			break;
 		default:
 			dev_err(ac->dev, "command[0x%x] not expecting rsp\n",
 				result->opcode);
-- 
2.53.0



