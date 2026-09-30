Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBC04E06CC;
	Wed, 30 Sep 2026 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786754; cv=none; b=H3XUTYbVmHVuI22DCy7du/Zo+/A9Iv+72VK0U4Et8IOdnhz/K5zjPCZ/e60Hh2oxiaYzy+ghCedK8oqPc93EjD9eFLWJkpfLIMAFD5CSNb97Xz4U6v5iXXbKDX3UYyEvV7FaW0+5QFOPCsTgqi9Ikr9o5gP0tBW/w1z+UeIvgzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786754; c=relaxed/simple;
	bh=eqpBMXnGec4LfWnm6oglUCdv84lHAewBYR2zDWxHXak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIrIv85Z2stOYVZ8VO+U1qpiBJw1AWfguxGxeN6yPPIoJYoaX9X7Pt5kOpJ3gCDQF9qzLncLBSDEfGFVeICFM4eWBm7i8rae3+L4VgtVRCafXfWz5PXPY8pLIICrkC8JUlfAIKuE1ZVcrEflP3JO/6xbZXMi4Fb5li7bIz/bLQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDBQ+iTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDBQ+iTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764FE1F00893;
	Wed, 30 Sep 2026 16:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786753;
	bh=wihFKw4L1BcVqjP69PVKlLEskftoNcShEA2oyFWA0z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDBQ+iTWXP3e6yIzCtRoMlJslijEKPIBptiSCXBjshGUTSsmrWHDVPxgCUrxkWhGR
	 T2tS4T9Kx2heKJ5IH9mw7unwRTJ2F8IL3AseAlfjffvHBKHDj5dEBA20Vg5YT7XhNo
	 S37ykJSZt0eDsymd1vsYP4++gsF0/64HhoX+LvL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 971/982] Bluetooth: hci_sock: reject out-of-range OCF values
Date: Wed, 30 Sep 2026 17:28:27 +0200
Message-ID: <20260930152437.602031199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1823,7 +1823,8 @@ static int hci_sock_sendmsg(struct socke
 		u16 ocf = hci_opcode_ocf(opcode);
 
 		if (((ogf > HCI_SFLT_MAX_OGF) ||
-		     !hci_test_bit(ocf & HCI_FLT_OCF_BITS,
+		     (ocf > HCI_FLT_OCF_BITS) ||
+		     !hci_test_bit(ocf,
 				   &hci_sec_filter.ocf_mask[ogf])) &&
 		    !capable(CAP_NET_RAW)) {
 			err = -EPERM;


