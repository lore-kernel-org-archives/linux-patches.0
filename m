Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CBD1EB1AA;
	Wed, 17 Sep 2025 12:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112733; cv=none; b=Zql3VZvXQYEMWZk8kTJ2l1mmXUeUzZW09ZZen6Qr0vM3OW5RLMJOkbo5KLyecGHmw5IDPbm4hD7Y1qDWNtxQ7+Mu+usA/YKzMb3ivPAfXB0a/RRHM1WBW+EnSV8BUCx9yvVHvEXSVvtAnwVLc09yO/nfuXoKCVGOd3wKt4EIFls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112733; c=relaxed/simple;
	bh=qEcqK5RNs/NEV0QMYXImaPwRrzMACypBjQBKD/QMXhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNwtC205uKuOHseeaxiVw4oBiEOcq1sfsDrWgcdvVNhmCOEZ6z9E1Odnxqe6i2xhuDKoEaTe82hYHyKJ+PG4tVMpPKNJvgaLyR+rCZBgF9xQIr4APoHsWJ6hFL0S+/3AwmLPhAbDEvNR0CFjS3Zq+g9YCWMdGi6kYKaUEFPvFos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JU1qJAxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JU1qJAxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D9CC4CEF0;
	Wed, 17 Sep 2025 12:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112732;
	bh=qEcqK5RNs/NEV0QMYXImaPwRrzMACypBjQBKD/QMXhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JU1qJAxG4UMd/EhqlQApKGL08b5BmdtOSTmAyck/Enuzu7TS2qrGE+iumJZ8VWYTy
	 /94qijdx4X6YwD9GAlH8zbi/1ODokMaPMKQ2M4ZyYWzj4kimn6vtCQrNVLLixMJEa9
	 zJzkFrLVgqEKUspHzB7yqejM00FxS8UnevjV34vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 015/189] Bluetooth: ISO: Fix getname not returning broadcast fields
Date: Wed, 17 Sep 2025 14:32:05 +0200
Message-ID: <20250917123352.222197817@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit aee29c18a38d479c2f058c9b6a39b0527cf81d10 ]

getname shall return iso_bc fields for both BIS_LINK and PA_LINK since
the likes of bluetoothd do use the getpeername to retrieve the SID both
when enumerating the broadcasters and when synchronizing.

Fixes: a7bcffc673de ("Bluetooth: Add PA_LINK to distinguish BIG sync and PA sync connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 14a4215352d5f..c21566e1494a9 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1347,7 +1347,7 @@ static int iso_sock_getname(struct socket *sock, struct sockaddr *addr,
 		bacpy(&sa->iso_bdaddr, &iso_pi(sk)->dst);
 		sa->iso_bdaddr_type = iso_pi(sk)->dst_type;
 
-		if (hcon && hcon->type == BIS_LINK) {
+		if (hcon && (hcon->type == BIS_LINK || hcon->type == PA_LINK)) {
 			sa->iso_bc->bc_sid = iso_pi(sk)->bc_sid;
 			sa->iso_bc->bc_num_bis = iso_pi(sk)->bc_num_bis;
 			memcpy(sa->iso_bc->bc_bis, iso_pi(sk)->bc_bis,
-- 
2.51.0



