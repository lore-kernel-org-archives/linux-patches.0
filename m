Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F8121CC5C;
	Mon, 17 Aug 2026 14:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978718; cv=none; b=ozBopoBFo/0xa8Ym4/Pv0ypgkzLZ4eZPsNaunwyz18CdMfNOUAnDJy3I8ui90NYYP8DTXSbNFkW25tv3ZSZUSnr4o5kWbCfMNGpbsuTjecr+Ks9VzvfRa80QRkd6UoLG4yxfdVE4Fkfbj6ZftsF4Hyhz0tasXGGqanB9mm1mK1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978718; c=relaxed/simple;
	bh=1REDj/8NoYR9Yn6RJHtZHSyr0BH+loGwACwVmPA+0CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/rGVqnMHIVqTw/wc3qxjR0KiTwEi5nq1KtNqwfCcotJlXW28avTXOEOsXJcOq180ErmXbKyEH+To7KKIz7QSY0F1iXZFV9kr/jgwAoQUZeC8EJINeg8h5tIQjMrb0/du2Szo+lOEdP7babRtgPLS4dOlohpcy7q822C4svUQ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrMVSmRT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrMVSmRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A271F000E9;
	Mon, 17 Aug 2026 14:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978717;
	bh=rP0gpWft0s0H5aKS3qrtV8BIsCFgzQDXGcKL6PsQNyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QrMVSmRTixvBLwcULwGttdjkqu+ekLfe8vbnwsfM04JPunK/mruXCV3gFd+1hMckc
	 EsMC+de4ZDM3EfIEq+4wFhP1+ffJeflxM63ARKGv/o2p+xaeU0ytNVn9uFyRuv02c8
	 m2pIMn8FqhFW/RbyOtNipadJwppiD31mWTHV1ZiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	chanyoung <ppoo1220@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 134/156] tls: dont leave a full plaintext sk_msg ring unpushed
Date: Mon, 17 Aug 2026 15:34:28 +0200
Message-ID: <20260817132539.936370986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: chanyoung <ppoo1220@gmail.com>

commit 7bca91d63341274e857f4aeaad54d229405e93dc upstream.

When the copy path in tls_sw_sendmsg_locked() adds the fragment that fills
the plaintext sk_msg ring, it does not set full_record, so the record is
left full and unpushed.  A later splice() then adds to an already full
ring: sk_msg_page_add() has no fullness check of its own, so sg.end wraps
onto sg.start and the ring appears empty.  Fragments added after that
overwrite live entries, and sg.size no longer matches what is reachable
between sg.start and sg.end, so pushing the record runs the scatterwalk off
the end of the scatterlist.

An unprivileged user can trigger this on a loopback TCP socket with the
"tls" ULP attached:

  BUG: kernel NULL pointer dereference, address: 0000000000000008
  RIP: 0010:memcpy_from_scatterwalk+0x32/0xc0
  Call Trace:
   skcipher_walk_next+0x1d1/0x2c0
   gcm_encrypt_aesni_avx+0x1e9/0x220
   bpf_exec_tx_verdict+0x3bb/0x860
   tls_sw_sendmsg+0xa1a/0xca0
   __sys_sendto+0x1da/0x1f0

Set full_record in the copy path when the ring becomes full, and push a
record that is already full on entry to the sendmsg loop.

Suggested-by: Sabrina Dubroca <sd@queasysnail.net>
Fixes: fe1e81d4f73b ("tls/sw: Support MSG_SPLICE_PAGES")
Cc: stable@vger.kernel.org
Signed-off-by: chanyoung <ppoo1220@gmail.com>
Link: https://patch.msgid.link/20260804052837.49015-2-ppoo1220@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1116,6 +1116,14 @@ static int tls_sw_sendmsg_locked(struct
 		if (!sk_stream_memory_free(sk))
 			goto wait_for_sndbuf;
 
+		/* open record may be full if we couldn't push it in the last sendmsg call */
+		if (sk_msg_full(msg_pl)) {
+			full_record = true;
+			sk_msg_trim(sk, msg_en,
+				    msg_pl->sg.size + prot->overhead_size);
+			goto copied;
+		}
+
 alloc_encrypted:
 		ret = tls_alloc_encrypted_msg(sk, required_size);
 		if (ret) {
@@ -1216,6 +1224,12 @@ fallback_to_reg_send:
 						       msg_pl, try_to_copy);
 			if (ret < 0)
 				goto trim_sgl;
+
+			if (sk_msg_full(msg_pl)) {
+				full_record = true;
+				sk_msg_trim(sk, msg_en,
+					    msg_pl->sg.size + prot->overhead_size);
+			}
 		}
 
 		/* Open records defined only if successfully copied, otherwise


