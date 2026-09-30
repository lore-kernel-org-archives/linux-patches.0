Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E2F5187C1;
	Wed, 30 Sep 2026 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788053; cv=none; b=jFwEr57tEMeY/X+uY2PfMPviQ5pIJzX+KTHCFx5ffeImYy3DdZN0nFcKkacVZKalWeK+24wwRX4HYnizGA1mgQHm0qs/tAtycCO7lF4VVmc6ZTtIuYVYpeyesTAv4wt92ALzhLETLQcIZeRqpXJC94uggIqwo/1Gy7t8Zu7ju0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788053; c=relaxed/simple;
	bh=puViUJ8Jpi/af5YvmcGQw0OiqwQs024IVROKQIF2dGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJz1eX3AGJHjvrL/6a4VjZSw6fFpQCb7uMDrte9yNfHtDKWn5cDqiJ6JWuKlT7oxTYoZpTxDxg/RXmzC6tmLgoi4nfyylC0P/qNBcauDOmjaaL+bd/HC8oi2b0VlYLVfmcmxBZbB8pQMn56SipvySgqG8xl3Qkbcz4Gm0Le0prU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sE/FgUKq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sE/FgUKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54E71F000FF;
	Wed, 30 Sep 2026 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788052;
	bh=zzzXzkn0dng+kPCRKBa662jh/Hj6RqQHTk6lRg3KjTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sE/FgUKqMEAdFjVHN7d1R7CG4vM0VbTDByxRR62l+JtjVHcIdxN6VovThlDgw0QAf
	 Ot1Ve/dWFszpqFGREF5HEHDxeSb5KeUthxgXQ7BREHBgu175eqHtjHUOLzpjS3BOr6
	 rKvYcrUNyPmvt2W+AWnz+Sjra7xsurQ5e0+ycbR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 402/457] Bluetooth: hci_sock: reject out-of-range OCF values
Date: Wed, 30 Sep 2026 17:28:27 +0200
Message-ID: <20260930152354.669266534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1892,7 +1892,8 @@ static int hci_sock_sendmsg(struct socke
 		u16 ocf = hci_opcode_ocf(opcode);
 
 		if (((ogf > HCI_SFLT_MAX_OGF) ||
-		     !hci_test_bit(ocf & HCI_FLT_OCF_BITS,
+		     (ocf > HCI_FLT_OCF_BITS) ||
+		     !hci_test_bit(ocf,
 				   &hci_sec_filter.ocf_mask[ogf])) &&
 		    !capable(CAP_NET_RAW)) {
 			err = -EPERM;


