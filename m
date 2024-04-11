Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE9B134CC2;
	Thu, 11 Apr 2024 10:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832121; cv=none; b=npBO3IZliV2oIxlLNbb+o6eQj0pqGNTprnzk/BLQEs1SJ8rjPvMpT6tICTgd1Mc2qGbVQp7rxGn8O7ioD/EnbwY5JxAx/PLnbOybuDoIuwo5zpwfHIPX6SRFU5BUWV9OdTZXMfmGVl5Ra/SBNsODN8Nz0sHjlIiUQuuM5DoWKXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832121; c=relaxed/simple;
	bh=vg111jf8dj9+kW0acMQaCJhgnBLSpOwh00bvaOfiwTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3w0fa3ZO4eWJMgZxtTMXZjV0Cq2+GLpPjeANyN4jFaAt3vdQ+rkgr+2cjsnZGhv/Ck2nE/nDAoZJ4C4qDX4O3nAJzNz0K4sCk8pp4gptubpgIaVxDjfkHqYvisjj96M57x9xbsEOzU3eWqprSIn8FfQ6pHHmOjQuJhRr2jU63w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+HX2ay7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+HX2ay7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25156C433C7;
	Thu, 11 Apr 2024 10:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832121;
	bh=vg111jf8dj9+kW0acMQaCJhgnBLSpOwh00bvaOfiwTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+HX2ay7qskOBzIjjopFO02H+aJ7tG5O/3KHy7h/Rp0DvZMndd0jOBA0irujhSSOB
	 js6XcdVFCcvR1cxZeW/GXaGDKh8CrBdMPuXy0UspNPiLeSAdieNH/Yq+2LwfWsIT+K
	 LQnN81bDgaDPhLjcdAMbsGi0qoPMNe4EOVvRN4og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.10 237/294] riscv: Fix spurious errors from __get/put_kernel_nofault
Date: Thu, 11 Apr 2024 11:56:40 +0200
Message-ID: <20240411095442.712245344@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -468,7 +468,7 @@ unsigned long __must_check clear_user(vo
 
 #define __get_kernel_nofault(dst, src, type, err_label)			\
 do {									\
-	long __kr_err;							\
+	long __kr_err = 0;						\
 									\
 	__get_user_nocheck(*((type *)(dst)), (type *)(src), __kr_err);	\
 	if (unlikely(__kr_err))						\
@@ -477,7 +477,7 @@ do {									\
 
 #define __put_kernel_nofault(dst, src, type, err_label)			\
 do {									\
-	long __kr_err;							\
+	long __kr_err = 0;						\
 									\
 	__put_user_nocheck(*((type *)(src)), (type *)(dst), __kr_err);	\
 	if (unlikely(__kr_err))						\


