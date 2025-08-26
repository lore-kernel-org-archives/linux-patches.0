Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BBB749C;
	Tue, 26 Aug 2025 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208942; cv=none; b=fYlZDZZ4Wyn8vjsi92cKZiFB/SIQXmqNrsbrkizn71KPCPuS/oKvNJRTGZJFI0wOkByTMkhoMaVVjkkY6m8C2OkEJBrJemKxPbtdkw0M6adhL92XwAKstjKlkCN5gpg1UdBBfyeXOO9+0WEFMnE7UFehr+kAJIArf7kO6ABcJ5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208942; c=relaxed/simple;
	bh=Pz5CE3T0HKknzblo3MNNpNOtGIPSF8nB5FJFjHif7tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/WwCtxXhpPrhEdnb7jQCxtYC640cgjk0aPSup6eUQO/s/ULZlymi3vbXzb7nEKGLU4+qjkUTs4XwGHEbP8ue2PuVtMPPY8VjVGZGJXxXli4W0miVvjImsJH+pYIw/dOdx7ZkJyujyQzKKj4Xh85fMFsxh4crYhoxVgcTVLaJoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQV1omxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQV1omxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A90C4CEF1;
	Tue, 26 Aug 2025 11:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208942;
	bh=Pz5CE3T0HKknzblo3MNNpNOtGIPSF8nB5FJFjHif7tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQV1omxrwnTQ6dMrvanpvQ8Tt+LYyOeDF+/0O9Qwqc6ivV7QobvMMWd1eJDdBWam0
	 C163iM7RbbKKhREheBuS8rfd7lOLIuUMuO4qSeq1HDxIIohr33izTI2S+xbBtgnenB
	 snFgH8PBw5qkI1X3Cc3bIOJzab4MxQRT9fk7mRoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/322] s390/mm: Do not map lowcore with identity mapping
Date: Tue, 26 Aug 2025 13:11:58 +0200
Message-ID: <20250826110923.374283068@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 93f616ff870a1fb7e84d472cad0af651b18f9f87 ]

Since the identity mapping is pinned to address zero the lowcore is always
also mapped to address zero, this happens regardless of the relocate_lowcore
command line option. If the option is specified the lowcore is mapped
twice, instead of only once.

This means that NULL pointer accesses will succeed instead of causing an
exception (low address protection still applies, but covers only parts).
To fix this never map the first two pages of physical memory with the
identity mapping.

Fixes: 32db401965f1 ("s390/mm: Pin identity mapping base to zero")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/vmem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/boot/vmem.c b/arch/s390/boot/vmem.c
index 3fa28db2fe59..14aee8524021 100644
--- a/arch/s390/boot/vmem.c
+++ b/arch/s390/boot/vmem.c
@@ -471,6 +471,9 @@ void setup_vmem(unsigned long kernel_start, unsigned long kernel_end, unsigned l
 			 lowcore_address + sizeof(struct lowcore),
 			 POPULATE_LOWCORE);
 	for_each_physmem_usable_range(i, &start, &end) {
+		/* Do not map lowcore with identity mapping */
+		if (!start)
+			start = sizeof(struct lowcore);
 		pgtable_populate((unsigned long)__identity_va(start),
 				 (unsigned long)__identity_va(end),
 				 POPULATE_IDENTITY);
-- 
2.50.1



