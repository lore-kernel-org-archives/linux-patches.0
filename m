Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8341E3749E3;
	Sat, 12 Sep 2026 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232817; cv=none; b=Bc4gMZtpSkljRBb+xyoTa2RV4QdY0QnhHcmJ639VOtVVMbopFwerKKY7+g0F3tvswBgzpx45lByTbOAfAq4evRS4E+opR23TA0UetG+XDsiF/BrLF5NoMtS3DJkocBYv9D7K55jVa9WLKMSnuZhdalC7AC0CcClvK3yHWXIE1NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232817; c=relaxed/simple;
	bh=XyA/Kkgl7aboDTBr1FWrt8lwDmFAvZ5AiDuwX5G2jTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKh9qXFdOFqPm6XMTjiQy0J3RKn+idb8eHfhk+uL2OVqzxdNrOIeab1C/hqJy+7H6z+WffMbYTfBBPOfExl90eI1JA2bF4xvB/vFzbSmZANBbdokAnLlGwCr8rRFx9gSGNcQRiI8L9gwMACUl6PXKt6vdiN556UN+c8Jymei3sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NqUrjG0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NqUrjG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E25D1F000FF;
	Sat, 12 Sep 2026 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232815;
	bh=Zdd2TlLP+Dt8cX9xM0jQ/KaIKV7Glms2yIuTfWe7rvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0NqUrjG0YUfF8Mi9GW5gPCK53+u/o+j4tInTCpk8J0Ttj2yVNi1w9jrCRJRbO7IQz
	 YcEMYAhUMTliyWciyPJ0QEAcSLd076YxRrZQAQ/IEXt0BTymHzA6UcZrpLEAMlXS0P
	 SvkVHXyoNK9G7NQn5D2sGvYN1QmuhrTPMPKhdI94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 088/935] bnx2x: fix double free in bnx2x_init_firmware() error path
Date: Sat, 12 Sep 2026 08:51:58 +0200
Message-ID: <20260912065528.843392858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit d2796ffe38cb4155afe0eab23636295b096c27a5 upstream.

bnx2x_init_firmware() frees bp->init_ops, bp->init_data and
bp->init_ops_offsets in its error path without setting them to NULL.
The cleanup function bnx2x_release_firmware() frees the same three
pointers unconditionally, so if init_firmware fails and
release_firmware is later called (e.g. from __bnx2x_remove or through
the function state machine), all three are freed a second time.

Set each pointer to NULL after kfree() in the error path so that the
subsequent kfree(NULL) in bnx2x_release_firmware() is a safe no-op.

Fixes: 94a78b79cb5f ("bnx2x: Separated FW from the source.")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260815122149.951215-1-yijiangshan@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13493,10 +13493,13 @@ static int bnx2x_init_firmware(struct bn
 
 iro_alloc_err:
 	kfree(bp->init_ops_offsets);
+	bp->init_ops_offsets = NULL;
 init_offsets_alloc_err:
 	kfree(bp->init_ops);
+	bp->init_ops = NULL;
 init_ops_alloc_err:
 	kfree(bp->init_data);
+	bp->init_data = NULL;
 request_firmware_exit:
 	release_firmware(bp->firmware);
 	bp->firmware = NULL;


