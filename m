Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A64462A0D;
	Tue, 23 Jan 2024 00:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971121; cv=none; b=ePqdclmDB4Ovh9ps8+bbNCMBetc+0KXR2ju14VkHEAO+1xI80RXi6/guYdqdN9ULJkWL46PdoqOx+/2u2166rAQROvDcvDZjPTkkoaYU5rg4ne9U8pn8YVSHDGKrZmF7MxUu3Dfy840pPU08IOmMOdvx1LP8ojE+hG26O6A7QLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971121; c=relaxed/simple;
	bh=+0oHt1DOldmgmSlkGfnEuFkresg8Me9ny/jkth/sisE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5J0JWqsLFPC5b9S04kb5ECoGhkG6FE7xRt3THrLW/Sc7HfoG9mmbUu8q0px86TFIFp62xkuhrt61qwJYjokWwDz5eiAHwLP6iO6xYXjKVCDg32jJfvbHNp1GCWZ1RbDS9gZ3zctX00qj/IxK782WXKLPT9MlqGJq0xFVD96ilY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7I9BaLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7I9BaLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D73C433A6;
	Tue, 23 Jan 2024 00:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971121;
	bh=+0oHt1DOldmgmSlkGfnEuFkresg8Me9ny/jkth/sisE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7I9BaLGa8VXnMl3UXRez5J0wCf764I9+pKNluuKynqgBMGefSwJVj2/2pSEukPkd
	 n/qTJFYScxmmeKlkqnKr9E0Vefl3WMbSdBKMBu8eba8cZcCkqwh5kAfHVmz7CLfoux
	 LhsR2fk5ZGTICBMCuBWYpfi5LN6ZMGaSOFBbQNlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/286] pstore: ram_core: fix possible overflow in persistent_ram_init_ecc()
Date: Mon, 22 Jan 2024 15:56:38 -0800
Message-ID: <20240122235735.586389180@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a0fa3820ef2a..5ac9b1f155a8 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -190,7 +190,7 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
 {
 	int numerr;
 	struct persistent_ram_buffer *buffer = prz->buffer;
-	int ecc_blocks;
+	size_t ecc_blocks;
 	size_t ecc_total;
 
 	if (!ecc_info || !ecc_info->ecc_size)
-- 
2.43.0



