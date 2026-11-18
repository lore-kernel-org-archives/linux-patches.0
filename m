Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052974;
	b=WnMyTDI3Swer0IS6y5YA0vFX+8lQEVTO5cF5GiHA5fQs8Zav9+yVI06/PsROMrto3mmL
	 6G0eCloRYSesgd3cyJLLs/issTTwNulWVVMPJP5UBG0Qpmi3EalDK8l6wO6/vMRDnLn5V
	 LOt+JQ2PP/CFCr/T7Y44hDig6VGGxerIoMCff+5jC/Z0rBvwMlHA2GRfoPaUd0NDkJdyT
	 cW4UTKx2KZEBuxZYJAz+O5PEoOitVtyB0s/D0SWgANSeHlNwm+J1CZ84e+a/FDK4dmZaQ
	 4i8iRP0IfjrAT2f/8m+dD9lYnm0JFc13KVPSV0HVzpjS2VFb4x/6Oupiyeq0f2XoeOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z5VgxrE+6Wk/oM3cW4HoKivz+Ek3Zr8au/EixJPlQng=;
	b=RRiTIXC4jRYzjQM09Fa7o+hyZjXtEEYEt2GlL3y48PRiaftDzyK3tXigC2f1rHlFojO0
	 IHRFV+rr8i6BJNB3XIG3urc4RPw8cOF546iL2YNL7Umve3YOtzFqNMaZOsESH5uXVyrrq
	 6jI6CC60DeAaC8yI7dXtme5kDCbmAavFwOCXEoNrhsf6WYaSQLLJMVtpEHVBw4kdvD4R5
	 /aiM09sOKq/IuhWgnJwT0W+arhlgPlgfKNC1zVzsn6nu2IPXfQkk9u/jmpci5l4XUjZZp
	 X367mixJujXh98Ro7zWZnIMJ+pbw4qZsdaSkgJnrdVbG7ZJJiZUcjNUf2746E6LDh6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kEjCT+5g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A839606A320;
	Thu, 19 Nov 2026 01:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kEjCT+5g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD0B1F000C4;
	Thu, 19 Nov 2026 01:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052974;
	bh=z5VgxrE+6Wk/oM3cW4HoKivz+Ek3Zr8au/EixJPlQng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEjCT+5g53/5OuTWTxl92J0Ti1LWw+IIi1x9sfWckxB16xnSTMLchg+ix3Wl3ju0u
	 1yiZQto1iR6Cfr4Ka/yTWtGsQcR/n8+P2y35QPSuFoI64mm+KzwABDQJgOWpdGURIw
	 6I9p9900lE4yoI5JFmw3NQiZOncBdzDJQW/qtkuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0754/2214] ksmbd: fix out-of-bounds write in smb2_get_ea() EA alignment
Date: Wed, 18 Nov 2026 15:40:30 +0100
Message-ID: <20261118150041.912084326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 30010c952077a1c89ecdd71fc4d574c75a8f5617 ]

smb2_get_ea() applies 4-byte alignment padding via memset() after
writing each EA entry. The bounds check on buf_free_len is performed
before the value memcpy, but the alignment memset fires unconditionally
afterward with no check on remaining space.

When the EA value exactly fills the remaining buffer (buf_free_len == 0
after value subtraction), the alignment memset writes 1-3 NUL bytes
past the buf_free_len boundary. In compound requests where the response
buffer is shared across commands, the first command (e.g., READ) can
consume most of the buffer, leaving a tight remainder for the QUERY_INFO
EA response. The alignment memset then overwrites past the physical
kvmalloc allocation into adjacent kernel heap memory.

Add a bounds check before the alignment memset to ensure buf_free_len
can accommodate the padding bytes.

This is the same bug pattern fixed by commit beef2634f81f ("ksmbd: fix
potencial OOB in get_file_all_info() for compound requests") and
commit fda9522ed6af ("ksmbd: fix OOB write in QUERY_INFO for compound
requests"), both of which added bounds checks before unconditional
writes in QUERY_INFO response handlers.

Cc: stable@vger.kernel.org
Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 55117e96e9498..3959e419c45f4 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4556,6 +4556,8 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 		/* align next xattr entry at 4 byte bundary */
 		alignment_bytes = ((next_offset + 3) & ~3) - next_offset;
 		if (alignment_bytes) {
+			if (buf_free_len < alignment_bytes)
+				break;
 			memset(ptr, '\0', alignment_bytes);
 			ptr += alignment_bytes;
 			next_offset += alignment_bytes;
-- 
2.53.0



