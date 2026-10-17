Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB02374E60;
	Sat, 17 Oct 2026 16:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253970; cv=none; b=OUF/Ozg54ZsH7QbRZ3cHKAoyNu3B+bAwtiFl8lxeSZM2ksNzmwCvOj6CvWAfzjo/5Z6N2XOVGWjOhEW1CSZ9GxaURgXp+l5KKbc/F8cXHC8RFZ9so0/ZwfHAcKTJ1+K2hgzXY3yD9tkA2nRgBJhlOdxU+NGSfhCTKEeuULVeLOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253970; c=relaxed/simple;
	bh=R0Ea/xofiqVNqg50y3JatWbfI/N33dQA2Jw0QuVCEL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmDu4NM2xXPqQeWimf2aAT38SrtiK+aku2UpkwwJLFdpGx9RVwSeUu4HoK28zIRZhckMo64V7J7xhYET19m7Dj/IzHgpQhCVbPXsXOozc6btlIpR8oJLeBDe9RITShOHgm+Oiq0qymhaLT5xennqmLrrdrdm42cZMukHR1MmolU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcVhmHVv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcVhmHVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA3D1F000C4;
	Sat, 17 Oct 2026 16:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253969;
	bh=eEpI/u0sjfqgDCtpbVUhEolOwSkO8p4qjhgaipgXkKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcVhmHVvBNWtmhc8Ei2eAaenwtRdkgX2M9cThqAYwjikX13qXNSTAFXlTkHshfwk9
	 VN35YhTd4XZmlmgQ6iDQmWIF06PX7e7f0BJim8tfprzWxs1XM1rLJQatRiGT1ymJn7
	 pzHyoNGdQgChuEWhSOvWJB5yaCtYW2Ew+88WbYqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martino Facchin <m.facchin@arduino.cc>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>
Subject: [PATCH 6.12 243/869] ASoC: qcom: q6asm: handle the responses after closing
Date: Sat, 17 Oct 2026 17:51:24 +0200
Message-ID: <20261017160043.289690313@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 67e9ca18883cd..4c3315d4e27da 100644
--- a/sound/soc/qcom/qdsp6/q6asm.c
+++ b/sound/soc/qcom/qdsp6/q6asm.c
@@ -638,6 +638,7 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
 			client_event = ASM_CLIENT_EVENT_CMD_OUT_FLUSH_DONE;
 			break;
 		case ASM_STREAM_CMD_OPEN_WRITE_V3:
+		case ASM_DATA_CMD_WRITE_V2:
 		case ASM_STREAM_CMD_OPEN_READ_V3:
 		case ASM_STREAM_CMD_OPEN_READWRITE_V2:
 		case ASM_STREAM_CMD_SET_ENCDEC_PARAM:
@@ -654,6 +655,10 @@ static int32_t q6asm_stream_callback(struct apr_device *adev,
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



