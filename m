Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED6953B352;
	Wed, 23 Sep 2026 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175201; cv=none; b=sK2xHYyUF3LVcKe+cP0MYHTBceGRhqs4WIrJ/TmI+9AN4gLONJo54vLvQ+ig27ykBD6j+BplCnQ57kiO7AK4Iz+WnW+1asEIyF2949oR276aiUD7sWz81oeUZzBf35D+TYyJ/BYHO9nrtBZYZU3bNm6POKQbQU9+1liL0n2vN8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175201; c=relaxed/simple;
	bh=xYFQoMuS3jQj2+WLL+dapcrXsk/85XgT3bUFXlrUF8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVls2DjQSUB+hD6Bhp5Ej5DIKs/U7zxm5qoM7QcANqoT5ZkTgaESM15FOjdLMejW2oF5c8S8/kcYGqKjzs8nryKkadN/TlrALZm9Jjj/ewkTuHo8E1mmu+TeF5bBLLjqcyxSoBcirgMOSqcts5lYBs2+rR2Mh43Y3tT0bVkSDXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fp5cgU+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fp5cgU+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6A81F000FF;
	Wed, 23 Sep 2026 14:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175199;
	bh=st4bjs8S/ycTfG38VNrd+JMqM7hS1Cw0atxrPXhVnAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fp5cgU+L6dhns1dLPxiZ6PF57DELQqc+lzcEoXFtC6v4KWGEjGlvRyfU1T0psL3dW
	 Xui6rxv8wsW3p0h9BO+Dn62JoYXEmpc6jJG2iLZJNWoOsYeTY5y4SFfDlOsvFauZes
	 ddTezKEqzU2+s3+IDSvHug8TxwVkiD0oTK/4BRfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 351/398] smb: client: fix next_buffer UAF and NextCommand bounds in compound PDUs
Date: Wed, 23 Sep 2026 16:07:05 +0200
Message-ID: <20260923140652.529598363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 05762c5bc1cfdcac36747994fde2c04387a457f1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5280,6 +5280,7 @@ receive_encrypted_standard(struct TCP_Se
 	length = decrypt_raw_data(server, buf, buf_size, NULL, false);
 	if (length)
 		return length;
+	pdu_length = buf_size;
 
 	next_is_large = server->large_buf;
 one_more:
@@ -5292,8 +5293,15 @@ one_more:
 	}
 
 	if (next_cmd) {
-		if (WARN_ON_ONCE(next_cmd > pdu_length))
+		if (next_cmd < MID_HEADER_SIZE(server) ||
+		    next_cmd > pdu_length ||
+		    pdu_length - next_cmd < MID_HEADER_SIZE(server)) {
+			unsigned int max_next = pdu_length > (unsigned int)MID_HEADER_SIZE(server) ?
+					pdu_length - (unsigned int)MID_HEADER_SIZE(server) : 0;
+			cifs_server_dbg(VFS, "invalid NextCommand offset %u out of range [%zu, %u]\n",
+					next_cmd, MID_HEADER_SIZE(server), max_next);
 			return -1;
+		}
 		if (next_is_large)
 			next_buffer = (char *)cifs_buf_get();
 		else
@@ -5329,6 +5337,7 @@ one_more:
 			server->bigbuf = buf = next_buffer;
 		else
 			server->smallbuf = buf = next_buffer;
+		next_buffer = NULL;
 		goto one_more;
 	} else if (ret != 0) {
 		/*


