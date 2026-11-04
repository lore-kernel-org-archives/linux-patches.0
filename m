Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829057;
	b=148E9p8LCD7iLkwgRUshsnom7fdKAy/Mflflgot/khPwCoOj/LaJ0R5sJ12njJ9yCbXA
	 m1YV7dqlWqbdfpICkGx994FVKd8+DoktHZApQ3Mw2fPVw4gIW/oa9gnbuwWLZA4LmUbEA
	 8V2QxjJmhdX2rqeH1S50qcTazlj8buzYT6tIzxkMCI+TwwbNzQ/f8ykpPR/03qzJeSjNi
	 0Y6mC8YRLSRAkOWVjqQV5TZ5EHKYLmNAf1fPQwBcHJH8ndFxwGZdOjGSunlP11bZM+7U/
	 q8OeLzv8XTiD/Z2ASMc9qKwVZ8s2TMuyYWnL5tTxOZjSuXInQTEHu1GnPeqYSZCmrng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fXWdAeMJWVUETQ0U0STt0tjhX3dgsuf+dzhETsbsd3s=;
	b=E/N+8J2KHHtZ7r+u3vExT03unZUFcgBHeQIwDEpLwV3rJBZHVqu21CcKVy6PQGZ2zrm7
	 BpdUBKB4wYL4JtpOu6R7cIZyx/p8sMvvZc3BaGweKfzFUoCFAxlLpwP8MGXg6SxFpke9l
	 ZDInzftOG5xDehWrNZXCaCWcb2BEiLOSZRsshe92TNFhf/u+uw4mYTecNRHcaE1Fcv6ou
	 sez6wGWeU26ZEBldGDtx03p0fFv4oheMeMmCzfaSwDDzKKjFfiSN0ngW/c1grCV/1v3Ms
	 jHzuCQLd9bt+woPACGw9hjJDpYaVNKtBrfo2aWout7foV+zjGRDRpYAJRN5aJgkV67A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQKrTjBH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C5960807A8;
	Wed,  4 Nov 2026 21:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQKrTjBH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D951F00A02;
	Wed,  4 Nov 2026 21:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829057;
	bh=fXWdAeMJWVUETQ0U0STt0tjhX3dgsuf+dzhETsbsd3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xQKrTjBHDmjetHY0XqB5LJNFMQXWk3ECDogy+HBrBg+YCTYGQRJsseDaZdSip4bGe
	 /ZTeFenoII23i4scXQ61H5WBg+/b0xuclZpgZHwCh9jN5pjK2WWHUjscVBwWj6BCTV
	 O1UvHOK5xH8iHO0dhNfUMafL+qlJDBWnNm4b7U5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 390/547] smb: client: validate SMB1 EA list bounds before parsing
Date: Wed,  4 Nov 2026 16:09:34 -0500
Message-ID: <20261104211049.378981003@linuxfoundation.org>
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

From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>

commit ddc7a7e1eeb116ccaf010a6f1fb6ab927f3f888d upstream.

CIFSSMBQAllEAs() checks the server-provided EA list length by adding it
to the response pointer. On 32-bit systems, a positive length can wrap
the pointer and pass the comparison. The parser then walks outside the
received response while reading the next FEA header.

A response with a list length of 0x40000000 reproduces this as a native
i386 page fault and kernel panic from listxattr() against an SMB1
server.

Check that the EA list starts within the SMB byte area before reading
its header. Keep its length unsigned and compare it with the bytes left
in the response without pointer addition.

SMB1 is not negotiated by default and requires an explicit vers=1.0
mount.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -6231,9 +6231,11 @@ CIFSSMBQAllEAs(const unsigned int xid, s
 	int rc = 0;
 	int bytes_returned;
 	int list_len;
+	u32 ea_list_len;
 	struct fealist *ea_response_data;
 	struct fea *temp_fea;
 	char *temp_ptr;
+	char *byte_area;
 	char *end_of_smb;
 	__u16 params, byte_count, data_offset;
 	unsigned int ea_name_len = ea_name ? strlen(ea_name) : 0;
@@ -6312,9 +6314,19 @@ QAllEAsRetry:
 	ea_response_data = (struct fealist *)
 				(((char *) &pSMBr->hdr.Protocol) + data_offset);
 
-	list_len = le32_to_cpu(ea_response_data->list_len);
-	cifs_dbg(FYI, "ea length %d\n", list_len);
-	if (list_len <= 8) {
+	byte_area = pByteArea(&pSMBr->hdr);
+	end_of_smb = byte_area + get_bcc(&pSMBr->hdr);
+	if ((char *)ea_response_data < byte_area ||
+	    (char *)ea_response_data >
+	    end_of_smb - sizeof(ea_response_data->list_len)) {
+		rc = smb_EIO2(smb_eio_trace_qalleas_overlong,
+			      data_offset, get_bcc(&pSMBr->hdr));
+		goto QAllEAsOut;
+	}
+
+	ea_list_len = le32_to_cpu(ea_response_data->list_len);
+	cifs_dbg(FYI, "%s: ea length: %u\n", __func__, ea_list_len);
+	if (ea_list_len <= 8) {
 		cifs_dbg(FYI, "empty EA list returned from server\n");
 		/* didn't find the named attribute */
 		if (ea_name)
@@ -6323,14 +6335,14 @@ QAllEAsRetry:
 	}
 
 	/* make sure list_len doesn't go past end of SMB */
-	end_of_smb = (char *)pByteArea(&pSMBr->hdr) + get_bcc(&pSMBr->hdr);
-	if ((char *)ea_response_data + list_len > end_of_smb) {
+	if (ea_list_len > end_of_smb - (char *)ea_response_data) {
 		cifs_dbg(FYI, "EA list appears to go beyond SMB\n");
 		rc = smb_EIO2(smb_eio_trace_qalleas_overlong,
-			      (unsigned long)ea_response_data + list_len - (unsigned long)pSMBr,
-			      (unsigned long)end_of_smb - (unsigned long)pSMBr);
+			      ea_list_len,
+			      end_of_smb - (char *)ea_response_data);
 		goto QAllEAsOut;
 	}
+	list_len = ea_list_len;
 
 	/* account for ea list len */
 	list_len -= 4;


