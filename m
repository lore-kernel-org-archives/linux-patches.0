Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFDF1B4F2E;
	Mon, 14 Oct 2024 15:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919133; cv=none; b=A3tUq1++KlIWII9KQPgjwLP/OU4sb9OpT7djpDTeNyZPv+BfDVq36h1/E74dKyBxJZWKG68UAHVuARQb+IYrleO3SqIXheHt+tl5uLVuo3eIPDe8dcSmVti6+XGgbAiCB6Qjnc3mUyiSymXMpWv30QpddZO641rhQFM89m24RRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919133; c=relaxed/simple;
	bh=JJzi76kQFpSMEsq0f6phmJ6FAaNYPHXbYl7J6bgchhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzMjaPNCoMpSH5GufYukbBdkzal4LXZBw4Vm861H3S2MIUn2Sc0FsgI1dEIVE/H0TTipODkhW7rpMCqUNrXqKP88fqy+xedKYyZqeM16tNa2OrrFfSYVAoJwkYjqEaOT5O50LFgddc14bG0yA5UjJrw3MmUlNek/FKbexe8e2Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjCaE4Zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjCaE4Zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA6CC4CEC3;
	Mon, 14 Oct 2024 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919133;
	bh=JJzi76kQFpSMEsq0f6phmJ6FAaNYPHXbYl7J6bgchhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjCaE4ZpzhZoNT6C7wOlIxNLRAYlrzIF5Q3h/NiWsfKYU66keBiWMRLHultV92B4p
	 cNW23UNkWSMJb2lhNyKxX+wn8XzMDljENhSU+fa+JxUBvY1GmVcTbdy4cW+srUW1+f
	 v8Db7740RzwH9M2RBflOdxQfh/wGQnJv1tCUcSoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Jens Remus <jremus@linux.ibm.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 521/798] selftests: vDSO: fix ELF hash table entry size for s390x
Date: Mon, 14 Oct 2024 16:17:55 +0200
Message-ID: <20241014141238.448240239@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Remus <jremus@linux.ibm.com>

[ Upstream commit 14be4e6f35221c4731b004553ecf7cbc6dc1d2d8 ]

The vDSO self tests fail on s390x for a vDSO linked with the GNU linker
ld as follows:

  # ./vdso_test_gettimeofday
  Floating point exception (core dumped)

On s390x the ELF hash table entries are 64 bits instead of 32 bits in
size (see Glibc sysdeps/unix/sysv/linux/s390/bits/elfclass.h).

Fixes: 40723419f407 ("kselftest: Enable vDSO test on non x86 platforms")
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Tested-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/parse_vdso.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/vDSO/parse_vdso.c b/tools/testing/selftests/vDSO/parse_vdso.c
index d9ccc5acac182..7dd5668ea8a6e 100644
--- a/tools/testing/selftests/vDSO/parse_vdso.c
+++ b/tools/testing/selftests/vDSO/parse_vdso.c
@@ -36,6 +36,12 @@
 #define ELF_BITS_XFORM(bits, x) ELF_BITS_XFORM2(bits, x)
 #define ELF(x) ELF_BITS_XFORM(ELF_BITS, x)
 
+#ifdef __s390x__
+#define ELF_HASH_ENTRY ELF(Xword)
+#else
+#define ELF_HASH_ENTRY ELF(Word)
+#endif
+
 static struct vdso_info
 {
 	bool valid;
@@ -47,8 +53,8 @@ static struct vdso_info
 	/* Symbol table */
 	ELF(Sym) *symtab;
 	const char *symstrings;
-	ELF(Word) *bucket, *chain;
-	ELF(Word) nbucket, nchain;
+	ELF_HASH_ENTRY *bucket, *chain;
+	ELF_HASH_ENTRY nbucket, nchain;
 
 	/* Version table */
 	ELF(Versym) *versym;
@@ -115,7 +121,7 @@ void vdso_init_from_sysinfo_ehdr(uintptr_t base)
 	/*
 	 * Fish out the useful bits of the dynamic table.
 	 */
-	ELF(Word) *hash = 0;
+	ELF_HASH_ENTRY *hash = 0;
 	vdso_info.symstrings = 0;
 	vdso_info.symtab = 0;
 	vdso_info.versym = 0;
@@ -133,7 +139,7 @@ void vdso_init_from_sysinfo_ehdr(uintptr_t base)
 				 + vdso_info.load_offset);
 			break;
 		case DT_HASH:
-			hash = (ELF(Word) *)
+			hash = (ELF_HASH_ENTRY *)
 				((uintptr_t)dyn[i].d_un.d_ptr
 				 + vdso_info.load_offset);
 			break;
-- 
2.43.0



