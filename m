Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610D22FA624;
	Tue, 17 Jun 2025 16:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179516; cv=none; b=qxi3xH9oZZfu/kpoWoA7SFpJqm4QxQ6yLRUHKzn7Z/TbzgFprSoQBlKE/hOImBGN5OyPvTINP0AGib9lkoaf+vslQEkZbMtNm9qo59hpqUtFJ72W9DhitOZ8EjhcfEYV978juJWwJ7Q+7d4UrZB9fLnUwksC5Jq7RjGvouwP0aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179516; c=relaxed/simple;
	bh=dIR40E4RFRQnd0tDORg/5BQXAKLJrseam3ccjLF2NOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G13NzUT1PQ8xz0HY2JNTifIg0r9KxoudR6KYkztW8Fuu6wVs4WBMxofPdajNb5j7w46+1GuRCh/ygw5b46b9IUOXCneMwq70cRe0WBYoYzOIspBm1J2Ab6lq9vyRWdzv7Ht/RID+UHsgdb03Ha2Qkp0IYPGSqC2HyYuILqeut1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqTAjfTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqTAjfTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32B8C4CEE3;
	Tue, 17 Jun 2025 16:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179516;
	bh=dIR40E4RFRQnd0tDORg/5BQXAKLJrseam3ccjLF2NOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqTAjfTqMMG/Q2lkoFkipmu9w1pQgDQPC9tJngWSqNq7l6qv7CrT59u3vPfQZzH0J
	 QkkaaGS5fdOjqkvYNnszxCBQypilL+O8BT++6STGYmkQ8v2ys57i8qjFk7ytK0fx7f
	 Z9AKytnEMjf7d8CodbYswiijECLs5z4m2dr+j9mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Subject: [PATCH 6.15 739/780] uapi: bitops: use UAPI-safe variant of BITS_PER_LONG again
Date: Tue, 17 Jun 2025 17:27:27 +0200
Message-ID: <20250617152521.595872826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 11fcf368506d347088e613edf6cd2604d70c454f upstream.

Commit 1e7933a575ed ("uapi: Revert "bitops: avoid integer overflow in GENMASK(_ULL)"")
did not take in account that the usage of BITS_PER_LONG in __GENMASK() was
changed to __BITS_PER_LONG for UAPI-safety in
commit 3c7a8e190bc5 ("uapi: introduce uapi-friendly macros for GENMASK").
BITS_PER_LONG can not be used in UAPI headers as it derives from the kernel
configuration and not from the current compiler invocation.
When building compat userspace code or a compat vDSO its value will be
incorrect.

Switch back to __BITS_PER_LONG.

Fixes: 1e7933a575ed ("uapi: Revert "bitops: avoid integer overflow in GENMASK(_ULL)"")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Yury Norov [NVIDIA] <yury.norov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/bits.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bits.h b/include/uapi/linux/bits.h
index 682b406e1067..a04afef9efca 100644
--- a/include/uapi/linux/bits.h
+++ b/include/uapi/linux/bits.h
@@ -4,9 +4,9 @@
 #ifndef _UAPI_LINUX_BITS_H
 #define _UAPI_LINUX_BITS_H
 
-#define __GENMASK(h, l) (((~_UL(0)) << (l)) & (~_UL(0) >> (BITS_PER_LONG - 1 - (h))))
+#define __GENMASK(h, l) (((~_UL(0)) << (l)) & (~_UL(0) >> (__BITS_PER_LONG - 1 - (h))))
 
-#define __GENMASK_ULL(h, l) (((~_ULL(0)) << (l)) & (~_ULL(0) >> (BITS_PER_LONG_LONG - 1 - (h))))
+#define __GENMASK_ULL(h, l) (((~_ULL(0)) << (l)) & (~_ULL(0) >> (__BITS_PER_LONG_LONG - 1 - (h))))
 
 #define __GENMASK_U128(h, l) \
 	((_BIT128((h)) << 1) - (_BIT128(l)))
-- 
2.49.0



