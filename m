Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F4024292A;
	Thu, 13 Feb 2025 14:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457529; cv=none; b=pFLqg1H9Of3JLvHPJiFsoMmNkH/UbtqH32Da5zUwgj+hAg95l+K6P6BiAXAFpUJKi8hccdU9QvYrKhryLTYZo6Z8s8tnkUwaE0iZND/viMpwl3r2cu4GzLKzW3CNPnPhUpfdvuCbXkeUoSNvrC5hw3xY44U16VWAIlGHdzu4GjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457529; c=relaxed/simple;
	bh=UqFac7ywRzDomLrFjwAL9Yy2TJ9LSKnUeL1IaxFfFIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKB+4U27mcE61gyf1OTiJb/UIDaVpvCS3QkUiOk4zy4+46DR2zYXjgLFwmGP/qpcgY7IPh4OkibgtGJbZPVYQs3tMtZ5RsQEaWkod4RqnvABxe6FyeY6GeD4PG9v5SqrPAIdWbwi80nXGRWlB6GvFqrbE48PT6bYR/DGBG25QlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FiXjg0jY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FiXjg0jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D6AC4CED1;
	Thu, 13 Feb 2025 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457528;
	bh=UqFac7ywRzDomLrFjwAL9Yy2TJ9LSKnUeL1IaxFfFIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiXjg0jY3tHodgoea4GUJr3/mwq27mP6+mD79IdTyGcTM2ZFSFvm59zvibVP1TkYE
	 r7RhrYdJ+2PCJTRZpmgJ2rNmib87QujFdWU5nIul/tQVJGymXqfMnFugWSE3FAYRDO
	 pwqbldQ0+4N31Fmbq9VDa8vb3p5fJFWkSKlFI0PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.12 138/422] s390/futex: Fix FUTEX_OP_ANDN implementation
Date: Thu, 13 Feb 2025 15:24:47 +0100
Message-ID: <20250213142441.872793809@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


