Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E030EEC8;
	Tue,  8 Oct 2024 12:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390413; cv=none; b=DVbhc9u/x6fNFjbf6Q5GvhMz1fdM0LEUc33lTs9p8r6ibfiD0Iyosd+zKHXfkAS5+7kWaosb8Er1lDCuYEvUeeWmSqpVkrZiy5vs9CxX8UO6cPYHqn8bOvU6QEG86g2j+20W8YEmjy2bloVC659MZi7TlrvOJeoRQ82LPKBiviY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390413; c=relaxed/simple;
	bh=mM6VF7nywYkZKBh5MWMsfBM+AwxZR0Mv+VH3zX4MYCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgZ8lZzE3BZfwoMztB+0lzJUlQdTnyOflvvjfqwX6Ir3m0BXr+Hbmfs+6fruil5mgQfML72UwiGuyWVPZEH3ALvawjW7IoguihfheNFPUfbeg4yDFrWi8oBuNFF4RbN0PmGq1azq42LmOSDEIldYcW9xmXru5MZfoya535IhsXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7yYMuiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7yYMuiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5C2C4CEC7;
	Tue,  8 Oct 2024 12:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390412;
	bh=mM6VF7nywYkZKBh5MWMsfBM+AwxZR0Mv+VH3zX4MYCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7yYMuiVZFOtoXNhy7p3ZPc2lEK9ebPPI0mMAX3rCyUUh+f86n9w2SCYXWPdQm8ZI
	 wzzL+/qUbmit5KSIVzz+s4CuagHztgWQsHNhFbpr21RyF1LksVRG85MAKYSfkzTHT0
	 uf+VoHKeUdcljbC5B4WpRovSTwvt//ki3ko2gAEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Jens Remus <jremus@linux.ibm.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 281/482] selftests: vDSO: fix ELF hash table entry size for s390x
Date: Tue,  8 Oct 2024 14:05:44 +0200
Message-ID: <20241008115659.337936405@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



