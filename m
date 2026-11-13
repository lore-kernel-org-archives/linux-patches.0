Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585978;
	b=4YcWsF1962gpWLmez3+xaZy8potkZWH1/l1+Q5XD4GuPu//zxGL3HpGDCNxNTB9QVdOh
	 A9cPaCdUHBNgEishv04WdIbyBWujjMi8m0ZmPekO0TTG2IyZCKDSvOLR7n9fhHiNmuJDn
	 f/krSv47f9RjxvBC0KFurIIhZLiBUpSReG1vaYBXgJbd2fIZiocNsyPu+FnKkx2vgjqu/
	 dsknggMOcytxwLfekP5qObfhidH4e5xYOKTSwRRl0d6yZyvtxjb/sq78Jie2OQ1HT6zAH
	 7VGrjYWmsyPwDmwtl48GntuEmQp8uJOcPjfGZqF0kaxqDHMwkt9xE7SYdVP9E7kK9Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ecOo/neevptH2TXA/Rxlod09gIW1UtS30v4tFB32bkg=;
	b=Qfd2uv3i+tKSCZYUuCMmZtJn198lMvxUoJp9W5a5KD6ZsOccgJ4fFO1uZiGBq4d4nPLf
	 kqBdVUVVgBp3d1E1iPtjqAojJ/6sO0Df8MjVha2cDKOpnwHhenOzEvwI9/IT1yJWaw5ST
	 fFeiLi0AC1CHYPqptfq3eMFfsHmeyICXsd/oQ6i6xNrwxSy8JdM91JCC28OwJYDuHNgho
	 ioI6KSdmcWAg5K6VkZssvhCq1ZRYqo0CIhdy6R5F1U5POD1chHEJEh7gDn94sAoHOXOcH
	 4pc543fRsJhcsJ7apsogEOqiLXx3MxTQICYDSBItifKf/fNfb8oyCA8LUMRPQohTlBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AgWlnPe7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C9B6072306;
	Fri, 13 Nov 2026 16:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AgWlnPe7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061101F000C5;
	Fri, 13 Nov 2026 16:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585978;
	bh=ecOo/neevptH2TXA/Rxlod09gIW1UtS30v4tFB32bkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgWlnPe7woVAEuDTatdna4MrumI4iJ9a6o1K6GxTPCePqpUepf0nkYNuEE3DVe8DY
	 1X4EFLK4N+o5qQBKERfovIYfowgvzKs6xF46/WWvYNoDgsUnGWXL4Jnj6ZfYJQmHoZ
	 W0BBI0U+IkZPC1Wl1QKHYEP/e45T6L/Awe2EHMYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/686] smb: client: validate SMB1 EA list bounds before parsing
Date: Fri, 13 Nov 2026 10:42:38 -0500
Message-ID: <20261113153821.818369065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>

[ Upstream commit ddc7a7e1eeb116ccaf010a6f1fb6ab927f3f888d ]

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
[ sashal: adjusted the CIFSSMBQAllEAs() hunk for plain -EIO where upstream already used smb_EIO2() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 6e4b845a4078c..14d5c1924ae2b 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -6082,9 +6082,11 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -6161,9 +6163,19 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -6172,12 +6184,14 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/* make sure list_len doesn't go past end of SMB */
-	end_of_smb = (char *)pByteArea(&pSMBr->hdr) + get_bcc(&pSMBr->hdr);
-	if ((char *)ea_response_data + list_len > end_of_smb) {
+	if (ea_list_len > end_of_smb - (char *)ea_response_data) {
 		cifs_dbg(FYI, "EA list appears to go beyond SMB\n");
-		rc = -EIO;
+		rc = smb_EIO2(smb_eio_trace_qalleas_overlong,
+			      ea_list_len,
+			      end_of_smb - (char *)ea_response_data);
 		goto QAllEAsOut;
 	}
+	list_len = ea_list_len;
 
 	/* account for ea list len */
 	list_len -= 4;
-- 
2.53.0



