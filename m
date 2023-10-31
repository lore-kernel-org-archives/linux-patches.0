Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EB1208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKt096x9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50EBC433C9;
	Tue, 31 Oct 2023 17:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774592;
	bh=E3Dt3l/TvDWQT/uTgp4OydlnWZqfkOyiwItYCqDoyQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKt096x93S+RYSH1CXj2KBgOZinVYHqLuWm+/ApPCn5nfc/AtrbTzowme11Cyr5A3
	 PcjW32LsuBEivoGJA/fnvxBa4jkyLIbKlp+HG6kj/B6c1xo12Ut4pl/2t3l7p9oxCU
	 P0KWICuJfQpAVfIhIs7Y2sG0SBBsQ1t6mXTp3ZL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.5 097/112] misc: fastrpc: Clean buffers on remote invocation failures
Date: Tue, 31 Oct 2023 18:01:38 +0100
Message-ID: <20231031165904.351055714@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1178,11 +1178,6 @@ static int fastrpc_internal_invoke(struc
 	if (err)
 		goto bail;
 
-	/* Check the response from remote dsp */
-	err = ctx->retval;
-	if (err)
-		goto bail;
-
 	/* make sure that all memory writes by DSP are seen by CPU */
 	dma_rmb();
 	/* populate all the output buffers with results */
@@ -1190,6 +1185,11 @@ static int fastrpc_internal_invoke(struc
 	if (err)
 		goto bail;
 
+	/* Check the response from remote dsp */
+	err = ctx->retval;
+	if (err)
+		goto bail;
+
 bail:
 	if (err != -ERESTARTSYS && err != -ETIMEDOUT) {
 		/* We are done with this compute context */


