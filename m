Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037155;
	b=AB6AOTkWHAFJWWhIK1aAXKTbt2Jkxt1j6dH5Js/EG9+Dr9mbXyJ6tgJCwnkBW8bJ4k65
	 7lRV8FAWwAmSsZvoprf6RHCDpFq1608u054VMWtiBs630HoAArmqflGenrLRkN5PUotTt
	 5x3yN7fKI+1f46XkQM8gnR+F1JRNn2f6OcVMP4C+iuOzIoCKzdfl2Jb5B5Ao7S3Op2/HY
	 Bk4V50XsFYhxUiQWjenT78I5mzRAI80LteYChsWsIgk2qHEvfwDzQSnKxhSrJtnMxUMn/
	 l1+slUBzA0CtNLJu4XWdNJ2TGuw2FGiwWPiXlvjZxuI6u3NjpFMA05BllzRbBS4gThA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UKDuU5WkAXMPaJwegStlz1P60J+Sca1NuSrTYikQfWU=;
	b=lPcdbNu0lPCVlNLIy1VPYog3BAk7EumAk5P9sz9nA7NwUpdpkHSECh1rYutqTQdE7pma
	 kY7iYEGWb/jNDVJ865hq3reADlgZfAZFEPba5m9Sru7XT6ivWiYqNBlfUVoZnS2+suR+a
	 bzX0hiuq9u65ujVkQI/p0QE80wK7K1uyGM8np3RqAXBc1/IYDyevy6lnbaxFzZyv76en9
	 8sSggblBlkFo37DZJbi1523uW4pcqMdfLVGbdpJjpVCs3YU0D1HcduyTFtHTr5p1m+En2
	 W29z+1eOAzBO32jbXAtkn8ZkF94woNoK9nWSD8OuepXGzpvw+cB44ZP4bzoZCs9djaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d2xsTGUv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155A4606A33A;
	Wed, 18 Nov 2026 21:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d2xsTGUv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE231F000C4;
	Wed, 18 Nov 2026 21:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037154;
	bh=UKDuU5WkAXMPaJwegStlz1P60J+Sca1NuSrTYikQfWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2xsTGUviQwmH/QkEY4OzV2iPx+QzwAS+cje1COL87nCQPdUW6lEwklfCA0BrsojG
	 ZRJ3APAo4P12cm90RZFxs9oFZqR0yPTvkYKchB+2OVs6LWmfnSknXZ0/8warm9+oWM
	 8h677jajFeqgVu11bK9KCxMCcMU1X+G/5atCZFxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1313/3318] smb: client: validate SMB1 EA list bounds before parsing
Date: Wed, 18 Nov 2026 15:32:15 +0100
Message-ID: <20261118150359.684344252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced unavailable smb_EIO2() tracing calls with direct -EIO assignments. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 3babce8acfda5..e38d1489bb135 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -5727,9 +5727,11 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -5806,9 +5808,18 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
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
+		rc = -EIO;
+		goto QAllEAsOut;
+	}
+
+	ea_list_len = le32_to_cpu(ea_response_data->list_len);
+	cifs_dbg(FYI, "%s: ea length: %u\n", __func__, ea_list_len);
+	if (ea_list_len <= 8) {
 		cifs_dbg(FYI, "empty EA list returned from server\n");
 		/* didn't find the named attribute */
 		if (ea_name)
@@ -5817,12 +5828,12 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/* make sure list_len doesn't go past end of SMB */
-	end_of_smb = (char *)pByteArea(&pSMBr->hdr) + get_bcc(&pSMBr->hdr);
-	if ((char *)ea_response_data + list_len > end_of_smb) {
+	if (ea_list_len > end_of_smb - (char *)ea_response_data) {
 		cifs_dbg(FYI, "EA list appears to go beyond SMB\n");
 		rc = -EIO;
 		goto QAllEAsOut;
 	}
+	list_len = ea_list_len;
 
 	/* account for ea list len */
 	list_len -= 4;
-- 
2.53.0



