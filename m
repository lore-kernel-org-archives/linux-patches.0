Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8602612C81F;
	Thu, 13 Jun 2024 11:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279625; cv=none; b=ObYS/LlvuCIp7NJKQ3FI28uHlfADPBagPpyWPg6W2Hwsim7eQ8V4Gh5PTjROdnMTW5QSGNmCU/HRstug8lLsaRXCcGwG23NAzei9KohAXleF8XHyRjWKlT1EnxrGh7Hds0CbH9z+PoloNolyxLCvOztmw83S6VEp0TgS5FqvV6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279625; c=relaxed/simple;
	bh=Lp+i0zuOZYZFkXVdj9bCOX09X77H7weqlPL9Ei30S+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDjtmTiLSTxm7t5J8lBG+8x7SGJYPUWJllFNZn6JgW97AT8Jr4HBF0lPOJmbF5ChtUrDG0r6Ty5OeY8KWzXCNzziIJaF5EfzsXGiqqHNAA4TtnhjGe0fXLZvyslvh9xkOzuwLOiy6q4tzXyMuxpbwjJic93CTZSFri3XRQoEMxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YO2/0ds9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YO2/0ds9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1B2C2BBFC;
	Thu, 13 Jun 2024 11:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279625;
	bh=Lp+i0zuOZYZFkXVdj9bCOX09X77H7weqlPL9Ei30S+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YO2/0ds9VB6xBekBEH4t3+5nugmUTFdzaUO1dGgJzl5SmN+hFp0tmteYhOSHcG7j7
	 gG/vdkhNK+ROaC/CmBcpqoDiSnZ066hC9dz1ePRT5pLqdEqBcFPqwkyNQkib95hFow
	 g31KHrRuBuwNnie2xas3g9iJmowNPQyuBfh3w3ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.9 140/157] nfs: fix undefined behavior in nfs_block_bits()
Date: Thu, 13 Jun 2024 13:34:25 +0200
Message-ID: <20240613113232.819641424@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -710,9 +710,9 @@ unsigned long nfs_block_bits(unsigned lo
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


