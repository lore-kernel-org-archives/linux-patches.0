Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562DF4086A;
	Tue, 11 Nov 2025 00:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822416; cv=none; b=NPs2FC4pCH1t6milIFo22M37LPv+PzpeAdvI4heZL9Lu+JoNWwesPymrKh1bC4snyK0mYTJ2/f/kFJJJEK0y2ttsZCnZMbP33bJMGIU+eyyXRufS8D92E+ezondCLjhjX+lkQt3M8QclLhKTsqRneg15+OyMV8mRlPdZMjMT3n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822416; c=relaxed/simple;
	bh=Z54eTXKhxkVJYharBgxLrt/rYDzJkptu2vHojN6uIo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRKDIFti+1zSan2aFNNd/nM9BwU6xF2EG29ks+GEiOwz9gskpGkDH6epJ1S/L7WLcuxeGOe8axSPBXDYU0BNPzbTMGFT+3l/9gYNHm8aAGJXyULPQt1yRuYHVR7qi8F1vhXyVeYVBKEm9pcaKRHW9GRlL1vem0sg77IPL2RNnSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlWgiyNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlWgiyNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAD2C113D0;
	Tue, 11 Nov 2025 00:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822416;
	bh=Z54eTXKhxkVJYharBgxLrt/rYDzJkptu2vHojN6uIo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlWgiyNGMlYPa2pjJGSe6q2V/cQOCgSQwdtcUegBl7MDbpDeN50+94/z0oJB10cLS
	 CZgLNHwrfpEYmZmCGUlipaZ4Q0xlgfYcaaesMP6yDvOLt+ITAU9WVBmICKJPqFWcar
	 FykgBC9m7BOby+cLOpEhxFHsk8mhbHPyvOlUVNJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/565] Bluetooth: ISO: Fix another instance of dst_type handling
Date: Tue, 11 Nov 2025 09:38:22 +0900
Message-ID: <20251111004527.941327411@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c403da5e98b04a2aec9cfb25cbeeb28d7ce29975 ]

Socket dst_type cannot be directly assigned to hci_conn->type since
there domain is different which may lead to the wrong address type being
used.

Fixes: 6a5ad251b7cd ("Bluetooth: ISO: Fix possible circular locking dependency")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index c9a262f97678b..a48a2868a728b 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1939,7 +1939,13 @@ static void iso_conn_ready(struct iso_conn *conn)
 		}
 
 		bacpy(&iso_pi(sk)->dst, &hcon->dst);
-		iso_pi(sk)->dst_type = hcon->dst_type;
+
+		/* Convert from HCI to three-value type */
+		if (hcon->dst_type == ADDR_LE_DEV_PUBLIC)
+			iso_pi(sk)->dst_type = BDADDR_LE_PUBLIC;
+		else
+			iso_pi(sk)->dst_type = BDADDR_LE_RANDOM;
+
 		iso_pi(sk)->sync_handle = iso_pi(parent)->sync_handle;
 		memcpy(iso_pi(sk)->base, iso_pi(parent)->base, iso_pi(parent)->base_len);
 		iso_pi(sk)->base_len = iso_pi(parent)->base_len;
-- 
2.51.0



