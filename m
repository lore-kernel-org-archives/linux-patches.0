Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28BB330B08;
	Fri, 17 Oct 2025 15:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715774; cv=none; b=lzBcarWCSWs6zp6LkSA0FYdJno82j710435oexruiYZKsh1EI6Akf0WlEAnGzxmvE+Sh6qubPVjUY226RiQX8XtOcTdxrgTrQdzSLkyQVfbwiHC8g6N/IOVoAZ3LUWqwrSYCptswJ46dfTJg0nb8acMUlnMWMBqutJv145RGT4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715774; c=relaxed/simple;
	bh=ClmddUr4zoXEztnZX93QJpoLTVXzNHCsKcp8pUXnKII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gcjop2kuRxoKvG7oakpahmlkKEmwuSy5TXm1U2bVwghClu9nrhYnUPGB+iSkrBqq4AcGiY5lsaSaMUfuPkNrrZmRucH4NR+EovvCKq0P4zjJuAP+xXDaxo/Wa0YYIR32ohQ9QHYqal2Z4odg80t3GK5ux5lv9WY3oKQHiLiHBig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruwqnbu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruwqnbu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76999C4CEE7;
	Fri, 17 Oct 2025 15:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715773;
	bh=ClmddUr4zoXEztnZX93QJpoLTVXzNHCsKcp8pUXnKII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruwqnbu+uATgb5JKksK+Rg6dVU4xco3CFxLe3s3GDkr8GaKH+v974NzmxYSAxiw6U
	 9k6lWMSeedZ5xsFDuLhhuQF7ax9QC4HAudWbuTVgTs/OLh653GZ9fQXs0NiC0YlVw9
	 wRRdMz/2kmeNFTHdWVgbBKTdgtYtfYfsgITe3pdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Subject: [PATCH 6.17 332/371] media: iris: Simplify session stop logic by relying on vb2 checks
Date: Fri, 17 Oct 2025 16:55:07 +0200
Message-ID: <20251017145214.091034060@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 0fe10666d3b4d0757b7f4671892523855ee68cc8 upstream.

Remove earlier complex conditional checks in the non-streaming path that
attempted to verify if stop was called on a plane that was previously
started. These explicit checks are redundant, as vb2 already ensures
that stop is only called on ports that have been started, maintaining
correct buffer state management.

Fixes: 11712ce70f8e ("media: iris: implement vb2 streaming ops")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # X1E80100
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # x1e80100-crd
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../qcom/iris/iris_hfi_gen1_command.c         | 42 +++++++++----------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
index 5fc30d54af4d..3e41c8cb620e 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
@@ -184,11 +184,25 @@ static int iris_hfi_gen1_session_stop(struct iris_inst *inst, u32 plane)
 	u32 flush_type = 0;
 	int ret = 0;
 
-	if ((V4L2_TYPE_IS_OUTPUT(plane) &&
-	     inst->state == IRIS_INST_INPUT_STREAMING) ||
-	    (V4L2_TYPE_IS_CAPTURE(plane) &&
-	     inst->state == IRIS_INST_OUTPUT_STREAMING) ||
-	    inst->state == IRIS_INST_ERROR) {
+	if (inst->state == IRIS_INST_STREAMING) {
+		if (V4L2_TYPE_IS_OUTPUT(plane))
+			flush_type = HFI_FLUSH_ALL;
+		else if (V4L2_TYPE_IS_CAPTURE(plane))
+			flush_type = HFI_FLUSH_OUTPUT;
+
+		reinit_completion(&inst->flush_completion);
+
+		flush_pkt.shdr.hdr.size = sizeof(struct hfi_session_flush_pkt);
+		flush_pkt.shdr.hdr.pkt_type = HFI_CMD_SESSION_FLUSH;
+		flush_pkt.shdr.session_id = inst->session_id;
+		flush_pkt.flush_type = flush_type;
+
+		ret = iris_hfi_queue_cmd_write(core, &flush_pkt, flush_pkt.shdr.hdr.size);
+		if (!ret) {
+			inst->flush_responses_pending++;
+			ret = iris_wait_for_session_response(inst, true);
+		}
+	} else {
 		reinit_completion(&inst->completion);
 		iris_hfi_gen1_packet_session_cmd(inst, &pkt, HFI_CMD_SESSION_STOP);
 		ret = iris_hfi_queue_cmd_write(core, &pkt, pkt.shdr.hdr.size);
@@ -207,24 +221,6 @@ static int iris_hfi_gen1_session_stop(struct iris_inst *inst, u32 plane)
 					 VB2_BUF_STATE_ERROR);
 		iris_helper_buffers_done(inst, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
 					 VB2_BUF_STATE_ERROR);
-	} else if (inst->state == IRIS_INST_STREAMING) {
-		if (V4L2_TYPE_IS_OUTPUT(plane))
-			flush_type = HFI_FLUSH_ALL;
-		else if (V4L2_TYPE_IS_CAPTURE(plane))
-			flush_type = HFI_FLUSH_OUTPUT;
-
-		reinit_completion(&inst->flush_completion);
-
-		flush_pkt.shdr.hdr.size = sizeof(struct hfi_session_flush_pkt);
-		flush_pkt.shdr.hdr.pkt_type = HFI_CMD_SESSION_FLUSH;
-		flush_pkt.shdr.session_id = inst->session_id;
-		flush_pkt.flush_type = flush_type;
-
-		ret = iris_hfi_queue_cmd_write(core, &flush_pkt, flush_pkt.shdr.hdr.size);
-		if (!ret) {
-			inst->flush_responses_pending++;
-			ret = iris_wait_for_session_response(inst, true);
-		}
 	}
 
 	return ret;
-- 
2.51.0



