Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0532F83C1;
	Tue, 26 Aug 2025 11:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207383; cv=none; b=n/Lhlb1cSnRF5aeofyUgmHkSVTaLjWosW/66mn64gIukHlUtae8d246cNKgE4ABIt5kRNCpPv/B3ba0HTA0IlEQ74SUniS4h9JvJEUtTbCuY3PN0vlbgT4WV/AQswdrelnhxrcKrlMstFN66IbLuYYm3CzQJ6hJyF8NlyVPLGkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207383; c=relaxed/simple;
	bh=6PWf0LY+LcgE0nPB/el85vIFuF4jkOjIHFe7kSXIElw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQA7uhN1tKPl1kYO1bjIeT+5Mobh9gOoKN+d6r2jIlQiQhpo6hKsggMhc8v9gICzO8/1Ew9WU+9l5FCOS2BtdRZn1yQbscXRi4tqOjbMymGgJUgKwFllFJ57Bu6DYL/DBjsGXWagEPHJklFmWDalDSrYNItpRUTNSncpbDyTxd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdh4g+1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdh4g+1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0AEC4CEF1;
	Tue, 26 Aug 2025 11:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207382;
	bh=6PWf0LY+LcgE0nPB/el85vIFuF4jkOjIHFe7kSXIElw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdh4g+1Pbzmot64SPU+O1HIdgxS/cairIIBO8s7cQXOWZwmJKhqyv42Ja3kUaB2t6
	 g+hlrf6a3x8fapWbLuOMvvKMEJBsHvUI1jUjcNGTyn9GOiyCmfe6orhhrUw4h2eMnu
	 42wFihX/P/2w4oBaSk2KQAmPLJBcAnUTi/dJUH2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 161/457] media: iris: Send V4L2_BUF_FLAG_ERROR for capture buffers with 0 filled length
Date: Tue, 26 Aug 2025 13:07:25 +0200
Message-ID: <20250826110941.355013414@linuxfoundation.org>
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

commit 7adc11e6abf619d0bb0c05918d5da5b9d4bcb81e upstream.

Firmware sends capture buffers with 0 filled length which are not to be
displayed and should be dropped by client.
To achieve the same, add V4L2_BUF_FLAG_ERROR to such buffers by making
sure:
- These 0 length buffers are not returned as result of flush.
- Its not a buffer with LAST flag enabled which will also have 0 filled
  length.

Cc: stable@vger.kernel.org
Fixes: d09100763bed ("media: iris: add support for drain sequence")
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # on sa8775p-ride
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c b/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
index 4488540d1d41..d2cede2fe1b5 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
@@ -378,6 +378,11 @@ static int iris_hfi_gen2_handle_output_buffer(struct iris_inst *inst,
 
 	buf->flags = iris_hfi_gen2_get_driver_buffer_flags(inst, hfi_buffer->flags);
 
+	if (!buf->data_size && inst->state == IRIS_INST_STREAMING &&
+	    !(hfi_buffer->flags & HFI_BUF_FW_FLAG_LAST)) {
+		buf->flags |= V4L2_BUF_FLAG_ERROR;
+	}
+
 	return 0;
 }
 
-- 
2.50.1



