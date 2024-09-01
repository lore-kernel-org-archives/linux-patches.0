Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4B117C;
	Sun,  1 Sep 2024 17:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210140; cv=none; b=kUD+nRbGhc7wjmUvJ4UZ2HD/TfrG9WK94oo7ss29lNFojD+QPXz/7ZqKOB0fKK4nllyTF+FGm3sK5Ff7NqiB+X6AT3HnZuwU73hMaVtnkd/AX0TpE9/Q7x2xAzwcGGb4o3GK102I+LyyozKd6XZ1jyIKRbQvu8ytVr6osu435fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210140; c=relaxed/simple;
	bh=i5g/e4GbwXjA835JjQHHYOxbjJ3c+Kh70pCVBhQt6u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ar4ky/qsfccWPaLGi5bSqHB58H6g5iaoNN+EVdzYgp8uGAASisUNVcS3tHCaFi6WUicbiiWIKxcRib9nmQg6T6Tv/r52OZ8o0wtUfhbTyhcemDyvqLP20ijjWRdW0kOjrQcC+pXKKdIAcecNTITfrXRm4L7ObKAttbJ0ED1J9YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnYd5MSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnYd5MSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C07BC4CEC3;
	Sun,  1 Sep 2024 17:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210139;
	bh=i5g/e4GbwXjA835JjQHHYOxbjJ3c+Kh70pCVBhQt6u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnYd5MSHKnCsD3C+3NahBECsoapvqthPWTzmoj1oBX19YjH+0NpWv+NOQfk9FbEOb
	 fjMQQvkeH4yHu0xM8E4QTPkiD5hHMweGA21goyWENlYOaplOmW94aXdDdOUcF6aPGk
	 qbTIx3EoKS1C/B2QYPan/mJ0rEQ2grY+BMTI5bgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/215] s390/iucv: fix receive buffer virtual vs physical address confusion
Date: Sun,  1 Sep 2024 18:16:51 +0200
Message-ID: <20240901160827.093050238@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 4e8477aeb46dfe74e829c06ea588dd00ba20c8cc ]

Fix IUCV_IPBUFLST-type buffers virtual vs physical address confusion.
This does not fix a bug since virtual and physical address spaces are
currently the same.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/iucv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 30fc78236050a..1a88ed72a7a97 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -1090,8 +1090,7 @@ static int iucv_message_receive_iprmdata(struct iucv_path *path,
 		size = (size < 8) ? size : 8;
 		for (array = buffer; size > 0; array++) {
 			copy = min_t(size_t, size, array->length);
-			memcpy((u8 *)(addr_t) array->address,
-				rmmsg, copy);
+			memcpy(phys_to_virt(array->address), rmmsg, copy);
 			rmmsg += copy;
 			size -= copy;
 		}
-- 
2.43.0



