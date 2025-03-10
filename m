Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5411222D7A6;
	Mon, 10 Mar 2025 17:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629415; cv=none; b=n1zK3L5TdfjJqXx8RFE+GDsd3b1YjGezVjN8dEo96Vq+opiAuYEZSzrt98XdF3Owf3nYsYwwIlgOPUotaSH8hA4HsFhzBy+x9gfSehVNd9TC7/4A/6RtuYG9es71zdVap91mdY1Inq9dbEo/F75zU9FGChkOnr2LrcMYTETparc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629415; c=relaxed/simple;
	bh=UhryYBSTM8Ixsp3zijJFQENnPnQZwsnePsraAKzXdWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8fCy0xMc/rFIZZICc96oos0Gze9r5XYwCMt+KsP1V0F3OrfJJyXNnM+xnQXNVAyWIVjTJ8YBUJ4Pn3GAxa3bzOkl0taW/vGxyry6f5n8hqpNhR/d/HdTEuG1NHN/xKhJuXLNfFlSQLqFTtCDsMgQ2yRvqOUkC6zAFYOpav8y9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F87sNSiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F87sNSiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62389C4CEF0;
	Mon, 10 Mar 2025 17:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629414;
	bh=UhryYBSTM8Ixsp3zijJFQENnPnQZwsnePsraAKzXdWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F87sNSiF2ZRWGIHCZdl5eZrLpiR6nt6cofEfvgt5ObWvuIjKC65RPSw4WwRGWGZth
	 va8E/qbB/62wnBpZeI5ctQsYqRp1KyFJfocjl7cbxNeCm6N/KuRtAzxgq4A6Fqdg8/
	 3gidsw4f6YI5LfG1YJ5JEixQ1blEnN+Faa39iPAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.15 255/620] s390/futex: Fix FUTEX_OP_ANDN implementation
Date: Mon, 10 Mar 2025 18:01:41 +0100
Message-ID: <20250310170555.690838545@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -43,7 +43,7 @@ static inline int arch_futex_atomic_op_i
 		break;
 	case FUTEX_OP_ANDN:
 		__futex_atomic_op("lr %2,%1\nnr %2,%5\n",
-				  ret, oldval, newval, uaddr, oparg);
+				  ret, oldval, newval, uaddr, ~oparg);
 		break;
 	case FUTEX_OP_XOR:
 		__futex_atomic_op("lr %2,%1\nxr %2,%5\n",


