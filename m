Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616EA4C97;
	Tue, 11 Nov 2025 00:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822402; cv=none; b=A5eFoD5/T4TY8Zvr9VT7VNU8AbZPaC18h5uZTb2TpqfeQqJv9dP4DX1aYHGxrK5XBndOsoaYwhwi+K0DgjDAM1BflC5vq75xUUA1EKSxchPWnuWmAKimyz6yopVKjgspewo9mhmh4Q9tZbCL+IeLx/NP/My3rMSfTzNJpPtSViE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822402; c=relaxed/simple;
	bh=JuwhFDiPMhQlKT3rCQZOlaScnVQk832qro1z4qxErpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL8EaHf4SkLMMSz+jMLx2InNRgZxvWpj8eAUkTz35cD4D8eHUF+RRFkB4CfWUmfr/0XMfE5wOn4K3KTcCJeSTmIh8Wv921dUc/39KSfkKWFrdeWFlIRQPRtOoVtxUHwooFOItQw+MRGh2+ZG13g2RmGsqwBIZbuK8YV1lJ7dXhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTjgJy43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTjgJy43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C237DC4CEF5;
	Tue, 11 Nov 2025 00:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822402;
	bh=JuwhFDiPMhQlKT3rCQZOlaScnVQk832qro1z4qxErpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTjgJy43PORPKe0I9F5zXEMw6cPxAUbRnqWo1Jax+CrFovetfZSqz23jMCM2ioc7f
	 ZR/UlQ7kDFekIHTNLKuQWHi3QQQAm+eqBc/+shmi/w5Msy0WJKM8RA0/NjJiFqIdqt
	 /1aIFvM51w5JpUg1sPSbS/jsoL5IKf+a8pANOOks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/565] Bluetooth: ISO: Fix BIS connection dst_type handling
Date: Tue, 11 Nov 2025 09:38:19 +0900
Message-ID: <20251111004527.869081465@linuxfoundation.org>
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
index f48a694b004ab..c9a262f97678b 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1927,7 +1927,7 @@ static void iso_conn_ready(struct iso_conn *conn)
 		 */
 		if (!bacmp(&hcon->dst, BDADDR_ANY)) {
 			bacpy(&hcon->dst, &iso_pi(parent)->dst);
-			hcon->dst_type = iso_pi(parent)->dst_type;
+			hcon->dst_type = le_addr_type(iso_pi(parent)->dst_type);
 		}
 
 		if (ev3) {
-- 
2.51.0



