Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1321C860D;
	Wed,  5 Mar 2025 18:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197748; cv=none; b=I6WcBypeTOKNnTVFVYMlpA7aYQwUVa3wAOkQNuvJ+0HOqjPPKh3K9vHtEp7R/gddrk1gcylodtBrw0DTXmRQxgNHK1AhR4pA8McdC9DmmmKZR8rCn8csjjt/T0xs9CmQ7FOhvvJ4qsDpAcYwHsak5naMsPUPKMM+QWxvAqvVizM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197748; c=relaxed/simple;
	bh=AHFiqMt7GxgnQIUXqFETnRcAVGZu5YoQrJ0WdZ3tu68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o1JiDnVGWfZPBKl6VhgjFtrFImKmdRVrutEoImte4c1cpW8xfsHqwGfkRQH4/USU4UN43E9+n9y5suw6/MTOUPmChe2oW3JXBGoXc3VHpCkgg3DWuh09ZG/KmDKxN5nlHmodsQ+e7akOONME7A0OYNYu6rmBjozAUGCeyxCZ0TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKDJjkpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKDJjkpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9803C4CED1;
	Wed,  5 Mar 2025 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197748;
	bh=AHFiqMt7GxgnQIUXqFETnRcAVGZu5YoQrJ0WdZ3tu68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKDJjkpnNS8uneNUuR6FX7VHJE52UKyPAQGwOQR/JdOg3TVJ8R16xzPY6Fm+mS6d1
	 +cKXqDVVZzvgcO2gYlC01DqNl1JhzB3Mb5W3SR3rSoTupBVGTgb0EW+HleUWOPdkAZ
	 qUnk41UMZm9kVJOmhy9cH35O6+MAXJ3VKQvcf4bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schwab <schwab@suse.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 087/142] riscv/futex: sign extend compare value in atomic cmpxchg
Date: Wed,  5 Mar 2025 18:48:26 +0100
Message-ID: <20250305174503.831932797@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


