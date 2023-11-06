Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A15B208CA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ps/q5RUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA333C433CA;
	Mon,  6 Nov 2023 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277133;
	bh=PvdMV7OzsuJPdduEfdY4Ujd0CbtvQ/nUdqxhHPOELsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ps/q5RUyWFeqCcweiLdBW1PmqtbGHL6iO7r/YUOImsWIPl02C8NsXJYTAzuClhDlS
	 cJ5//J0yN8GJncQ58ThJhbin35TMKJLX1MXLXB7LEFOg+hwzc2blBI2/8NbgCLyJlv
	 3qKKLnjHtt/kja+HkiHlumdjKwoNjP1i6nnRxvDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.15 049/128] misc: fastrpc: Clean buffers on remote invocation failures
Date: Mon,  6 Nov 2023 14:03:29 +0100
Message-ID: <20231106130311.337204999@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit 1c8093591d1e372d700fe65423e7315a8ecf721b upstream.

With current design, buffers and dma handles are not freed in case
of remote invocation failures returned from DSP. This could result
in buffer leakings and dma handle pointing to wrong memory in the
fastrpc kernel. Adding changes to clean buffers and dma handles
even when remote invocation to DSP returns failures.

Fixes: c68cfb718c8f ("misc: fastrpc: Add support for context Invoke method")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231013122007.174464-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -995,11 +995,6 @@ static int fastrpc_internal_invoke(struc
 	if (err)
 		goto bail;
 
-	/* Check the response from remote dsp */
-	err = ctx->retval;
-	if (err)
-		goto bail;
-
 	if (ctx->nscalars) {
 		/* make sure that all memory writes by DSP are seen by CPU */
 		dma_rmb();
@@ -1009,6 +1004,11 @@ static int fastrpc_internal_invoke(struc
 			goto bail;
 	}
 
+	/* Check the response from remote dsp */
+	err = ctx->retval;
+	if (err)
+		goto bail;
+
 bail:
 	if (err != -ERESTARTSYS && err != -ETIMEDOUT) {
 		/* We are done with this compute context */


