Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52FD3C1986;
	Wed, 30 Sep 2026 19:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797228; cv=none; b=m90VuT4Kh79u0TcdrNfHvWuzzAFygvkM2wjN5Gy/4k7qRLAGL39Oxm5D2oiZnlz/t5sjmAfzs7dQj+OklP554n8THrCjgZ6GfNX28q2hNQkliKNm5Zs8gPBkq2udxl3VFIzcc4JxuSXCDrlXu3nLY4+z9w5qQTqaR8RmCSf4Zm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797228; c=relaxed/simple;
	bh=T1f+B5zKerpVLF5dsNY+52jOahFPM40zkC3Dd3kJsdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HP75+qgbTb0suMITNnfCKFGw2YFc3I/IVE6XJeqc8I/ELuSFBh7o7RJeZWf2jkIWU8DgFJ4dlgdl/u89EZE5OoaEbgWcY2elE+/u2o/AoeBuQTdIzjs2cYfxG2G8d0Fca9Bgoq4mfhzTda+8M9Vu0BxBSuNhRleFIR/OA6AeLUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck10BkQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck10BkQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF8B1F000FF;
	Wed, 30 Sep 2026 19:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797227;
	bh=RRN1FUCMz18OIug67QeeS0/iB656aBDWOMFHA+VNjBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ck10BkQB01Fw5OI8Etsi7Onzc1MEVUAQeaQmunokEjhMw+yFccoYVUd231SKglqON
	 J65kxWepcecGi20LptdbsTim0A03rxeV1ku82qgCZSrq4S710Rvu4BUnqnF+7UV/r8
	 vceZg2IMffGyu2av8fy5n7bxd9Gh6tMmZBrat4Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 1147/1193] Bluetooth: hci_sock: reject out-of-range OCF values
Date: Wed, 30 Sep 2026 17:30:31 +0200
Message-ID: <20260930152459.721656140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit e93fad891c72deb84cae49430163b384ebcc92b1 upstream.

The raw HCI socket security filter has 128 OCF bits per supported OGF,
but masks the 10-bit OCF with 127 before looking up the command. An
unprivileged socket can therefore submit a reserved OCF that aliases an
allowlisted command modulo 128.

A conforming controller should reject reserved opcodes. Nevertheless,
the security decision must apply to the opcode that will actually be
sent, especially since controller-specific behavior is outside the host
stack's control.

Reject OCF values that cannot be represented by the security filter
instead of aliasing them onto an unrelated command.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1886,7 +1886,8 @@ static int hci_sock_sendmsg(struct socke
 		u16 ocf = hci_opcode_ocf(opcode);
 
 		if (((ogf > HCI_SFLT_MAX_OGF) ||
-		     !hci_test_bit(ocf & HCI_FLT_OCF_BITS,
+		     (ocf > HCI_FLT_OCF_BITS) ||
+		     !hci_test_bit(ocf,
 				   &hci_sec_filter.ocf_mask[ogf])) &&
 		    !capable(CAP_NET_RAW)) {
 			err = -EPERM;


