Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7D033FE15;
	Sat, 30 May 2026 16:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160216; cv=none; b=ZVqg2FvGWqZfbplDULR9XKoc0/4Ux6yogwpoEcx7tso7zM9p8KonB3Ys3D8r91CvKU5nVmBkRz43c6xCMNVJbDDCHcDeAgY+3ooc6oSbaL+dfoKgvr9vqsfcYMrPdJEJe+UsE8WY/SxQP6HIxeUFRDKvzkA1WUTa5S8FckroJuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160216; c=relaxed/simple;
	bh=M2ORbh6RwDsfv7BSZ8C7gUeM/PO79NjUQxi3CaV6gTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO+xb66oOAhU5mJMi9y924cHnQvI8DaBkFTYfdpFWWS2UFmPuQ7JI9LWqXBMpzp15gcHjJyiahxc07skXclh/mOtYZvgPZJ9XL3tnr1bESBwccbsRcbw0bD6ae2sFm8aTLacaZ5PDU5rMSSw+rf8TXUfPj/VfBGns1DeIkK8izs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qeP2r7Qx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qeP2r7Qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D1C1F00893;
	Sat, 30 May 2026 16:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160215;
	bh=gziK3RsurFOZe4IsUdsEZlq6bkFnbOY8AH8rWZtwN3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qeP2r7Qx/OHBbPN7AgtSWHaHcvFlzX2qrmoJSgUaDb0LaW381IOVsty5k2ug0lah5
	 cSHyPlrHEakA7cSqRK9iEYfX4M1Hk7t7lSzOHG0c8B2AcCcwPC8BQ/pn/SjXTcO3w/
	 lHTiexlKkNDq+dUI4+S4b6FQleJiL44v5/b+B2UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Kai Ma <k4729.23098@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 278/969] netfilter: reject zero shift in nft_bitwise
Date: Sat, 30 May 2026 17:56:42 +0200
Message-ID: <20260530160308.150711930@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Ma <k4729.23098@gmail.com>

commit fe11e5c40817b84abaa5d83bfb6586d8412bfd07 upstream.

Reject zero shift operands for nft_bitwise left and right shift
expressions during initialization.

The carry propagation logic computes the carry from the adjacent 32-bit
word using BITS_PER_TYPE(u32) - shift. A zero shift operand turns this
into a 32-bit shift, which is undefined behaviour.

Reject zero shift operands in the control plane, alongside the existing
check for values greater than or equal to 32, so malformed rules never
reach the packet path.

Fixes: 567d746b55bc ("netfilter: bitwise: add support for shifts.")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Kai Ma <k4729.23098@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_bitwise.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -149,7 +149,8 @@ static int nft_bitwise_init_shift(struct
 	if (err < 0)
 		return err;
 
-	if (priv->data.data[0] >= BITS_PER_TYPE(u32)) {
+	if (!priv->data.data[0] ||
+	    priv->data.data[0] >= BITS_PER_TYPE(u32)) {
 		nft_data_release(&priv->data, desc.type);
 		return -EINVAL;
 	}


