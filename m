Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D08D3D8129;
	Mon,  4 May 2026 14:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904334; cv=none; b=dpWUpxP/Y9GNHlUvVvKgJNIaUlqkhYvPNM3VEM7rsz3oul4KARL/5Y8FFuNq5CwFyYjeJXYuiOQejSoObsWt+p3foPTiNGjm2492e9B+MvWz+bL0keqKPrz/s3Rna4iOyvwzlm9moPvqgk6HPnvq3+Y+4B1E9gaaNbgsWN9YvzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904334; c=relaxed/simple;
	bh=NAn6CxfUu5iu2xH9FVnhqkGk+LpeU4Ih2gUEsbPRonU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=essTJCWXbXdYbh9Y0A+dj53lOaumYBUDSXs3wOWlX58ze4zOdFxhEo8KkhVOYPIIAME+qrl93+MyHp+sy28AEIfhbeSSNKpjCLrYBZyOk5ZHIz7uxV2pmEOSjbdw/j5NNIKkR4NgJk28nXWnip4XxCV34yuBOsojhmXSwV+oLP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfT38rcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfT38rcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86BAC2BCB8;
	Mon,  4 May 2026 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904334;
	bh=NAn6CxfUu5iu2xH9FVnhqkGk+LpeU4Ih2gUEsbPRonU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfT38rcMNJzDWWPqLV0XB79fdhgXt6PyJZknPs1IIClK6mF4MkFpUiPGVi8huJZXX
	 J7fdM3lSVtWrF/je4AwJzhadMJqP/U8KqPQMHk4+KNK8cgZEIv2ZhvkZy4pZc+zEJ4
	 kd0ILjtNnIvBjNGaIePMIHCudzGS8hoYrpo71J+g=
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
Subject: [PATCH 6.18 275/275] netfilter: reject zero shift in nft_bitwise
Date: Mon,  4 May 2026 15:53:35 +0200
Message-ID: <20260504135153.244626992@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -196,7 +196,8 @@ static int nft_bitwise_init_shift(struct
 	if (err < 0)
 		return err;
 
-	if (priv->data.data[0] >= BITS_PER_TYPE(u32)) {
+	if (!priv->data.data[0] ||
+	    priv->data.data[0] >= BITS_PER_TYPE(u32)) {
 		nft_data_release(&priv->data, desc.type);
 		return -EINVAL;
 	}


