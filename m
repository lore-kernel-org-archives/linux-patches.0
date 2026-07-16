Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD33E3FD121;
	Thu, 16 Jul 2026 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209377; cv=none; b=n1xpvfEhF6rZ5mH0Vywjy0vsyP92aULrmXdAiaK5A9FhPhSy3EYo4IEdN/PdqW8LJWVzQKEvVfbOMAP/uMTAOSNbTgE05l/uFMMWgsjnmV9W8nuYYpjUIG9YrVEqCPUNqA7ZD3bp+KeBkbl/OvuDUFdELMWRS7/Gru/XuzcVFXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209377; c=relaxed/simple;
	bh=2WOFIHVMiF0XGGfsWBZND8xCvvZLCO0xhi8qZvcO3TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1snP76QI5tsv1hcKf33eLvOrbq4zUcL2oTbMvEXutLoSbquhhRnw3weBrk65DhH5lkKZDiE+WRy0vQSMkQFL9MPoWQQT2Jnw53wwKR7gipguYf6h7iBwGEM+WmXcL0GgpA7jv0qA+a46tPqcJIEJL8NVmLnv2stKxG4Ylox0tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pimO6Q25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pimO6Q25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36B41F00A3D;
	Thu, 16 Jul 2026 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209374;
	bh=MZX5qVTHo1k+Gah9Zl8f323qAAgb+zSyJ4CRYu/KgXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pimO6Q25JzUMTQDm3RQYnTocwZJsB15TSva4/DnFa4NSARYhKBjXNaQH0f60Tej2e
	 M6onh/3jRN3eW1o/42j6Tp8Gjj6i76//tx2rjvJwH8Y8xyVVF9grrr203rmbQPJJKI
	 fNThekURDe2L5SkpmpT9mHeOasDFjxfSpO4P54MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christopher Mackle <christophermackle01@gmail.com>
Subject: [PATCH 7.1 159/518] staging: rtl8723bs: dont drop short TX frames in _rtw_pktfile_read()
Date: Thu, 16 Jul 2026 15:27:07 +0200
Message-ID: <20260716133051.321694298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Mackle <christophermackle01@gmail.com>

commit 252f8c681adc8614b70f844ba3de3a138c33a783 upstream.

Commit bc4df274dca6 ("staging: rtl8723bs: update _rtw_pktfile_read() to
return error codes") changed _rtw_pktfile_read() to fail when the caller
asks for more bytes than remain in the packet:

	if (rtw_remainder_len(pfile) < rlen)
		return -EINVAL;

That breaks the assumption made by the data TX path.  In
rtw_xmitframe_coalesce() (core/rtw_xmit.c) the per-fragment copy is
issued with the full fragment length, mpdu_len, which is derived from
pxmitpriv->frag_len (~2300 bytes), and the code relies on the historical
behaviour of copying only what is left and returning the number of bytes
actually copied:

	mem_sz = _rtw_pktfile_read(&pktfile, pframe, mpdu_len);
	if (mem_sz < 0)
		return mem_sz;

So for every outbound packet smaller than the fragmentation threshold -
i.e. essentially all normal traffic, including the EAPOL frames of the
WPA 4-way handshake and DHCP - rlen is larger than the bytes remaining,
_rtw_pktfile_read() returns -EINVAL, rtw_xmitframe_coalesce() aborts, and
the frame is dropped before it is queued to the hardware.  The driver
floods the log with:

	rtl8723bs ...: xmit_xmitframes: coalesce failed with error -22

Management frames (authentication/association) use a different path and
still go out, so the interface scans and associates, but no data frame is
ever transmitted.  The 4-way handshake therefore never completes and
wpa_supplicant misreports it as:

	WPA: 4-Way Handshake failed - pre-shared key may be incorrect

AP mode is unaffected.  The net effect is that the chip is unusable in
station mode on any kernel carrying the offending commit.

This was confirmed with a wpa_supplicant -dd trace on an RTL8723BS SDIO
adapter (Bay Trail): message 1/4 is received and the PTK is derived, but
each "Sending EAPOL-Key 2/4" coincides 1:1 with a "coalesce failed with
error -22", so message 2/4 never reaches the AP, which keeps retrying
message 1/4 until the handshake times out.

Restore the original semantics: clamp the requested length to the bytes
remaining in the packet and return that length.  The skb_copy_bits()
error path is kept, so genuine copy failures are still propagated.

Fixes: bc4df274dca6 ("staging: rtl8723bs: update _rtw_pktfile_read() to return error codes")
Cc: stable <stable@kernel.org>
Tested-by: Christopher Mackle <christophermackle01@gmail.com>
Signed-off-by: Christopher Mackle <christophermackle01@gmail.com>
Link: https://patch.msgid.link/20260620013916.7148-1-christophermackle01@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/xmit_linux.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/xmit_linux.c b/drivers/staging/rtl8723bs/os_dep/xmit_linux.c
index d5bb1c7932fc..4260ed5f4e97 100644
--- a/drivers/staging/rtl8723bs/os_dep/xmit_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/xmit_linux.c
@@ -24,9 +24,11 @@ void _rtw_open_pktfile(struct sk_buff *pktptr, struct pkt_file *pfile)
 int _rtw_pktfile_read(struct pkt_file *pfile, u8 *rmem, unsigned int rlen)
 {
 	int ret;
+	unsigned int remain = rtw_remainder_len(pfile);
 
-	if (rtw_remainder_len(pfile) < rlen)
-		return -EINVAL;
+	/* clamp to bytes remaining; the coalesce loop relies on short reads */
+	if (rlen > remain)
+		rlen = remain;
 
 	if (rmem) {
 		ret = skb_copy_bits(pfile->pkt, pfile->buf_len - pfile->pkt_len, rmem, rlen);
-- 
2.55.0



