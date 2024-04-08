Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EE68173C;
	Mon,  8 Apr 2024 13:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582656; cv=none; b=hXh8ydIuBwPkb4hgCUct0IgKTmkyieqdPLArYBiqdm8fH3VT06KlGV3uAG8Loy+JcX8yq+zgn/GWCBXxvkMwmtpcGxwsIHJOFhYSTNPR7vIcrMpPiZdta0ecX4A1/5c0Pph6W+u1+3ATJfBQrZxRL3uG5AgO16cNxRY23125qlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582656; c=relaxed/simple;
	bh=oF6qLilZ7fNq5kz7mQdiD+mUTKthRzS2abUEuQsM8vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seVn1lQTPWJdVCzoSrM2nRBDWSEAD6VwIY4RXtLElMVSZ+fNXTcCsdAYUtqX5m3/pvb5+LXqchTGpZbmDIG6qTXbOa0YqGTByT0TPxc/MpHEel4F/tu6/XZL89iMAurCI4n/pFuvR9cS/RZf3XIs9LjlDM8gU1G8r99G9b37HrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f00X1KWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f00X1KWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45277C433C7;
	Mon,  8 Apr 2024 13:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582655;
	bh=oF6qLilZ7fNq5kz7mQdiD+mUTKthRzS2abUEuQsM8vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f00X1KWHWCGLsX/e4GfKEzFJBHGcD1NfYvDspCjjJB4EZT9QxOQ5/NADayUJyYXNa
	 H6p4NjGVXnoJJaIXM9ygTiJqKdkQ36NXg3ARRyttsyz4pAP/5MYIBPYaXI8z0kyN7m
	 Yhsn1+8TiGSbOQidq3QNczJftEqOsttQmkxSUy+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 123/138] riscv: Fix spurious errors from __get/put_kernel_nofault
Date: Mon,  8 Apr 2024 14:58:57 +0200
Message-ID: <20240408125300.059167913@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

commit d080a08b06b6266cc3e0e86c5acfd80db937cb6b upstream.

These macros did not initialize __kr_err, so they could fail even if
the access did not fault.

Cc: stable@vger.kernel.org
Fixes: d464118cdc41 ("riscv: implement __get_kernel_nofault and __put_user_nofault")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20240312022030.320789-1-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/uaccess.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -319,7 +319,7 @@ unsigned long __must_check clear_user(vo
 
 #define __get_kernel_nofault(dst, src, type, err_label)			\
 do {									\
-	long __kr_err;							\
+	long __kr_err = 0;						\
 									\
 	__get_user_nocheck(*((type *)(dst)), (type *)(src), __kr_err);	\
 	if (unlikely(__kr_err))						\
@@ -328,7 +328,7 @@ do {									\
 
 #define __put_kernel_nofault(dst, src, type, err_label)			\
 do {									\
-	long __kr_err;							\
+	long __kr_err = 0;						\
 									\
 	__put_user_nocheck(*((type *)(src)), (type *)(dst), __kr_err);	\
 	if (unlikely(__kr_err))						\


