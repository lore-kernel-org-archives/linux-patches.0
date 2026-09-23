Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7180353E315;
	Wed, 23 Sep 2026 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174804; cv=none; b=olgfRo+Ky5s8mFM2cag+oHXyR1rDczn2FGWXkQVixXhPJKIVyHswUzb+jJKcPaYOqHgh2uA0T4WL55gQOK3WQXfKUyLiS4SRn1QUEoR606rHFEwFO7UmSpsCFoJxPBLTKk1L/sLFh7su9Ykwj5t9Wvh6Qzq+N+0dl1WoLHx300E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174804; c=relaxed/simple;
	bh=pRKWOon/i5pvImNQx3gCmFSSsman4n/hGLBJxuPl3KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLEmkV+U/gDl3/qEcei5/CHFxuJcMRiFxjBzey6yOLGRzYqwnbqyQb9w+zRwWvd1htseS9AfZNDIdZ1anuyPLETjC/qL0nw7RiOw3pmkM0ilmKae5GfALj5tnJPNlzdnL5qx+9kuzm6YvcLeFPvvQM8kzEaZa4BB1cvOjgxktO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmzL9Fh1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmzL9Fh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3C61F000FF;
	Wed, 23 Sep 2026 14:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174803;
	bh=6hjoaK0jV9bMUr7iZvEuAoZOjYMNUtTRCjsXPQhuJEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmzL9Fh1BvzFzNDwke5IL7BzoTJrWVSuX4xUM5zuoFn843ca7srpoTTUlBAN4L+lI
	 wx9jIpmiHcy+REhqZ69zOiymBUsNQz7Dz53XLc6hEz2tbm5zmpnmn6u1pgzoLlvXFr
	 h5pzUOVNyMf5iYsDGXmqziZ1MJNWgqaArBvhG6k0=
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
Subject: [PATCH 6.18 231/398] arm64: percpu: Fix this_cpu_and() mask generation
Date: Wed, 23 Sep 2026 16:05:05 +0200
Message-ID: <20260923140649.406517596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -206,13 +206,13 @@ PERCPU_RET_OP(add, add, ldadd)
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


