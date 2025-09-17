Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2F02FBDE4;
	Wed, 17 Sep 2025 12:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112713; cv=none; b=W1mIvSuf+qwG3XQxoXWoaTQ4lHsiwRO8a7h1fSgoAC/JG0zf3wY1VTFpXLL2shR6/OtSWq+LHQ4IHjSt3fTJkra50tN89iAAPCevzO+qmIzRFyAm5ZhTg1wVqivpj8iVUH/f2MjnvmgKcqquyKUMl0Y/dvKdxdGK5Texux6bXOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112713; c=relaxed/simple;
	bh=6HFOFLwnMPyve/Bqce1nomrO1cFtlmeCBoKJoYhUcvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAlufPpDjYk0cybFfoycXxEfAg9BOmkL4SnUO60kqVPjk4vhIiZn5jsv+x5xmQZAmTgIUH5lOgXrxacTLNE4io4VTYK/nwj/tsUzKI3hZC72hfoJElaid2cOCrwag6atNMsnGR7FUSuJuvzJ/tmZbIRG94hBdzdJRHtb/tszZs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErWnr0tp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErWnr0tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEA3C4CEF0;
	Wed, 17 Sep 2025 12:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112713;
	bh=6HFOFLwnMPyve/Bqce1nomrO1cFtlmeCBoKJoYhUcvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErWnr0tpi+qmuXNaFK6YfMwNsLwkxnc4TlVkIfR4YMNpt7P5tsKq0J46H3DkkBAyP
	 lcCOmH0DtVBX7Jyy4Xoo57h4Co1Jb8UAlON5izOFHL+Yuk0NDaM2Aul05NYU+UtjTj
	 USZ5zKGxFINEr2gDDj7Kz6qDjtIkyi7N9LepLjfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Baoquan He <bhe@redhat.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Coiby Xu <coxu@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 052/189] arm64: kexec: initialize kexec_buf struct in load_other_segments()
Date: Wed, 17 Sep 2025 14:32:42 +0200
Message-ID: <20250917123353.136356975@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 04d3cd43700a2d0fe4bfb1012a8ec7f2e34a3507 upstream.

Patch series "kexec: Fix invalid field access".

The kexec_buf structure was previously declared without initialization.
commit bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
added a field that is always read but not consistently populated by all
architectures.  This un-initialized field will contain garbage.

This is also triggering a UBSAN warning when the uninitialized data was
accessed:

	------------[ cut here ]------------
	UBSAN: invalid-load in ./include/linux/kexec.h:210:10
	load of value 252 is not a valid value for type '_Bool'

Zero-initializing kexec_buf at declaration ensures all fields are cleanly
set, preventing future instances of uninitialized memory being used.

An initial fix was already landed for arm64[0], and this patchset fixes
the problem on the remaining arm64 code and on riscv, as raised by Mark.

Discussions about this problem could be found at[1][2].


This patch (of 3):

The kexec_buf structure was previously declared without initialization.
commit bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
added a field that is always read but not consistently populated by all
architectures. This un-initialized field will contain garbage.

This is also triggering a UBSAN warning when the uninitialized data was
accessed:

	------------[ cut here ]------------
	UBSAN: invalid-load in ./include/linux/kexec.h:210:10
	load of value 252 is not a valid value for type '_Bool'

Zero-initializing kexec_buf at declaration ensures all fields are
cleanly set, preventing future instances of uninitialized memory being
used.

Link: https://lkml.kernel.org/r/20250827-kbuf_all-v1-0-1df9882bb01a@debian.org
Link: https://lkml.kernel.org/r/20250827-kbuf_all-v1-1-1df9882bb01a@debian.org
Link: https://lore.kernel.org/all/20250826180742.f2471131255ec1c43683ea07@linux-foundation.org/ [0]
Link: https://lore.kernel.org/all/oninomspajhxp4omtdapxnckxydbk2nzmrix7rggmpukpnzadw@c67o7njgdgm3/ [1]
Link: https://lore.kernel.org/all/20250826-akpm-v1-1-3c831f0e3799@debian.org/ [2]
Fixes: bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/machine_kexec_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index af1ca875c52c..410060ebd86d 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -94,7 +94,7 @@ int load_other_segments(struct kimage *image,
 			char *initrd, unsigned long initrd_len,
 			char *cmdline)
 {
-	struct kexec_buf kbuf;
+	struct kexec_buf kbuf = {};
 	void *dtb = NULL;
 	unsigned long initrd_load_addr = 0, dtb_len,
 		      orig_segments = image->nr_segments;
-- 
2.51.0



