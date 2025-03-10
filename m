Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CEC233157;
	Mon, 10 Mar 2025 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628971; cv=none; b=ODVy4xd3fIcUf7r6a0pNLfpxI+cQv4A/aMb8R6NPUS9dfyBA6DZRV8ZnwTdkxwpNrk8IXtWpSfrcL89+64/UuTaIiCdhgIEmATNgNdrIuAhFP1Kl5T1ONX1rikxwrXrXTrlcRP3RXMWl7BGkcQd4AN/UVbmwAGK3c2PSMXZ+HcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628971; c=relaxed/simple;
	bh=0a0stI8drrqeP6jbPBDXj6p9yd/QnTCTEebKmqvUdYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6gS/qV7U3iVQIkj3w+02i2GnchXPYlxtQ4ij4qIW/1bcfPoqxydAIHci2zmFKFEil/RjxB2OPPRJDJN1hQ3advoJNfBP4oP0pxJsVZ9jNBGJuN+wK1s0Ku5NhveVH8nkZTVGMRv3qJHQYKYJW8ilLAPW8mOW9R5m5iBSFNoe4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTW/vBEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTW/vBEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76179C4CEE5;
	Mon, 10 Mar 2025 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628970;
	bh=0a0stI8drrqeP6jbPBDXj6p9yd/QnTCTEebKmqvUdYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTW/vBEUeOAG85lyErYgv4/lPI01YZIXjblWLwzHvzgmhgssTgmIwSUrWlyB5ndeK
	 ZOUt7+RjKXgpYULdpPl9Otjep93VlS2euYNHz4SjvbPnmYLi3Shu620MrJTx4SW/Dm
	 PR98OSiTDf56Aq0Ke/hK8veTDyyo5mhQXuBK8p9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Rapoport <rppt@linux.ibm.com>,
	Juergen Gross <jgross@suse.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Shahab Vahedi <Shahab.Vahedi@synopsys.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/620] xen/x86: free_p2m_page: use memblock_free_ptr() to free a virtual pointer
Date: Mon, 10 Mar 2025 17:59:38 +0100
Message-ID: <20250310170550.810748132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit c486514dd40980b2dbb0e15fabddfe1324ed0197 ]

free_p2m_page() wrongly passes a virtual pointer to memblock_free() that
treats it as a physical address.

Call memblock_free_ptr() instead that gets a virtual address to free the
memory.

Link: https://lkml.kernel.org/r/20210930185031.18648-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Shahab Vahedi <Shahab.Vahedi@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 29091a52562b ("of: reserved-memory: Do not make kmemleak ignore freed address")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/p2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 9b3a9fa4a0ade..899590f1f74a5 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -197,7 +197,7 @@ static void * __ref alloc_p2m_page(void)
 static void __ref free_p2m_page(void *p)
 {
 	if (unlikely(!slab_is_available())) {
-		memblock_free((unsigned long)p, PAGE_SIZE);
+		memblock_free_ptr(p, PAGE_SIZE);
 		return;
 	}
 
-- 
2.39.5



