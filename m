Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E00A1465AE;
	Thu, 13 Jun 2024 11:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279237; cv=none; b=aD/diyeyvbPhmOsE+J6Jehsr4i9qmLIdiw23FA0v/HBmvOyYSQr8B4QXflucZRVEiTi3GNb4hg8bgTOC3Fg/gdsypM7XQ5qFzDkBLmewgurGm+q9+bjvX9hvDeOuJEpQrTEqmCzVg7jOW4HtxnLH5D1fHCsERBZdhTxjYFG3uew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279237; c=relaxed/simple;
	bh=LtQdrsVPDF/L5PvAx8iNMAbrCxf9qDkr8Y2ndfR2JtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmX9tuB3W2vexdsS44GB94RIyh2oGMvA0CT+qzwSIJEIAsd0SDLctdufCsOnZwJQ6wLzX/7WnkBvVnOFEtevAzzwPwnGivNHLskgVgAIIV41CvgvX/oN0TTfXCssGzxolmgF52mwf5nqK2TO306U/mJcMMzAaTw4EbjVl8CL/As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOFs8sFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOFs8sFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465E9C4AF1A;
	Thu, 13 Jun 2024 11:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279236;
	bh=LtQdrsVPDF/L5PvAx8iNMAbrCxf9qDkr8Y2ndfR2JtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOFs8sFPFJypiSN0gHwI1B+qiaS4cQmtEK/DXmCbVZTNPvkUDZYA/tsObrNdMeTwc
	 f3sYnkSKTrK5McekgBuSFcxH9tV3Ry6iJ8+PCPDeVkPfgqFQXUsOhlRTBNPiouEryl
	 Ngj7g9cpO/HnKebe1qWeNNO2FmQ7vRCCo48tZQRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 213/213] nfs: fix undefined behavior in nfs_block_bits()
Date: Thu, 13 Jun 2024 13:34:21 +0200
Message-ID: <20240613113236.200198511@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

commit 3c0a2e0b0ae661457c8505fecc7be5501aa7a715 upstream.

Shifting *signed int* typed constant 1 left by 31 bits causes undefined
behavior. Specify the correct *unsigned long* type by using 1UL instead.

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Cc: stable@vger.kernel.org
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/internal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -615,9 +615,9 @@ unsigned long nfs_block_bits(unsigned lo
 	if ((bsize & (bsize - 1)) || nrbitsp) {
 		unsigned char	nrbits;
 
-		for (nrbits = 31; nrbits && !(bsize & (1 << nrbits)); nrbits--)
+		for (nrbits = 31; nrbits && !(bsize & (1UL << nrbits)); nrbits--)
 			;
-		bsize = 1 << nrbits;
+		bsize = 1UL << nrbits;
 		if (nrbitsp)
 			*nrbitsp = nrbits;
 	}


