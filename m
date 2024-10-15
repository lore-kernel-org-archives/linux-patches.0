Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015721D90CD;
	Tue, 15 Oct 2024 11:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992788; cv=none; b=VUdzbao83d7gXKzZ0OLOLh8qyA6AUPC4uXjd2nChh+muzIQKIyPGgJXhxsEfJS6LDfqSboxtVKPLDQDhbpusuxUCAmyLsaBScdBfNdvNjNJXRUFqQ7izrjLdRL31B5TqCXTko9zYsD/5gwiVszjmk0BDqZ57Cm4VNP7SC0yRCUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992788; c=relaxed/simple;
	bh=584j/ISlvHwT8Kuu3wpeXQJ+ySnfMc0qvNAcTFvZwa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdyYS7uC8oYHMU4C5x8EVsb/kWcKfmHrePWknUcMabrPBp3Eal5EvGOdRKmfwkHmO1hhnEr7tlH8I9uRN8t/QWvgnJOESZp1H8XD7MQ2rR6bFBr9UNEptUDIfhFuEXWqtRnJM2Nf2PDUA3GhLAano5ksIPXcMYrcyfIekgU6rZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+d8NcE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+d8NcE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F8AC4CEC6;
	Tue, 15 Oct 2024 11:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992787;
	bh=584j/ISlvHwT8Kuu3wpeXQJ+ySnfMc0qvNAcTFvZwa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+d8NcE23517o6x2i7zB1ZKGstBNBsRXxozCqo+SKL55A77f/wwE3O+jKhlxna5+x
	 fguqCPN9u8PONDXAqPyt6HIfxt7EwIggCTkFEFq7JhBHN+X6VAFwd8bTfYgb3WUHI+
	 BVEFYGONjX4Y71zy/WEvk2Spuf/7gAxNeQ6X7dbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/691] powerpc/8xx: Fix initial memory mapping
Date: Tue, 15 Oct 2024 13:22:05 +0200
Message-ID: <20241015112447.388865098@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit f9f2bff64c2f0dbee57be3d8c2741357ad3d05e6 ]

Commit cf209951fa7f ("powerpc/8xx: Map linear memory with huge pages")
introduced an initial mapping of kernel TEXT using PAGE_KERNEL_TEXT,
but the pages that contain kernel TEXT may also contain kernel RODATA,
and depending on selected debug options PAGE_KERNEL_TEXT may be either
RWX or ROX. RODATA must be writable during init because it also
contains ro_after_init data.

So use PAGE_KERNEL_X instead to be sure it is RWX.

Fixes: cf209951fa7f ("powerpc/8xx: Map linear memory with huge pages")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/dac7a828d8497c4548c91840575a706657baa4f1.1724173828.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/nohash/8xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
index 94efd4fa6e768..3876d1710185d 100644
--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -151,11 +151,11 @@ unsigned long __init mmu_mapin_ram(unsigned long base, unsigned long top)
 
 	mmu_mapin_immr();
 
-	mmu_mapin_ram_chunk(0, boundary, PAGE_KERNEL_TEXT, true);
+	mmu_mapin_ram_chunk(0, boundary, PAGE_KERNEL_X, true);
 	if (debug_pagealloc_enabled_or_kfence()) {
 		top = boundary;
 	} else {
-		mmu_mapin_ram_chunk(boundary, einittext8, PAGE_KERNEL_TEXT, true);
+		mmu_mapin_ram_chunk(boundary, einittext8, PAGE_KERNEL_X, true);
 		mmu_mapin_ram_chunk(einittext8, top, PAGE_KERNEL, true);
 	}
 
-- 
2.43.0



