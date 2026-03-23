Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3087B33CE9A;
	Mon, 23 Mar 2026 14:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277039; cv=none; b=ZNypoeWSZvct7Pz0c+lBNL3v9EWGurrSAjQc6GVnSVYMEvuhhjFll8RPc8Npl4w4HgqKsKrgcVHCwFjZrEJI4krhLAmuj3omrQ4oKfqwlrBF1Yi1n+zR0y4Cu2cVOE48YOQbl0Qw6J+oJOeU9fZ+hDlpe+fH+k1JjGuLe39lf4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277039; c=relaxed/simple;
	bh=1UCUmDknkmYjra8FXQ2nB4pFfw+UdedGBoSo4/VHUUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohoNYOXLZzT0562b/HnzLjDHdzFgRepCKbI2RQG4iVIPtYMgWiqUcXeZV+eB1VJfSn2TsWIn/uH1fUz/nOcMBZl50F1pYWeDwxj+D6SdCnQNOKhFHvqmnnGkrWou5dN9FAikKOAhMhbSO/nwJ7VfexOY/OAkTzLshmyWhct+7pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bH9aBSYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bH9aBSYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F3DC4CEF7;
	Mon, 23 Mar 2026 14:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277038;
	bh=1UCUmDknkmYjra8FXQ2nB4pFfw+UdedGBoSo4/VHUUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bH9aBSYq+CTg9f62PJkbW4GtJMldQYRGnWB+W2g8Ae0+hKq2MaasAEEphJtwBEfmU
	 PgX1CMzztFUEJcyTq03IA3w8QJ6v5I946p/vtmmUEnxaPdq2GptjptJUVZVK8Ocbx0
	 Vez5uKKMo499IdhEQUVFC0+R6HfKayeZIWhlPsUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 299/460] s390/stackleak: Fix __stackleak_poison() inline assembly constraint
Date: Mon, 23 Mar 2026 14:44:55 +0100
Message-ID: <20260323134533.829643205@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit 674c5ff0f440a051ebf299d29a4c013133d81a65 upstream.

The __stackleak_poison() inline assembly comes with a "count" operand where
the "d" constraint is used. "count" is used with the exrl instruction and
"d" means that the compiler may allocate any register from 0 to 15.

If the compiler would allocate register 0 then the exrl instruction would
not or the value of "count" into the executed instruction - resulting in a
stackframe which is only partially poisoned.

Use the correct "a" constraint, which excludes register 0 from register
allocation.

Fixes: 2a405f6bb3a5 ("s390/stackleak: provide fast __stackleak_poison() implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20260302133500.1560531-4-hca@linux.ibm.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -168,7 +168,7 @@ static __always_inline void __stackleak_
 		"	j	4f\n"
 		"3:	mvc	8(1,%[addr]),0(%[addr])\n"
 		"4:\n"
-		: [addr] "+&a" (erase_low), [count] "+&d" (count), [tmp] "=&a" (tmp)
+		: [addr] "+&a" (erase_low), [count] "+&a" (count), [tmp] "=&a" (tmp)
 		: [poison] "d" (poison)
 		: "memory", "cc"
 		);


