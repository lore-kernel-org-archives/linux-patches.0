Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AA44EE870;
	Tue, 13 Oct 2026 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893301; cv=none; b=AEFeGO0UAk14obg5iZkxPSjncC5HcvdLgzEHnDRZK4jpnnnGqmPJ0RYHFf0ioo9QC/iZJ4wFhgul7aUj2aHjnTXmYwc1rhe4cPh0p68hXvv8uIKXzP9MvuIhaHzLgix92ufswonXd3/WCma584OEQAE83UXyfHFFiyDDAzNcrEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893301; c=relaxed/simple;
	bh=Wr/hCu95CWxY4gLmIobo97DZsnhwqb9phxTshgOJCWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1onMp3KufRqxZZSQGx04is0mV5hYyFtBDjFa/PjVrHTIxUeNmh27gZRMVZYumCXxAaHDTAPgg/oNZ0maSb6O2msCqh5UrQFV8ecVQQNfsw+dbB7QcWaK74saWdAZUaHa5MJ7NJnWfykkPjf9wf9zXwU2NtONBSflZr04nWPn+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAxnfBSK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAxnfBSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3AD1F000FF;
	Tue, 13 Oct 2026 12:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893300;
	bh=U3FuWc37SE1ej+bZoWoq3uMP22rs1xNPRP4CZRrOrjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nAxnfBSK+WBG0KmprpL3UI6CT7RzsEALMkjKVn28uMcHJ+DoOAAWyyTmHncC+jxzF
	 u2uUteuJryya+ThP21N2KiY0236WCb6sxwfHQXL9tgDxJzExJFUoq+cm5Q+/YWuP5g
	 F3TeSEPQFI7ode21U7TULJlfgnpqlHOUeFGfvq64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martino Facchin <m.facchin@arduino.cc>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>
Subject: [PATCH 6.18 180/621] ASoC: qcom: q6asm: handle the responses after closing
Date: Tue, 13 Oct 2026 13:32:55 +0200
Message-ID: <20261013112925.132884556@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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



