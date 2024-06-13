Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A4C17FD;
	Thu, 13 Jun 2024 12:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282799; cv=none; b=qKWLQjrk1VhRKGzPr19sAyNsaoVb5VSE1s870OGbx00S5hlGnx+oSP+074X5UDnCX7AuUuETyXsjgcPfNXd1fkJlnOU12E2DOZFphGxyhz+FZpqt/3dwaytaRK1tI1PBGs3pQGMAfiNsLB+PfLLr8VjLHY88Q1teSNBPI8QUv6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282799; c=relaxed/simple;
	bh=2fP1PbffNpVV7iTyDk0JQZY+xPopjUyez0STC7fLsyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4TRST0z5PfaUd0cKYz97Q/FcMbXK0y607+7hsZ9IRTLsR04xbtnVQWldPPcgifItC+6TTVKoWunn5GS3ugziA42g4CqERdB/ktZBcutV4Qhs/1jqCu/jkotiG/gliE15ViN/8dFADECjintwgHN5EamNoIt/UNR7DrR0eQebLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tf7Zf53D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tf7Zf53D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F172C32786;
	Thu, 13 Jun 2024 12:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282799;
	bh=2fP1PbffNpVV7iTyDk0JQZY+xPopjUyez0STC7fLsyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tf7Zf53Drm+yCYokzQJX9j+gtu33wJBY9mDNyqrJW9x6ml2Vqld7CGWb4Pm99DNzA
	 PznITDoJND86XLbr1Tj4YsEWVQ3qHTHo5YfNGoJubU2AradAjv5fxPmvyOmjGB/fB/
	 fmWlj6h+4KdQpbD9pydtHAvl7oZyD7g/wo0XYbG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 400/402] nfs: fix undefined behavior in nfs_block_bits()
Date: Thu, 13 Jun 2024 13:35:57 +0200
Message-ID: <20240613113317.754711260@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
@@ -653,9 +653,9 @@ unsigned long nfs_block_bits(unsigned lo
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


