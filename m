Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775E736B912;
	Wed, 30 Sep 2026 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783986; cv=none; b=esp7KTeW4PvxZ1C1zMnX/BmdKPFPvkw3WxMkO0iQ7zsSLn/b9D3ujg64IDUiKSrQDuqvk9lf8VhvDlIANfAIppTjCKWC23RL7jyocfrmdJDtWpYk3KZ4YiGVRzMSzMEPGTiM3YeQOJ2HSHmRYmDawwambldoaEeLUapURsWjhyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783986; c=relaxed/simple;
	bh=gnbcNryF6o5i5sdlcdRz8YfpID0kc1uxYeE8xSAgFzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6tnY/9qk905yySp3cX1zLVyNV/hgtn3WkSQFnyb46cQ6x4kZGbXXUJJUUIVvOW8qvvKc0DM+wnZNtElPuaQCnc/igv6tkRoXI+8IXRlYyrpDGx35GF1qHiJ0+0gKDiopl4hMUSKMjfd+d216IBcH2DwV+G3sDOhkM+1tkT9xrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=il39ayRg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="il39ayRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63811F00893;
	Wed, 30 Sep 2026 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783983;
	bh=TreiOAfNlWSJpKqVlFTIotoYsI/rdpYRdDRyk4jnN4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=il39ayRgDwkJF48fXwwFvmvW5FkFJTBABhrR4CMn9LYQJk0seCY6ftnD7M/lR6ldj
	 4/5VblGEXAY4O4VREXp/xWE3mvp6oDP5+5tpPo6h8UmjiB+IIdq2nBjxVIs68v21oB
	 oxaUaO/F822I5D9WdfF4TnotlHFZkt1KwA06COSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 589/595] Bluetooth: hci_sock: reject out-of-range OCF values
Date: Wed, 30 Sep 2026 17:28:02 +0200
Message-ID: <20260930152400.406546531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1848,7 +1848,8 @@ static int hci_sock_sendmsg(struct socke
 		u16 ocf = hci_opcode_ocf(opcode);
 
 		if (((ogf > HCI_SFLT_MAX_OGF) ||
-		     !hci_test_bit(ocf & HCI_FLT_OCF_BITS,
+		     (ocf > HCI_FLT_OCF_BITS) ||
+		     !hci_test_bit(ocf,
 				   &hci_sec_filter.ocf_mask[ogf])) &&
 		    !capable(CAP_NET_RAW)) {
 			err = -EPERM;


