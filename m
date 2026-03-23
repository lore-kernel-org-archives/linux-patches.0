Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4616C1B4223;
	Mon, 23 Mar 2026 13:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273809; cv=none; b=AQ8izpNiuoJ+ylNxrQt0/H9NyKnDfg/vDtnZ4WJwj1zuGL9rbrmUZ2I2rlXuoA32ObMyxO8l0StpY2eLxJaBRhJ6oCg0OcDmZP3c3FnvqRA3Z+VlG5GwcN/s1aKUcS0xrUKccoTy10oAx4mSnH8lsippPCRvZcF6ABO3iFlj2LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273809; c=relaxed/simple;
	bh=I4uB6UiW1vgzTDXtan3cLKYpUVhmpmWTJLNuxs/wGwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHd7Dwwl0bGs7KCAPCzyrNRtxV5ASjH2yFuqoGFXFpcLERMVNlHm0CtWrEFKyHrD2KNpdJBZmkFJSgvNLheuLpiXFdqmDZLSsEO3BELGN+UxruMO/gCymlf7NZn+UvnbgbEQHT974EcEfLwQ3CsoPPdZPJORNASptx8weeGhKWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZ+r3Utq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZ+r3Utq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3EBC4CEF7;
	Mon, 23 Mar 2026 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273809;
	bh=I4uB6UiW1vgzTDXtan3cLKYpUVhmpmWTJLNuxs/wGwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZ+r3Utqcj6/hcXSIy7ki3WcY112TV0aRz1IonM8H6Qe4KUCGbLh/DA6x1uJMoJPZ
	 bHfNRG7XJdvlFifEmj1jNrIrn7K9RhV3EMyVZ5AXBG6w4DGI77uznn+NiEztfXbDD+
	 BKs1rFROmeNr91QCJX4oRFhGAgTDI6gZDKxgmP/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 016/220] bnxt_en: fix OOB access in DBG_BUF_PRODUCER async event handler
Date: Mon, 23 Mar 2026 14:43:13 +0100
Message-ID: <20260323134505.090797548@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit 64dcbde7f8f870a4f2d9daf24ffb06f9748b5dd3 upstream.

The ASYNC_EVENT_CMPL_EVENT_ID_DBG_BUF_PRODUCER handler in
bnxt_async_event_process() uses a firmware-supplied 'type' field
directly as an index into bp->bs_trace[] without bounds validation.

The 'type' field is a 16-bit value extracted from DMA-mapped completion
ring memory that the NIC writes directly to host RAM. A malicious or
compromised NIC can supply any value from 0 to 65535, causing an
out-of-bounds access into kernel heap memory.

The bnxt_bs_trace_check_wrap() call then dereferences bs_trace->magic_byte
and writes to bs_trace->last_offset and bs_trace->wrapped, leading to
kernel memory corruption or a crash.

Fix by adding a bounds check and defining BNXT_TRACE_MAX as
DBG_LOG_BUFFER_FLUSH_REQ_TYPE_ERR_QPC_TRACE + 1 to cover all currently
defined firmware trace types (0x0 through 0xc).

Fixes: 84fcd9449fd7 ("bnxt_en: Manage the FW trace context memory")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/SYBPR01MB7881A253A1C9775D277F30E9AF42A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2927,6 +2927,8 @@ static int bnxt_async_event_process(stru
 		u16 type = (u16)BNXT_EVENT_BUF_PRODUCER_TYPE(data1);
 		u32 offset =  BNXT_EVENT_BUF_PRODUCER_OFFSET(data2);
 
+		if (type >= ARRAY_SIZE(bp->bs_trace))
+			goto async_event_process_exit;
 		bnxt_bs_trace_check_wrap(&bp->bs_trace[type], offset);
 		goto async_event_process_exit;
 	}
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2135,7 +2135,7 @@ enum board_idx {
 };
 
 #define BNXT_TRACE_BUF_MAGIC_BYTE ((u8)0xbc)
-#define BNXT_TRACE_MAX 11
+#define BNXT_TRACE_MAX (DBG_LOG_BUFFER_FLUSH_REQ_TYPE_ERR_QPC_TRACE + 1)
 
 struct bnxt_bs_trace_info {
 	u8 *magic_byte;


