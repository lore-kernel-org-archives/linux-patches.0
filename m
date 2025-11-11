Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74152BB17;
	Tue, 11 Nov 2025 00:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822209; cv=none; b=D/isVcU7O56kaWMDc+dhbErwokKiRJP0p03YuoKEpnMzBKNBpxjlyxn838Q7PdX7xvvsJ0MZ77z0f6VsjvKKVgpdth8EtpwjoUG8O7MFX4b1IfX5gRtRfEoRQ8Hr2+l5F8DPrObB/6IcnJDYD1cZHYqD+qjHpIhh8OUYRuicPnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822209; c=relaxed/simple;
	bh=R1g5+F+8f2A0jUpoedsd2QiuLLRsjH0nTKy9r0je0IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNilZSMng1Mog1cXLxUMwhwKt+8CQZ9d73MBYyt2GmGHYnpFU12tPT6Kjromzm2cmP47CTYqr5v8eS9nru6aErySvaQJxMEKpV8OTum4R19bqjdjj8l3xpCk0lgQlciHKoIrY/LU+7oL+3cLtDQ37mabvuBUFd/UMPDQva5H2DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3onaASw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3onaASw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A133C4CEFB;
	Tue, 11 Nov 2025 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822208;
	bh=R1g5+F+8f2A0jUpoedsd2QiuLLRsjH0nTKy9r0je0IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3onaASwE1Ruw15G9iM9X4gv1+JXgHjJnmSgw83Yp7HRFfCDpsvHpn1nBZHPNp9s1
	 UGwJaXRTMNbu5b+R5Mgy4tK1fl6UFniW2SXcacCXDTMU+ZGqToHobY570v/N5X82fC
	 XtSto1Z9dd5MDaKbT9ZJ2MdIehwJ4mnlY/FIgKtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 058/849] Bluetooth: ISO: Fix BIS connection dst_type handling
Date: Tue, 11 Nov 2025 09:33:48 +0900
Message-ID: <20251111004537.838001788@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f0c200a4a537f8f374584a974518b0ce69eda76c ]

Socket dst_type cannot be directly assigned to hci_conn->type since
there domain is different which may lead to the wrong address type being
used.

Fixes: 6a5ad251b7cd ("Bluetooth: ISO: Fix possible circular locking dependency")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 88602f19decac..4351b0b794e57 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2021,7 +2021,7 @@ static void iso_conn_ready(struct iso_conn *conn)
 		 */
 		if (!bacmp(&hcon->dst, BDADDR_ANY)) {
 			bacpy(&hcon->dst, &iso_pi(parent)->dst);
-			hcon->dst_type = iso_pi(parent)->dst_type;
+			hcon->dst_type = le_addr_type(iso_pi(parent)->dst_type);
 		}
 
 		if (test_bit(HCI_CONN_PA_SYNC, &hcon->flags)) {
-- 
2.51.0



