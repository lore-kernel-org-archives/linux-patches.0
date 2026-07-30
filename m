Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C11270545;
	Thu, 30 Jul 2026 15:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426102; cv=none; b=DFgYn88TlCsMYNE1l66RjD3PI8ZjVw0Zl+UG5BLvfaQP23ga0sKg5PSCLAt197lkq7EA4t8APw9/Ez1MmBCAYlR1+QyPFUbo0ZfxFsYMNzTqU6Ec/jDIMcEwAav2S/3M2+0XyTcHifXA3vMjhVD7ipH+XMUEqJb7F+ApOf7AEbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426102; c=relaxed/simple;
	bh=5knjPLY5JPKN9vtSP1klf5V3CpSMPnPPDvm5pHXmyl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFa52lIlckJgOX6Lsf7s0pZmu2yqKAqnQ7fqVOcjOu8ndivc2ZoK3yMGiXujmm2KQn77xP7Zk/Axxns6YlSvyHJCIXGImv4mwwxugG42Ukj4dFEv3tZYnq3zLPCuL5InsrZbiBpk1gQzD2j/zrYrcTsz/zw0SmLs9bDLpopW1pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Gg/cVSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Gg/cVSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924591F000E9;
	Thu, 30 Jul 2026 15:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426101;
	bh=7jYoQ/rsJQGb9sVuxEfMBQetE68qb37xQe6bXbi1GVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Gg/cVSc29tGobUZg8+kOC3NBRe09MOO8mRLjCn2rlFxRWCsxjtGKX4Ku5s04XWdc
	 ETRxDizx8broIUkEaF3gvh2BpMtck/sb+c2Xk6O7Z8n/fwwA7mkJLKUzc+1ecx3u7V
	 fookSLnJedFjgaPdiBl4D3erJrR583yaRaQlxzdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 301/602] media: cec: seco: unregister adapter on IR probe failure
Date: Thu, 30 Jul 2026 16:11:33 +0200
Message-ID: <20260730141442.294050365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit c3a78691be8245e52ced489f268e413f18061ac2 upstream.

If secocec_ir_probe() fails after cec_register_adapter() succeeds,
probe returns an error and the driver remove callback is not called.
The current unwind path unregisters the notifier and then falls through
to cec_delete_adapter(), which violates the CEC adapter lifetime rules
after a successful registration.

Add a registered-adapter unwind path that unregisters the notifier and
the adapter instead.

Fixes: daef95769b3a ("media: seco-cec: add Consumer-IR support")
Cc: stable@vger.kernel.org
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/platform/seco/seco-cec.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/cec/platform/seco/seco-cec.c
+++ b/drivers/media/cec/platform/seco/seco-cec.c
@@ -649,7 +649,7 @@ static int secocec_probe(struct platform
 
 	ret = secocec_ir_probe(secocec);
 	if (ret)
-		goto err_notifier;
+		goto err_unregister_adapter;
 
 	platform_set_drvdata(pdev, secocec);
 
@@ -657,6 +657,10 @@ static int secocec_probe(struct platform
 
 	return ret;
 
+err_unregister_adapter:
+	cec_notifier_cec_adap_unregister(secocec->notifier, secocec->cec_adap);
+	cec_unregister_adapter(secocec->cec_adap);
+	goto err;
 err_notifier:
 	cec_notifier_cec_adap_unregister(secocec->notifier, secocec->cec_adap);
 err_delete_adapter:


