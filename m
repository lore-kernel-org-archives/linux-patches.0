Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C4326B0BC;
	Thu, 13 Feb 2025 15:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459044; cv=none; b=i+bhgycxstcsC1Ppz9t8QBMIw3RmMwe91BamK2tDTLjjTuvYptkR730iC1fZHleK0/0HZXDnrdk9HV/2rUAOxymcgpcElj/KN7aGoTiMHuBoD1qW4XNBP16OzZJEmsrW1J+kgL5vj3x/hr2hzzDhWnxeW3ZV5Z7plPKO/l8QDrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459044; c=relaxed/simple;
	bh=BbQvZ/4fPHUtvkWE1phcvDEFELAGRwgvUKifKaF+ylk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOo1GBjDLh7FoN2Lo72CBgf42YFOnWGR+wwxVhpglPml7xpmbVe0/+iPMvnKLwwACZK4cC8FegL8WpoJ2vdb820gNw91o3zsW7mkBd73kupbs9GLvXMynXRp5iAiWjCSJIdTGhucbq6O5gVACzpzYh/W29FDEI9eJiwpsvt9KQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAgO5U5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAgO5U5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4EDC4CED1;
	Thu, 13 Feb 2025 15:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459043;
	bh=BbQvZ/4fPHUtvkWE1phcvDEFELAGRwgvUKifKaF+ylk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAgO5U5NMGoJqGp222/4JQaHvbUH17TPwdBFI+tpJkFP8oHo2FHijAqjHEFWq47EM
	 cmeXSqbHNh/guOyR+Th1MdjeowcME0A3XhKJnImqH84/lkywxEMZC0ZDqqWtGTNy7H
	 6ynRdXoaVpy2VuJdxKJrAfAZNXUbP5wwrVMEvbEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.13 152/443] s390/futex: Fix FUTEX_OP_ANDN implementation
Date: Thu, 13 Feb 2025 15:25:17 +0100
Message-ID: <20250213142446.464097611@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit 26701574cee6777f867f89b4a5c667817e1ee0dd upstream.

The futex operation FUTEX_OP_ANDN is supposed to implement

*(int *)UADDR2 &= ~OPARG;

The s390 implementation just implements an AND instead of ANDN.
Add the missing bitwise not operation to oparg to fix this.

This is broken since nearly 19 years, so it looks like user space is
not making use of this operation.

Fixes: 3363fbdd6fb4 ("[PATCH] s390: futex atomic operations")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/futex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/futex.h
+++ b/arch/s390/include/asm/futex.h
@@ -44,7 +44,7 @@ static inline int arch_futex_atomic_op_i
 		break;
 	case FUTEX_OP_ANDN:
 		__futex_atomic_op("lr %2,%1\nnr %2,%5\n",
-				  ret, oldval, newval, uaddr, oparg);
+				  ret, oldval, newval, uaddr, ~oparg);
 		break;
 	case FUTEX_OP_XOR:
 		__futex_atomic_op("lr %2,%1\nxr %2,%5\n",


