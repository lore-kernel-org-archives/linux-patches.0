Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70201C6FFE;
	Wed,  5 Mar 2025 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197477; cv=none; b=p/PltDaYeW4c0B2eSS4BQnbGD+AwIRZgSXJHeOHRwjrEddXu3V3PS5DvcjH8NiIjbiDjj32190RRrahtO2JpDdrsovAdAWfWtE2STtGcMDcNqWxZf2P78+zlxiCGmtRXUB0AQvVIwHDayz1Zzl3DQKEnyfmE0cNIrUrtVluc6o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197477; c=relaxed/simple;
	bh=TAKHXbw5nCMNwNWFtBwCvnZd9hLg9RvA/l2YuEUTVe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HYqWl9uNDQG7PpmAO3e9zCJSI4/Nwh6fOO6YckxyeJftwgJA4aacrmSMouWIPbPL1TSrs1VvcIgNIAtFJzIgv3MxhZA9GJB3gM+OqroIoz4XEbis0stXt4ciPb5h7GkdMtTHPd/MASH6YTJw7J+3/8ocA5MZvsH8ZWMd2iIKhq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLv6ruT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLv6ruT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD6FC4CED1;
	Wed,  5 Mar 2025 17:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197476;
	bh=TAKHXbw5nCMNwNWFtBwCvnZd9hLg9RvA/l2YuEUTVe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLv6ruT/vy7IA5wViX0vaQZmx5YnlodfoHnXQ5o+EL6r/SEBQWZi8l+FKPo4u+Ho5
	 EuG4bQYk3bQmEmHrU5//gU/CmgbEQvJp3zhFmjc4tS1quEsFcqceFDX6aZQ7iMVOzu
	 zdFvdQhLrDcWjuCLQ/WEC2FU3WNZrH4kzSxzTg2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@suse.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 168/176] riscv/futex: sign extend compare value in atomic cmpxchg
Date: Wed,  5 Mar 2025 18:48:57 +0100
Message-ID: <20250305174512.185043929@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Schwab <schwab@suse.de>

commit 599c44cd21f4967774e0acf58f734009be4aea9a upstream.

Make sure the compare value in the lr/sc loop is sign extended to match
what lr.w does.  Fortunately, due to the compiler keeping the register
contents sign extended anyway the lack of the explicit extension didn't
result in wrong code so far, but this cannot be relied upon.

Fixes: b90edb33010b ("RISC-V: Add futex support.")
Signed-off-by: Andreas Schwab <schwab@suse.de>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/mvmfrkv2vhz.fsf@suse.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/futex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/futex.h
+++ b/arch/riscv/include/asm/futex.h
@@ -93,7 +93,7 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 		_ASM_EXTABLE_UACCESS_ERR(1b, 3b, %[r])	\
 		_ASM_EXTABLE_UACCESS_ERR(2b, 3b, %[r])	\
 	: [r] "+r" (ret), [v] "=&r" (val), [u] "+m" (*uaddr), [t] "=&r" (tmp)
-	: [ov] "Jr" (oldval), [nv] "Jr" (newval)
+	: [ov] "Jr" ((long)(int)oldval), [nv] "Jr" (newval)
 	: "memory");
 	__disable_user_access();
 


