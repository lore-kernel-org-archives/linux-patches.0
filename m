Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBD14F85C5;
	Wed, 30 Sep 2026 15:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783521; cv=none; b=TpDzEjt8nHzhN0yGwxlOe2jvpLisR3MvgyHZBimW5/KRogYSQ2L4BNfQyV49wmvVvuwLm+1tvJsVmjReMhwbc25WflUu3Qpd0L7Tl8oLId97dBcWJCrVE0cGC58fh7UiWyNpuT1QSi57Kuv+DOn4qbnsHfC6M9AsDlhaF+W9blU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783521; c=relaxed/simple;
	bh=RH4SzKWwuN2NU4YpnxAVtRtcwpLT06wrVz+Zl808pKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbdWJG3drxdN/rU/DE//g2nfhwa5cexXUD2HquKsm9YcgVd7rKXWGXoLJgr9DNEFRzBFlAVpXdDEVD0Ov32mjmNyHaOndzr/F/953yQvVjm7C4DGLOZfIaT5tNbCan8Fv/2vbcLu0WNEBqLzcDh98M6/B7J0WI/zrU5xxNzwqe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRlTKKhv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRlTKKhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6521F000FF;
	Wed, 30 Sep 2026 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783517;
	bh=VyLMZmXboj3IJfTmPQq+ZWpi3o6djB1Q1Zi/ulzCfR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRlTKKhvFnUWYl7N+YclrPa48GZter5kJdTBGo/n1kAAWg/6u8n3PA7o5ZocePmdP
	 zVtKOKzaIQCdciZzvI8KJ4ksuIWQRNdtcNtMJ8jirMY2DCxwW3/5twgqhH0M8at0qz
	 b2tnnmuEWYCEV19bqRuJFjS6syIkZIoeXH9zOjkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
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
	Yang Shi <yang@os.amperecomputing.com>
Subject: [PATCH 5.10 427/595] arm64: percpu: Fix this_cpu_and() mask generation
Date: Wed, 30 Sep 2026 17:25:20 +0200
Message-ID: <20260930152356.865684008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 44274c657256b4911de82f8104e9e22f054cf742 upstream.

The arm64 implementation of this_cpu_and(pcp, val) is built in terms of
ANDNOT operations, which requires the 'val' argument to be bitwise
negated. The bitwise negation is not implemented correctly, with two
bugs described below.

(1) The bitwise negation is performed as '~val' rather than '~(val)'.
    This won't always generate the expected value when 'val' is an
    expression.

    For example, for this_cpu_and(pcp, 1 - 1):

    * 'val'    is  '1 - 1'   ===> (int) 0x00000000
    * '~val'   is '~1 - 1'   ===> (int) 0xfffffffd
    * '~(val)' is '~(1 - 1)' ===> (int) 0xffffffff

    ... and thus bit[1] of 'pcp' would be preserved unexpectedly by the
    ANDNOT operation.

(2) The bitwise negation is performed on 'val' before it has been cast
    to (at least) the width of 'pcp'. This won't always generate the
    expected value for the upper bits.

    For example, for this_cpu_and(pcp, zero), where 'pcp' is a u64 and
    'zero' is a u32:

    * 'zero'           ===> (u32) 0x00000000
    * '~(zero)'        ===> (u32) 0xffffffff
    * '(u64)~(zero)'   ===> (u64) 0x00000000ffffffff
    * '~((u64)(zero))' ===> (u64) 0xffffffffffffffff

    ... and thus bits[63:32] of 'pcp' would be preserved unexpectedly by
    the ANDNOT operation.

Fix these issues by adding brackets around 'val', and by casting 'val'
to an appropriately-sized type before bitwise negation.

Fixes: 959bf2fd03b5 ("arm64: percpu: Rewrite per-cpu ops to allow use of LSE atomics")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
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
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/percpu.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -204,13 +204,13 @@ PERCPU_RET_OP(add, add, ldadd)
 	_pcp_protect_return(__percpu_add_return_case_64, pcp, val)
 
 #define this_cpu_and_1(pcp, val)	\
-	_pcp_protect(__percpu_andnot_case_8, pcp, ~val)
+	_pcp_protect(__percpu_andnot_case_8, pcp, ~(u8)(val))
 #define this_cpu_and_2(pcp, val)	\
-	_pcp_protect(__percpu_andnot_case_16, pcp, ~val)
+	_pcp_protect(__percpu_andnot_case_16, pcp, ~(u16)(val))
 #define this_cpu_and_4(pcp, val)	\
-	_pcp_protect(__percpu_andnot_case_32, pcp, ~val)
+	_pcp_protect(__percpu_andnot_case_32, pcp, ~(u32)(val))
 #define this_cpu_and_8(pcp, val)	\
-	_pcp_protect(__percpu_andnot_case_64, pcp, ~val)
+	_pcp_protect(__percpu_andnot_case_64, pcp, ~(u64)(val))
 
 #define this_cpu_or_1(pcp, val)		\
 	_pcp_protect(__percpu_or_case_8, pcp, val)


