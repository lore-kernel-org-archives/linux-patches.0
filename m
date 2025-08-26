Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19EB2BE03C;
	Tue, 26 Aug 2025 11:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207374; cv=none; b=XYg1pGb+vwTLLE09PMQy22kgqGwKwn52X22GZUUO0jSfMAv4E/5UYkDn4IZz66oFVmCthDxJbl1K9C37oMBzaF4Y4nZKGkxQPaP9eq7CmMnND7SItGEMO0i4DadrnM093Wp/rxJjJjLY6Jq6gMyklQlKvtChlxYb8RvJcgsWhDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207374; c=relaxed/simple;
	bh=IrFFurL4cIBbSwuNredabTYHn0ycmvmE9+GRR30DgY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qceFhKaODk80POxlz/Hho78m2nG1md8orgMAa45G+gwR9/yRT9u/XvDtoinK5rD1m3dKS7k/lef2CCrXvZXBKSWdlZ3U0R0NdAraEaIPHLt/QC/MLm2I2QXGZziw0t9M10bE11O+lymyZIxmsaqvrTd2nqWUu768ms7oltqOUd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0OjETbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0OjETbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D27C4CEF1;
	Tue, 26 Aug 2025 11:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207374;
	bh=IrFFurL4cIBbSwuNredabTYHn0ycmvmE9+GRR30DgY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0OjETbvr0kzwgvEBeFel2+n4+IMVN5781ZM6ug7+sBKWf1s9lVDkPKcRQpF6lZ7W
	 zW6xbxsMmvv86kY/8t8rC4CEXX08UWx2Qpy/OXS5MqRRVsAAH5nMMOqfKGV+LtMIqA
	 jmgEWfiJ5Jm+SomGcie4HUVLMhWfLuYwD4nnJPr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 158/457] media: iris: Prevent HFI queue writes when core is in deinit state
Date: Tue, 26 Aug 2025 13:07:22 +0200
Message-ID: <20250826110941.278732347@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 2781662dee7bbb9675e5440f5dff4e3991dc5624 upstream.

The current check only considers the core error state before allowing
writes to the HFI queues. However, the core can also transition to the
deinit state due to a system error triggered by the response thread.
In such cases, writing to the HFI queues should not be allowed.

Fix this by adding a check for the core deinit state, ensuring that
writes are rejected when core is not in a valid state.

Cc: stable@vger.kernel.org
Fixes: fb583a214337 ("media: iris: introduce host firmware interface with necessary hooks")
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # on sa8775p-ride
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/iris/iris_hfi_queue.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_queue.c
@@ -113,7 +113,7 @@ int iris_hfi_queue_cmd_write_locked(stru
 {
 	struct iris_iface_q_info *q_info = &core->command_queue;
 
-	if (core->state == IRIS_CORE_ERROR)
+	if (core->state == IRIS_CORE_ERROR || core->state == IRIS_CORE_DEINIT)
 		return -EINVAL;
 
 	if (!iris_hfi_queue_write(q_info, pkt, pkt_size)) {


