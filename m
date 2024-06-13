Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A93143870;
	Thu, 13 Jun 2024 12:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280474; cv=none; b=f6iuQ1IOdQVVol2pY7vh7cehNV2zL0AETSmzQ/L5cRTtYGLSJ7+QGyr3YfzuPTlS/yBwt9nD8jXHwrycC0xsLpI/B+dp5/lWNPeB6aqnCRlcNNBKVv7cDr8SqpcFhO5ADnfHP8WQTX4I1rZSOIw7V2fG1RTML3DntwuTvFuhzyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280474; c=relaxed/simple;
	bh=ymy54LsWkjwfPng+0cVLbB3A3L9sM+s1bqpE9THBfi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzAbxTlPHc7uJUtql8Crh6S/yZdkMxfppjMM8xPzOWHLd2YFmzUROkp8CT1xgPoh8kz5MMOR32s8jy+bnD0U28lfdejD1b4CsIN3wdo3d850Vi8iwj/pNMFx63cVzoAkEhpqXdcaNC4e4/nkGcfcE79M+HfHD+8V741Dxot/k4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8lfkTum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8lfkTum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A36C2BBFC;
	Thu, 13 Jun 2024 12:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280473;
	bh=ymy54LsWkjwfPng+0cVLbB3A3L9sM+s1bqpE9THBfi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8lfkTumU5+efmwK/+7ammjs9j7aF5r2fmsDR20T0kok4B+WjCwiyvaylSdMhOA3+
	 dsxtwEnudn86kqqjXnGcZmx1+HKozFJk2/bp07QkBlIcDDBdb9MusGhg8xfR/lnTKu
	 TzbaQT4ckFT1teMUaXNqOpJfnWLffTgxdIC7fDwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 065/137] LoongArch: Override higher address bits in JUMP_VIRT_ADDR
Date: Thu, 13 Jun 2024 13:34:05 +0200
Message-ID: <20240613113225.822536103@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -41,7 +41,7 @@
 	.macro JUMP_VIRT_ADDR temp1 temp2
 	li.d	\temp1, CACHE_BASE
 	pcaddi	\temp2, 0
-	or	\temp1, \temp1, \temp2
+	bstrins.d  \temp1, \temp2, (DMW_PABITS - 1), 0
 	jirl	zero, \temp1, 0xc
 	.endm
 


