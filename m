Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DADC1F09AC;
	Fri, 21 Nov 2025 13:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731318; cv=none; b=d7TQRonygucEqJBclnVVrifwdaX/ppka32vR7wNPOb/ftDTKb7WcghBgh9YeCwG1uuScsmstYvLg3UGjLvzygE4mgRclkWOI4QhEbCHd1oLUV96u8iEsA9QHm4rgurBpoc1gL0gzES6WCqwz3BFzsHGVOCqRGYVckSQG0KtGP9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731318; c=relaxed/simple;
	bh=Yjo9MV1p5ZeZ67AwY9p89DLAjVpYGluUKNWyezrwc4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2grfXAhpiF5ZTB+Nwiw+4Cl1MxjH0wO9fVUnU00F9rWKEjiJ7I3NDIn9KoTzcBsiDHyDqoZqsCaSMNWwA5hiIP8Qo+Wa763JBVYHLC2izAInpJsEeop/rW3jKPSvFBiNsl6xYBd0UTP7s8aZOvyGl9iE8qdCSSMVGVmu1Xz1TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/XVqytt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/XVqytt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FBBC4CEF1;
	Fri, 21 Nov 2025 13:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731318;
	bh=Yjo9MV1p5ZeZ67AwY9p89DLAjVpYGluUKNWyezrwc4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/XVqyttCgA3u/SoLNCRCi4POF3JbZEMVzOkcHaFeLpQPPiTEpbp9qmS8m/712bZm
	 Txp1U2Zv/AMwmLSVOxXnWV2awvtXDY59V2Z4uwKx5An9mneyVc5oVrx+DIdZiDMIqI
	 vGNVHX5D486dtaK+MISrmqU0F7/eYLdEibxaKLJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 167/247] kho: warn and exit when unpreserved page wasnt preserved
Date: Fri, 21 Nov 2025 14:11:54 +0100
Message-ID: <20251121130200.714711845@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav <pratyush@kernel.org>

commit b05addf6f0596edb1f82ab4059438c7ef2d2686d upstream.

Calling __kho_unpreserve() on a pair of (pfn, end_pfn) that wasn't
preserved is a bug.  Currently, if that is done, the physxa or bits can be
NULL.  This results in a soft lockup since a NULL physxa or bits results
in redoing the loop without ever making any progress.

Return when physxa or bits are not found, but WARN first to loudly
indicate invalid behaviour.

Link: https://lkml.kernel.org/r/20251103180235.71409-3-pratyush@kernel.org
Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kexec_handover.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -131,12 +131,12 @@ static void __kho_unpreserve(struct kho_
 		const unsigned long pfn_high = pfn >> order;
 
 		physxa = xa_load(&track->orders, order);
-		if (!physxa)
-			continue;
+		if (WARN_ON_ONCE(!physxa))
+			return;
 
 		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-		if (!bits)
-			continue;
+		if (WARN_ON_ONCE(!bits))
+			return;
 
 		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
 


