Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2F77E107;
	Sun,  7 Sep 2025 20:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277951; cv=none; b=sPIN5KnFl+68dhll6Hn46PBEcTrTdmf0E+zmRxl2SMiLORgpkPxacs+Lx3DJTGeO0WXHHaF606sQYWs8Vu1acOFBr5B/0AQEl7F958xF1oq/phdABCB8WCsyZTzTINvmDkIcwFksaoABjyQLpvhiMDO9tWnCmqQg5LBo1wcPHRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277951; c=relaxed/simple;
	bh=P8z9brgNwwa7YNZfpY7o/u6lH6SjlOFxMCKeGoom0bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHuNgE5BmHTTkPbV2nbTCVui5tytOlbql9OwL9oSsojwB/r9GzAKERm1TT4Rys4kWXiFv8Y0Zn6b3dU32AQE2jyoJt3pb/6l0G7r1WELYUkbkB7NGTiQj9Td9f9AroTZJ/wwf2L2cl8b61MlGIy2meZhDAbh2PYlstcv1Z3CQyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bugvkwwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bugvkwwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55133C4CEF0;
	Sun,  7 Sep 2025 20:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277950;
	bh=P8z9brgNwwa7YNZfpY7o/u6lH6SjlOFxMCKeGoom0bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bugvkwwxaQwan8DCaONpHO+xJVTD+Rh9he1BV2NdNe+GSXct4fs+l66Ataa05dcD0
	 Me76MnYXdnUnJmDPqNjjVCAwXUhv+W7JTPcCYOo4cHYAO2B77z3Y+sZJj3cilM/lay
	 sTclKdNGQnFDlBPOxhptNNAXqvI1Bu/pv+ntfH/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.16 175/183] riscv: uaccess: fix __put_user_nocheck for unaligned accesses
Date: Sun,  7 Sep 2025 22:00:02 +0200
Message-ID: <20250907195619.983020734@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

commit 1046791390af6703a5e24718a16f37974adb11db upstream.

The type of the value to write should be determined by the size of the
destination, not by the value itself, which may be a constant. This
aligns the behavior with x86_64, where __typeof__(*(__gu_ptr)) is used
to infer the correct type.

This fixes an issue in put_cmsg, which was only writing 4 out of 8
bytes to the cmsg_len field, causing the glibc tst-socket-timestamp test
to fail.

Fixes: ca1a66cdd685 ("riscv: uaccess: do not do misaligned accesses in get/put_user()")
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250724220853.1969954-1-aurelien@aurel32.net
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index b88a6218b7f2..22e3f52a763d 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -311,7 +311,7 @@ do {								\
 do {								\
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&	\
 	    !IS_ALIGNED((uintptr_t)__gu_ptr, sizeof(*__gu_ptr))) {	\
-		__inttype(x) ___val = (__inttype(x))x;			\
+		__typeof__(*(__gu_ptr)) ___val = (x);		\
 		if (__asm_copy_to_user_sum_enabled(__gu_ptr, &(___val), sizeof(*__gu_ptr))) \
 			goto label;				\
 		break;						\
-- 
2.51.0



