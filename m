Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B08313AD11;
	Mon,  6 Jan 2025 15:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178797; cv=none; b=YJRAOHz3gHdXAkcB+G+E/EoSTkJIiwSsA+bl90L1DIo3T1BVFKdxPNv//1ajI1XX/jG8Cuu6y9HhwGBi82pjmFwp2kpH5D86VsW1ZLBjb348WNcYEDf4oJqJInoOQIlwITd6lnm33w2bDK9z4KYn2fZWv86Yv6uT392qIgvpznA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178797; c=relaxed/simple;
	bh=OaaTrbdneS0/j5LMCrxwJHPKgLT0yPib1cGn9Ij53rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdAUJYTRdFuJk+NXzyp8Qt02ulJy4uqccdhanBUBmLqPq6fsnF+h1iCUsbvDgrw4Snfb5rJ56StSE+8Kr6OVUMU8V2eK7gM+QuENm5g40SYo9I2cSTax4S/pMkTBoEgaK4G6/NOOLESEtDU6XDWKaRVkgorWQgcO1OYeojcAfH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpqLQppg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpqLQppg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2846C4CED2;
	Mon,  6 Jan 2025 15:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178797;
	bh=OaaTrbdneS0/j5LMCrxwJHPKgLT0yPib1cGn9Ij53rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpqLQppglDj8FQ8pdqmgS4GvaSCIbikSL9bSONBZbaqmKgBmkkLSy+ZnNStk+pmGK
	 PlBycF+hdTbYbFJYslx84TgtzIK8QfCWOZNIsqKLBo7/+AalppurhTF32qbOS2Y2Wy
	 EXhsU0pYoqpC/Ww+B50z07x9TIp801Fpeh0InOjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/168] lib: stackinit: hide never-taken branch from compiler
Date: Mon,  6 Jan 2025 16:16:43 +0100
Message-ID: <20250106151142.051759135@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 5c3793604f91123bf49bc792ce697a0bef4c173c ]

The never-taken branch leads to an invalid bounds condition, which is by
design. To avoid the unwanted warning from the compiler, hide the
variable from the optimizer.

../lib/stackinit_kunit.c: In function 'do_nothing_u16_zero':
../lib/stackinit_kunit.c:51:49: error: array subscript 1 is outside array bounds of 'u16[0]' {aka 'short unsigned int[]'} [-Werror=array-bounds=]
   51 | #define DO_NOTHING_RETURN_SCALAR(ptr)           *(ptr)
      |                                                 ^~~~~~
../lib/stackinit_kunit.c:219:24: note: in expansion of macro 'DO_NOTHING_RETURN_SCALAR'
  219 |                 return DO_NOTHING_RETURN_ ## which(ptr + 1);    \
      |                        ^~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20241117113813.work.735-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_stackinit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/test_stackinit.c b/lib/test_stackinit.c
index a3c74e6a21ff..56653c6a2a61 100644
--- a/lib/test_stackinit.c
+++ b/lib/test_stackinit.c
@@ -259,6 +259,7 @@ static noinline __init int test_ ## name (void)			\
 static noinline __init DO_NOTHING_TYPE_ ## which(var_type)	\
 do_nothing_ ## name(var_type *ptr)				\
 {								\
+	OPTIMIZER_HIDE_VAR(ptr);				\
 	/* Will always be true, but compiler doesn't know. */	\
 	if ((unsigned long)ptr > 0x2)				\
 		return DO_NOTHING_RETURN_ ## which(ptr);	\
-- 
2.39.5



