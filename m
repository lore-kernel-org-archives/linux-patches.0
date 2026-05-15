Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A4F3FF1AD;
	Fri, 15 May 2026 16:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860957; cv=none; b=LD0TW4rYfcKltEndnFyPHOZHQHCbf5RKwoHHbQoasBj+el4wR6FNczNOhTCaKeaCIiAd3CC1p5z+mIrALbGxxgnkANHkK4GCjfbWbEjH428EVagC31zlMXkLHgO66AerhpTu0DGZud1uiGbsCIrQELA6+cjPsXlbzgHIEHt1TPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860957; c=relaxed/simple;
	bh=iYpdFdfHUrnt0cvO0zr8fCU6jm8ts9mTjOX5wU4B7wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoVW1zO0F2Q99Yk81JgDL4GU43hMy3s5tjkcfGCpF0NY3Uf7QVfA3OsjGDSOx2YyjHPJYOcOUhbO4IftDUDNMzUCMsOLYtuW8s2fSCupzWmcmUP48jIlH21Lh+YDBAU8leokPrpSxShOHQqCuyqOtltTIBKOzmXf6XmLEN14i2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McdfXHrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McdfXHrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C1EC2BCB0;
	Fri, 15 May 2026 16:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860957;
	bh=iYpdFdfHUrnt0cvO0zr8fCU6jm8ts9mTjOX5wU4B7wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McdfXHrE1XtH0IlDuYmXwxf5Pi8oir3rtpHu57da5buAGxLjEqlLtlW5Mdphp8ZjC
	 5GGq2enWX+CMxpx4AnS0Ltw2cWmzzzgpd3OPPPrzNC/lWkK9d9RtQ7vFxIptbZ1d0S
	 QvneZtmZCwCtu0ZOUnFtuOlz+CAHrrYhHWBjGmEQ=
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
Subject: [PATCH 6.6 143/474] netfilter: reject zero shift in nft_bitwise
Date: Fri, 15 May 2026 17:44:12 +0200
Message-ID: <20260515154718.121673305@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


