Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208206;
	b=DUGVeD7A8BfA2T+caRSuBAuXYeHfwlI2y9Ldi1LRRCrztN565pwZ3i1wbSdwfkAiinwU
	 Wy1/NtgZz+SgUB4yG1XfhRhjOdGnDV+8ehT++GVHvwe1xxZlmqz+/PH2kuuwYwpLDs+44
	 LB3WMi6T0/O0xljudbnkjZaNq4WNk6MKRscHMPsIGhA34FME3BJfHkSE/GTAjOWuZbSQL
	 /e7yiZ7nOW9KnCiq+pV+wW7Iz96Odb4BBXacSSETATo3HP6Qsz/M2MkapQRvtwK2tM+Xu
	 LcnFu7Uwq3ggq4MGNW/6NilT3PI1YJR71jLsNFQD5ZETa6wWDmRJVf9SRuES+Qf50mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E+BZ8vAb6D+FpqmZfEfBjMYkdUxzkZIi7fnL25KJA4Q=;
	b=K89nB0WueMPNMCa2Q+Pcs/FHzRNyzz8+4Sxq1Iu0dGmHbD0Bpt+gGzm5mUyjm9WOlyRX
	 EI6rR7kNu0CCdRaYPVvIWbuEBdoAlbxvL81ILV0WYmeXgdojfHzZynKcQJwBdMfGbvKM2
	 CZfY/cmGUf+oAz3zJYwNakhhpkPMOrD/EgufbT35kFks7bzf2y6cCb+B3MA5iufhngvSI
	 vpxiFk2l6ESy8H0lIdF+E3yAtqMqoxbhgrDg4vluJT1DMzXeMjMwjEn7XkXJwoPCH/MJd
	 z0PGaG3g10keTZ7PEgzKs39TVnsrjOEyPQhzaQTfKHytG6qvcu9lCcfZGHrFPTxuieg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1ZWjAvM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AAA606A31C;
	Wed, 28 Oct 2026 17:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1ZWjAvM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23361F031E2;
	Wed, 28 Oct 2026 17:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208206;
	bh=E+BZ8vAb6D+FpqmZfEfBjMYkdUxzkZIi7fnL25KJA4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1ZWjAvM3E0mgzgbbeI6H1a2BCW9osDGhtfh/S263qNqAmdedTigfm8g29yYyiQsa
	 TDWKe3GIRnxkZOgxVUyHzP2Z2+0LOEabW8u18DeTQOrXi0Aln893qG02Tz96cp/zKk
	 g8KGkOB0bs4BLMbRNHNTUjBHcclvJK0KrMgUWJpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/516] smb: client: fix next_buffer UAF and NextCommand bounds in compound PDUs
Date: Wed, 28 Oct 2026 17:53:09 +0100
Message-ID: <20261028170004.408090123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8fb3db801d3ab..1113d0904b630 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4973,6 +4973,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	length = decrypt_raw_data(server, buf, buf_size, NULL, 0, 0, false);
 	if (length)
 		return length;
+	pdu_length = buf_size;
 
 	next_is_large = server->large_buf;
 one_more:
@@ -4985,8 +4986,15 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
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
@@ -5022,6 +5030,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 			server->bigbuf = buf = next_buffer;
 		else
 			server->smallbuf = buf = next_buffer;
+		next_buffer = NULL;
 		goto one_more;
 	} else if (ret != 0) {
 		/*
-- 
2.53.0



