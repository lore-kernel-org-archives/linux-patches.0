Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827122;
	b=2G/ekDnaPwTdJG7hz2pkdoF+wX9ZLzwU9WIV3jM1Z8s6YNopS7xEVliSHB9bI/s32nwQ
	 h4QiN45NkTUNKCWWILv8fhNBZUpFh5gItRkKMoWZusJvKzmTRQVEUNeatqvTmHBM7CqZu
	 DBv8qmEHXLfiz0c2ZrVIfi1TY/4OG2idDqdhu+3IFHLW2kdTKkapKKt2gpv1bLRZ+mJqi
	 Ltj/YPTFHCNbemw8Dd3Ckv0373AAkUkkUFZliEi1HTaujmX0dKq5NcfMPH8AUIdC8/tgR
	 Ttxfa/xz2yP1oTxcypZbHZfQEQyGoxeZaehcogSgG5kph07mAHKIjbdcwRpd7G3lvdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t6hQFPtupRIJ985gznrmYWIBDLG5TL6Rd94eWoJKRyk=;
	b=YAgQIUDQDnrY4X3LwWCTN2vSX4D+BaCsM51pPbDBU1GvpJqX2d0hDXozedzLQQiNeHdb
	 fzzTDpVAU0EBDlZij/jbSctzd1H2G9P2/R4GRk1gHR+gd8oJy1gcRqeF/Mr96BT7u8KzE
	 ZXIQUquP7wzm9dlOJKaajyN8Be/FuTWTkc1BUcQOE/d5yWqdkFhTGBpwruobPECvu9tDG
	 4cJOZqk9ouRG2zHNpOeXom4ZgWUrwaSv9XZvALav4sKbYhNp6QxbXqA7lG+5jqeMAqQRu
	 X6CSItL252UsFKC26lxsOEzsdBiRZInFMH4yjtQvBfAcFwrbgSO3VlAu397UCFVTQNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iy5yCJ3m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D5F606AE33;
	Wed,  4 Nov 2026 21:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iy5yCJ3m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301A41F000C1;
	Wed,  4 Nov 2026 21:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827122;
	bh=t6hQFPtupRIJ985gznrmYWIBDLG5TL6Rd94eWoJKRyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iy5yCJ3mTgYmEijPjvK1M9MOQae5tMMRM77wHxQm+4IQhYeDhjLZ/XwuktN1jWtfJ
	 S52mXMXT7D2wIJf79TQWKmGrG+ujtuNPp+JgXIT1iRaFMPAtmAWSkEKOCV0eFImIMo
	 pT9eaD1JfuF86MsaKjTc06yYvc6DzveV9AYwVQSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 177/547] s390/probes: Fix wrong opcode for cgrb fixup
Date: Wed,  4 Nov 2026 16:06:01 -0500
Message-ID: <20261104211043.174978998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


