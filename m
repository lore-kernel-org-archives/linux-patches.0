Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210607;
	b=LrZVu247il+8oLlsEgfst3uG7PExZhTbgr2wXSWktWlx6SP6yWb4KDZeGFAdoTsEb7LB
	 Jad/xSWVjhFcFSqfe1ZTQizVjge6U/ycxNjZIXSrRSBNs8aD4feUmNWajp09NbzpWgXz8
	 Mlo5opFQZ+W9VBnrbVJid6ceLni4bikg7ki5c2ksFyxTRcJuLMW192mFY5wrheiukGgDv
	 YyCF2ElfZRa9MjJHNL9887L0JdG1IRIvlD2cxBw+4UZKYja65Wp3B73X9OGJIBK5CGrZz
	 Ev+Z0Tma6kGD42fDUi+fEmg7uRGD7ofV8SrKdcdSu+OO4UA5vrtPPfNCTctfFMmrZXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IUIVX9VXcT7Psxv7Luu+aG/KD91NbTEnLG4zHY8pWBM=;
	b=moeGxZlIE6Bw0tZy2130HD2vQwwupvd5+sbBDZSX6D4wLrkFnHhjN9WPh2dfkliRpWNL
	 YsFC9igPsJ+42FJnTeb7vY091yaBDD5H7wwa2WiNGO0QslCq/rdhxb68GJuFmxsAxwxSq
	 qxSVl7W7T39WiQOonkmEv8Ax70LxCzJ0/akgiOZzF2YAOwlRXRPQXJy749oeHyuk+aIeu
	 VBDaaYQqIVsocaOXl8NFNn8AhElsG6RdSUXNyyNxaLYSPMo8FYhUppV/w/a9eqr8jwEjQ
	 ddrWFYJiHAgVvYvspiwUf3MyMqz9BzKWPacWjC6SjEs2iUIzoVQ2pFvyhDjLF4noeAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Oc+Mf/W5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A8F606A31A;
	Wed, 28 Oct 2026 18:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oc+Mf/W5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E4E1F01825;
	Wed, 28 Oct 2026 18:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210606;
	bh=IUIVX9VXcT7Psxv7Luu+aG/KD91NbTEnLG4zHY8pWBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oc+Mf/W5w5Dte2yyE7Zmk77rDGyI5G597GGG/J7TZBQTIlRH73vjKIruBH3Qu/HgK
	 bVir4GekDNRpoQnAVC1dRaKh/0ZPK3tZV3HU3mAe8WUO2QIZzZs6qg6t9momFzw0gr
	 K0K47mktTNbeKrX9lMF1y+bvoboYYnfAmwrlelt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/571] smb: client: fix next_buffer UAF and NextCommand bounds in compound PDUs
Date: Wed, 28 Oct 2026 17:53:07 +0100
Message-ID: <20261028170008.978018421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 05762c5bc1cfdcac36747994fde2c04387a457f1 ]

Fix several related bounds checking and pointer lifecycle issues in
receive_encrypted_standard()'s handling of compound encrypted frames:

- Clear next_buffer after assigning it to server->bigbuf. A stale
  next_buffer pointer can lead to a use-after-free on subsequent
  error paths.
- Update pdu_length to the decrypted plaintext size (buf_size). Using
  the pre-decryption length allows NextCommand to point into stale
  ciphertext residue.
- Reject next_cmd values smaller than MID_HEADER_SIZE(server).
- Fix an integer overflow in the upper bound check by verifying
  pdu_length - next_cmd < MID_HEADER_SIZE(server), ensuring the
  trailing slice is large enough for a header.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ Replaced unavailable MID_HEADER_SIZE(server) with (HEADER_SIZE(server) - 1). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 42b5e5264fb6e..0b65d8ad66261 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -5228,6 +5228,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	length = decrypt_raw_data(server, buf, buf_size, NULL, 0, 0, false);
 	if (length)
 		return length;
+	pdu_length = buf_size;
 
 	next_is_large = server->large_buf;
 one_more:
@@ -5240,8 +5241,15 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	}
 
 	if (next_cmd) {
-		if (WARN_ON_ONCE(next_cmd > pdu_length))
+		if (next_cmd < (HEADER_SIZE(server) - 1) ||
+		    next_cmd > pdu_length ||
+		    pdu_length - next_cmd < (HEADER_SIZE(server) - 1)) {
+			unsigned int max_next = pdu_length > (unsigned int)(HEADER_SIZE(server) - 1) ?
+					pdu_length - (unsigned int)(HEADER_SIZE(server) - 1) : 0;
+			cifs_server_dbg(VFS, "invalid NextCommand offset %u out of range [%zu, %u]\n",
+					next_cmd, (HEADER_SIZE(server) - 1), max_next);
 			return -1;
+		}
 		if (next_is_large)
 			next_buffer = (char *)cifs_buf_get();
 		else
@@ -5277,6 +5285,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 			server->bigbuf = buf = next_buffer;
 		else
 			server->smallbuf = buf = next_buffer;
+		next_buffer = NULL;
 		goto one_more;
 	} else if (ret != 0) {
 		/*
-- 
2.53.0



