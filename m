Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044367;
	b=vOdWa5WZeDaH0+yhf+/HTW89MftikK4m45JL27dgLWdL2ZIhfcCn2aTrVYT++vmUsgVH
	 3T64k6YtY+WF2J9geloOtOXGWe1J9kx+MuWDsfIQDdufe9DZ9odnZVf6n11/yBlXW6ZTj
	 WhtJt8pjtDMePkpEhWJ/fKEAtpMgEYfWohJnZg7ufv5CwxngtyP8X8+ZshhweyCskWHD9
	 f+QI5v9Ksc2rAr7fPF0Nx+cPLHnuqf4ntAJEidKyW3ikjO85eDiiaPTFtKZ7BBLgHGCjz
	 fL2JenLmp9cwwKIquQAYs50KZoLp+WY9ifA3EXrviKpOmk3DoWw73IuyCNjqBUt+OEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xqet3u0LsrV2tnPlPpomLVmIx3i3/umDkUuqDjz5V/o=;
	b=w6U4njgclQ3jKPTKOQ3wAgZa2HsgFyz1sOu6LB0DiEXM7C1OsoqMNEjeL5Y2Nx6KOQRb
	 JmpbSm5PpQ8/R7QOUrvEN2F5+RAIeuA0aR0kj+zmZ48llkDp19dWOrQqBUGlBDQkwYJbq
	 WZ4/4/C6RFis//Gb+zVYZyhGk3kRrCfoEHR7bEfxjgaqYNI4CiNtuZ0zTgMIbnkMeLVKR
	 /E3FHqKJS/3W65aQse78prq7M+Pf280p8/Gxi8dmk3Y0N41+9dZpkdhEVX05oKQwgvw7P
	 1MHBwixxsBsuW0k66k+0AjK2lN72Pi9zOUL8p2++VvESb+CDya7WMeamdpmZFu0zTXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TW6yKV4h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E4E606A325;
	Wed, 18 Nov 2026 23:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TW6yKV4h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8DA1F000C4;
	Wed, 18 Nov 2026 23:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044367;
	bh=xqet3u0LsrV2tnPlPpomLVmIx3i3/umDkUuqDjz5V/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TW6yKV4hwkqadfZQaueOXXXXlVo7salXeyHztHxATtC3RyBZAHhmGTtUdAX89RW1v
	 9QIKVgLkjat49dyAMPOL/LIgECuSHLl4Y9RPczUagMjPhSzrWGi35cumIT2R9v0Ay1
	 mMccjlf3eDUkdP3e+U8UnSxNnVA/4pwd+goHARA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 0542/2857] s390/probes: Fix wrong opcode for cgrb fixup
Date: Wed, 18 Nov 2026 15:26:16 +0100
Message-ID: <20261118150221.002963242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit d7ccab11a13475e656b9d2277900422c1bfc12c5 upstream.

The last byte of the cgrb instruction is 0xe4, however the probes code
compares against 0xe6. Fix it.

Fixes: 6b169ac9b434 ("s390/kprobes: add support for compare and branch instructions")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/lib/probes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/lib/probes.c
+++ b/arch/s390/lib/probes.c
@@ -99,8 +99,8 @@ int probe_get_fixup_type(u16 *insn)
 		break;
 	case 0xec:
 		switch (insn[2] & 0xff) {
+		case 0xe4: /* cgrb  */
 		case 0xe5: /* clgrb */
-		case 0xe6: /* cgrb  */
 		case 0xf6: /* crb   */
 		case 0xf7: /* clrb  */
 		case 0xfc: /* cgib  */


