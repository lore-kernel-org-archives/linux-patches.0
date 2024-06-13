Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11C613C69C;
	Thu, 13 Jun 2024 11:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279493; cv=none; b=YHDGMiRLYiinE8RH4asugrap6gLpBOCGtY7/sD0NBAA8b8oJ+/Rzvl5cqj5rfXKGLr+xQOEOgtgzOGWHTIT/TO3DRx0IDNzaMl9lS7Ac/6GmZq9OTJsa+srSLUsyr8DJm21n/Q/04RLmmS+Rr8ao2GdZP1zNi9mEXE7467T5m/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279493; c=relaxed/simple;
	bh=nNVmplvd/6vCVrUgPE2SkOdydBKWXs5C/DUpl6tKDNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWbpZXDlWM3q2XOlpEyxaBI0+kp6qbxogY3fE7qjxQNc2FanxFNkR+wyicS3oF5cQ10sBASbJ+YIGj9VySVwvPsdlqCdo5f8mWRqnlwXbdQkw6ewUzoYCpC1ASd5pE6leHRH9Ioz4FWUdP1O1SVmtngyNSj3MZVyc00ahqgCnb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNikcn6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNikcn6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786B6C32786;
	Thu, 13 Jun 2024 11:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279492;
	bh=nNVmplvd/6vCVrUgPE2SkOdydBKWXs5C/DUpl6tKDNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNikcn6Q78nfIondtBAw80txuvDXtxKSVT5wkDz6+C+v8xf10dD69Uga9eFlXvKnb
	 iOgMrmU+OztcnYLqq0ZCrn6Uj+x6dOJAeHulJXmPD09CPJIiQrU3rzXo98JXjIVzr2
	 m1zA2vb6WSS3HmZE+1Vm/9CBuguJSMsax3AbpNns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.9 063/157] LoongArch: Override higher address bits in JUMP_VIRT_ADDR
Date: Thu, 13 Jun 2024 13:33:08 +0200
Message-ID: <20240613113229.861469445@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 1098efd299ffe9c8af818425338c7f6c4f930a98 upstream.

In JUMP_VIRT_ADDR we are performing an or calculation on address value
directly from pcaddi.

This will only work if we are currently running from direct 1:1 mapping
addresses or firmware's DMW is configured exactly same as kernel. Still,
we should not rely on such assumption.

Fix by overriding higher bits in address comes from pcaddi, so we can
get rid of or operator.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/stackframe.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/stackframe.h
+++ b/arch/loongarch/include/asm/stackframe.h
@@ -42,7 +42,7 @@
 	.macro JUMP_VIRT_ADDR temp1 temp2
 	li.d	\temp1, CACHE_BASE
 	pcaddi	\temp2, 0
-	or	\temp1, \temp1, \temp2
+	bstrins.d  \temp1, \temp2, (DMW_PABITS - 1), 0
 	jirl	zero, \temp1, 0xc
 	.endm
 


