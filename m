Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C256420EE;
	Tue, 23 Jan 2024 00:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968236; cv=none; b=RerZdh90wWLDTKqubIhAMSwakZKzw5nFw/deb6yozQRS0oyBQWsBWNgQUWZEHZGPpaak2dgsbUc93vQ0kEYd2hOwy00gMRBEixK9omVXdtpVjDx2F4795vCEg9zrGG2teZCH2Mcsclxw+1Z/TQuSL+3y8/Or4uF6GtKTwCjjP/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968236; c=relaxed/simple;
	bh=WeCPLbTLUZbTUFDHHOFk+iCUmOm7rEz6pqXac4Y7TeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXTOmkGC1EoBNQjap1Luep0Y1g7s9LBLFl2ZHrFUBQ3G0j7vUHljrXXXmsUGHNOvaS7egIubvCyqWshix6QcY9lVfP0w1N10H/P5s7vcEKsAvQkyAEmRXeUTngBF4CA1BorCjUFKSP1/m1y7ccnqiqeLu+qHkrup41y/TdP4j7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CavrUtqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CavrUtqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007F8C433C7;
	Tue, 23 Jan 2024 00:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968236;
	bh=WeCPLbTLUZbTUFDHHOFk+iCUmOm7rEz6pqXac4Y7TeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CavrUtqHsLYBQtg+sm3PoKBdPzg9gfdDnLm1ueTuUqOMW+/wsdhGbjJpTfYKSI5N8
	 vNrjCnlwjFr/AEZNdsaW0eFWZB6kucbphL7hccV9FhBFqrug4FSyz1RueUsPUSesKF
	 rbORBOsjrwMBItjb1A74XpEYqXqv5a8Ln4LgbZrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/148] pstore: ram_core: fix possible overflow in persistent_ram_init_ecc()
Date: Mon, 22 Jan 2024 15:56:48 -0800
Message-ID: <20240122235714.526907705@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 86222a8fc16ec517de8da2604d904c9df3a08e5d ]

In persistent_ram_init_ecc(), on 64-bit arches DIV_ROUND_UP() will return
64-bit value since persistent_ram_zone::buffer_size has type size_t which
is derived from the 64-bit *unsigned long*, while the ecc_blocks variable
this value gets assigned to has (always 32-bit) *int* type.  Even if that
value fits into *int* type, an overflow is still possible when calculating
the size_t typed ecc_total variable further below since there's no cast to
any 64-bit type before multiplication.  Declaring the ecc_blocks variable
as *size_t* should fix this mess...

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Fixes: 9cc05ad97c57 ("staging: android: persistent_ram: refactor ecc support")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20231105202936.25694-1-s.shtylyov@omp.ru
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index efb765b8466f..a6e5022469ab 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -189,7 +189,7 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
 {
 	int numerr;
 	struct persistent_ram_buffer *buffer = prz->buffer;
-	int ecc_blocks;
+	size_t ecc_blocks;
 	size_t ecc_total;
 
 	if (!ecc_info || !ecc_info->ecc_size)
-- 
2.43.0



