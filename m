Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F1D2F5A37;
	Fri, 10 Oct 2025 13:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102523; cv=none; b=KgfAvfdbKzcaJoilAtW/h0rskutxSC6xFaJJGroidw756+2A7kJFvqbHREUMWuSaaLm6vA15WBblhb34fnEy7Wnh3Z3wJKy+liV2DOfqrjEBxxYDFtex1vTXmqIZ+wKOJ3IMfvptvnIV6hvD7h6amtmutBSPtSgnApBDvYXK4Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102523; c=relaxed/simple;
	bh=P1ZP170NpBeGyuM6KBN0NWWp4d5ztWYYvB14y5VoGrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMpwk7DKENtZ/tYZaAefPe/JgCnMEcj7bk9ZaAWx7IyH7E9A5s4tgYrWeVJWJlpPbUofIoMunNuCEyVgX+FJGf4fYauV6zZQiSW+rlor3MwSPAkbGyzQlSQuRv8o9GjtsBCvOnjWZ0Qtu31hXt2xBn4+igiT/Ddxtbwt3cMvu6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEZiKJkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEZiKJkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF20C4CEF1;
	Fri, 10 Oct 2025 13:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102521;
	bh=P1ZP170NpBeGyuM6KBN0NWWp4d5ztWYYvB14y5VoGrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEZiKJkOiL/UN+zccK9DTVIZjNIDGSsjFlAHGhMVme9GGbHeyBifzvNn/kbnAHYW+
	 fVN9QH/8iTspq0XK3IJ9gGAywyUIjJ1vL9ELXEbA/O9KdHQSZ1iED1AG8rjIWGm5K6
	 EsufOpigCJOMYieBORTMXzKay/aXwSHtwJTlIWwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaoyun Liu <shaoyun.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 21/35] drm/amd/include : Update MES v12 API for fence update
Date: Fri, 10 Oct 2025 15:16:23 +0200
Message-ID: <20251010131332.558812489@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

From: Shaoyun Liu <shaoyun.liu@amd.com>

commit 15d8c92f107c17c2e585cb4888c67873538f9722 upstream.

MES fence_value will be updated in fence_addr if API success,
otherwise upper 32 bit will be used to indicate error code.
In any case, MES will trigger an EOP interrupt with 0xb1 as
context id in the interrupt cookie

Signed-off-by: Shaoyun Liu <shaoyun.liu@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/include/mes_v12_api_def.h |   40 +++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/include/mes_v12_api_def.h
+++ b/drivers/gpu/drm/amd/include/mes_v12_api_def.h
@@ -105,6 +105,43 @@ struct MES_API_STATUS {
 	uint64_t api_completion_fence_value;
 };
 
+/*
+ * MES will set api_completion_fence_value in api_completion_fence_addr
+ * when it can successflly process the API. MES will also trigger
+ * following interrupt when it finish process the API no matter success
+ * or failed.
+ *     Interrupt source id 181 (EOP) with context ID (DW 6 in the int
+ *     cookie) set to 0xb1 and context type set to 8. Driver side need
+ *     to enable TIME_STAMP_INT_ENABLE in CPC_INT_CNTL for MES pipe to
+ *     catch this interrupt.
+ *     Driver side also need to set enable_mes_fence_int = 1 in
+ *     set_HW_resource package to enable this fence interrupt.
+ * when the API process failed.
+ *     lowre 32 bits set to 0.
+ *     higher 32 bits set as follows (bit shift within high 32)
+ *         bit 0  -  7    API specific error code.
+ *         bit 8  - 15    API OPCODE.
+ *         bit 16 - 23    MISC OPCODE if any
+ *         bit 24 - 30    ERROR category (API_ERROR_XXX)
+ *         bit 31         Set to 1 to indicate error status
+ *
+ */
+enum { MES_SCH_ERROR_CODE_HEADER_SHIFT_12 = 8 };
+enum { MES_SCH_ERROR_CODE_MISC_OP_SHIFT_12 = 16 };
+enum { MES_ERROR_CATEGORY_SHIFT_12 = 24 };
+enum { MES_API_STATUS_ERROR_SHIFT_12 = 31 };
+
+enum MES_ERROR_CATEGORY_CODE_12 {
+	MES_ERROR_API                = 1,
+	MES_ERROR_SCHEDULING         = 2,
+	MES_ERROR_UNKNOWN            = 3,
+};
+
+#define MES_ERR_CODE(api_err, opcode, misc_op, category) \
+			((uint64) (api_err | opcode << MES_SCH_ERROR_CODE_HEADER_SHIFT_12 | \
+			misc_op << MES_SCH_ERROR_CODE_MISC_OP_SHIFT_12 | \
+			category << MES_ERROR_CATEGORY_SHIFT_12 | \
+			1 << MES_API_STATUS_ERROR_SHIFT_12) << 32)
 
 enum { MAX_COMPUTE_PIPES = 8 };
 enum { MAX_GFX_PIPES	 = 2 };
@@ -248,7 +285,8 @@ union MESAPI_SET_HW_RESOURCES {
 				uint32_t enable_mes_sch_stb_log : 1;
 				uint32_t limit_single_process : 1;
 				uint32_t unmapped_doorbell_handling: 2;
-				uint32_t reserved : 11;
+				uint32_t enable_mes_fence_int: 1;
+				uint32_t reserved : 10;
 			};
 			uint32_t uint32_all;
 		};


