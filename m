Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2605D48EC6C;
	Wed, 23 Sep 2026 14:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173526; cv=none; b=N1VFGFF/kfbHJBsnJeDKEE0XuSSH/MpnJdbGt1bWEn82MdZpq/NdNvAlsZc/hkcStDeNNV2nTZwE2w7nrOft++ZaN1fo6X9Szgg9P+yAEG/s85L499kHyGdahaBI0KRNCERERVxCP2u+4eaDUr8DRiSITOfodOAyR2D0+tmrCFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173526; c=relaxed/simple;
	bh=vbHsr3M8QEJLfIAGVc2Fl7sDCNbLNqHYj0CcSDS78vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQgJmU64Pn5uIyI/ZlvIwnCcYOoV0azVyD6DQtWBIELTW7MtQW7N2T9nzwE9A+YjIp4y5rupFsPEzwsYoLrjJOtBv11WmvvHY3bSfGMHUoSucvZnUFInnSTPzqrR1xdLaWj5b0N393k6vUkWarRCiYiTSVts9toeJhLmRIAmC2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIIEHlBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIIEHlBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506AF1F000FF;
	Wed, 23 Sep 2026 14:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173525;
	bh=ll7WZZcQyN5QsauoV3cBFlyJSu9rg7nkQs38T9uY5po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIIEHlByV7IXZkn9LyHHZg/s+bARpDAv7fW1C6hBP1+5rZ4t6VAZrJM6XGX6uHRYV
	 lwZSu2pXp34lO19bB7zmX89HZ3Sn5OnpOW8oubXvWQruVFIlnZjpZMvCi2lOZqBco7
	 6ReGoVE4nXmYYj0W75coZzVhydv3L376K2E7Vl2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"Christopher Lameter (Ampere)" <cl@gentwo.org>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 7.2 274/438] arm64: percpu: Fix this_cpu_write() casting
Date: Wed, 23 Sep 2026 16:04:55 +0200
Message-ID: <20260923140651.876154421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 885bff055a0f251a51a0d4fd4f0a7b525582a3de upstream.

The arm64 implementation of this_cpu_write() casts 'val' to unsigned
long. This is necessary to handle cases where 'val' is a pointer type,
and to avoid spurious compiler warnings for the (unreachable!) cases
where the pointer type would be cast to a smaller integer type.

Unfortunately, the cast is applied to 'val' rather than '(val)', which
won't always generate the expected value when 'val' is an expression.

For example, for this_cpu_write(pcp, zero - 1), where 'pcp' is a u64 and
'zero' is a u32:

* 'zero'                      ===> (u32) 0x00000000
* 'zero - 1'                  ===> (u32) 0xffffffff
* '(unsigned long)zero - 1'   ===> (u64) 0xffffffffffffffff
* '(unsigned long)(zero - 1)' ===> (u64) 0x00000000ffffffff

Fix this by adding brackets around 'val'.

Fixes: 959bf2fd03b5 ("arm64: percpu: Rewrite per-cpu ops to allow use of LSE atomics")
Reported-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: David Laight <david.laight.linux@gmail.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Acked-by: Christopher Lameter (Ampere) <cl@gentwo.org>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/percpu.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -179,13 +179,13 @@ PERCPU_RET_OP(add, add, ldadd)
 	_pcp_protect_return(__percpu_read_64, pcp)
 
 #define this_cpu_write_1(pcp, val)	\
-	_pcp_protect(__percpu_write_8, pcp, (unsigned long)val)
+	_pcp_protect(__percpu_write_8, pcp, (unsigned long)(val))
 #define this_cpu_write_2(pcp, val)	\
-	_pcp_protect(__percpu_write_16, pcp, (unsigned long)val)
+	_pcp_protect(__percpu_write_16, pcp, (unsigned long)(val))
 #define this_cpu_write_4(pcp, val)	\
-	_pcp_protect(__percpu_write_32, pcp, (unsigned long)val)
+	_pcp_protect(__percpu_write_32, pcp, (unsigned long)(val))
 #define this_cpu_write_8(pcp, val)	\
-	_pcp_protect(__percpu_write_64, pcp, (unsigned long)val)
+	_pcp_protect(__percpu_write_64, pcp, (unsigned long)(val))
 
 #define this_cpu_add_1(pcp, val)	\
 	_pcp_protect(__percpu_add_case_8, pcp, val)


