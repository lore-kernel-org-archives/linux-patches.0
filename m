Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A9D330B04;
	Fri, 17 Oct 2025 15:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715771; cv=none; b=i9M1OJi8zUD22ZRn++W4GOBHeEfpfIdOpPfBzXvONRxZGobfzY8QUI3QP4EchKnnO09UwsH8g+GVqveGUy0wSumlDlekiBTJy6ccUGEGcqP/Fe63z74XCUvXeWM1j25N9v94XnrUFWgCuWn0r3VTkyNLOJ5hNq+6zF0fpCxGtqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715771; c=relaxed/simple;
	bh=zn+toRlQdtHXAI/D1RT3MOSbz/82/4YGn0V6tZ4nT7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heXVuwgi0lErXbSYWXwRVp44+nRMpEmsFanlIPf2iCYUvVTokXoPwY/QmiPDvUAa0f7Tf6dFQayRUJtZiPLX0EFmhjdBW6GXN8CIMeHT1JLyoMouWRl6kNbVWaxE8d5g9mMwoz5+9MdSjzEoxsJpRLTXc4Mr/Pdv1AToLaHDH5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tO/9wTRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tO/9wTRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E98C4CEE7;
	Fri, 17 Oct 2025 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715770;
	bh=zn+toRlQdtHXAI/D1RT3MOSbz/82/4YGn0V6tZ4nT7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tO/9wTReyHQpOF+fKgGYDir6kC6WSAUnviafrDsVHSUOlqqVfbb+VDJfSa8+HThW1
	 isg119ebWPcfg6Q7RCEwymicIX7uEyFGAnWmOkihzQ9X+R7ciX5gRkrRefANXjMHdo
	 pWO9UYEPSFOkvN6MokvSjl0Zk0wGXhKFhRn2XaLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.17 331/371] media: iris: Always destroy internal buffers on firmware release response
Date: Fri, 17 Oct 2025 16:55:06 +0200
Message-ID: <20251017145214.054317834@linuxfoundation.org>
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

commit 9cae3619e465dd1cdaa5a5ffbbaf4f41338b0022 upstream.

Currently, internal buffers are destroyed only if 'PENDING_RELEASE' flag
is set when a release response is received from the firmware, which is
incorrect. Internal buffers should always be destroyed when the firmware
explicitly releases it, regardless of whether the 'PENDING_RELEASE' flag
was set by the driver. This is specially important during force-stop
scenarios, where the firmware may release buffers without driver marking
them for release.
Fix this by removing the incorrect check and ensuring all buffers are
properly cleaned up.

Fixes: 73702f45db81 ("media: iris: allocate, initialize and queue internal buffers")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # X1E80100
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # x1e80100-crd
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c b/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
index a8c30fc5c0d0..dda775d463e9 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
@@ -424,7 +424,6 @@ static int iris_hfi_gen2_handle_release_internal_buffer(struct iris_inst *inst,
 	struct iris_buffers *buffers = &inst->buffers[buf_type];
 	struct iris_buffer *buf, *iter;
 	bool found = false;
-	int ret = 0;
 
 	list_for_each_entry(iter, &buffers->list, list) {
 		if (iter->device_addr == buffer->base_address) {
@@ -437,10 +436,8 @@ static int iris_hfi_gen2_handle_release_internal_buffer(struct iris_inst *inst,
 		return -EINVAL;
 
 	buf->attr &= ~BUF_ATTR_QUEUED;
-	if (buf->attr & BUF_ATTR_PENDING_RELEASE)
-		ret = iris_destroy_internal_buffer(inst, buf);
 
-	return ret;
+	return iris_destroy_internal_buffer(inst, buf);
 }
 
 static int iris_hfi_gen2_handle_session_stop(struct iris_inst *inst,
-- 
2.51.0



