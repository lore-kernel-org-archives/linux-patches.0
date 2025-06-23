Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB2019049B;
	Mon, 23 Jun 2025 21:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715631; cv=none; b=mXIyYNRubIswvFh6Zd9UKDu+SN01O5I1UEMTjU91Xq2tcdP1RzqjNUNqZ0Wkp6KxpxaOUOsYWHSCnXNztH6o3Ho2ZozT8/wPR6FV/eXh89UUE9oZbWh1xYQ8QvvndoclAXW3hXBEyewIw8opsrFy8EOH8gtISzWMABeSNioLKLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715631; c=relaxed/simple;
	bh=ZwXgt7IlMzR4s6uJv553kRBKcZh6DvY1eCrJflbs6/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOBWtleaFFhHaO5uG4+yPaNRd5IdOQZtOSj7lOgw3Uhl0PU+45UwPYzS88vAz8bPbB2rmu+pqHHnVEmlZnjnSqeBDUazUbRdvobGjzF6r+BJoKcv7pnqyun5FuhfZSl4zPzXLOiGFy+AilKdgoYDB2kvKLgjYHM4ywPfRbRArJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omHmigGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omHmigGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EFBC4CEEA;
	Mon, 23 Jun 2025 21:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715631;
	bh=ZwXgt7IlMzR4s6uJv553kRBKcZh6DvY1eCrJflbs6/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omHmigGLaqdpzp3Nl1uqdFAXwpInfJoIWdyp0wsitTy0BR/6w5UGsl44dJj68XNF3
	 1jGZfxuwI+pOHuQMgm1E6pN2xoCZxmRK9cLAInJdiM1XdW7aFNjRVrrYHU6k3ulrPH
	 vrX2BQJHA5/MZM6TT6fH7tXNXy8zcN1y2wdqwVmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 252/508] Bluetooth: Fix NULL pointer deference on eir_get_service_data
Date: Mon, 23 Jun 2025 15:04:57 +0200
Message-ID: <20250623130651.450584185@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 20a2aa01f5aeb6daad9aeaa7c33dd512c58d81eb ]

The len parameter is considered optional so it can be NULL so it cannot
be used for skipping to next entry of EIR_SERVICE_DATA.

Fixes: 8f9ae5b3ae80 ("Bluetooth: eir: Add helpers for managing service data")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/eir.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/eir.c b/net/bluetooth/eir.c
index 1bc51e2b05a34..3e1713673ecc9 100644
--- a/net/bluetooth/eir.c
+++ b/net/bluetooth/eir.c
@@ -366,17 +366,19 @@ u8 eir_create_scan_rsp(struct hci_dev *hdev, u8 instance, u8 *ptr)
 
 void *eir_get_service_data(u8 *eir, size_t eir_len, u16 uuid, size_t *len)
 {
-	while ((eir = eir_get_data(eir, eir_len, EIR_SERVICE_DATA, len))) {
+	size_t dlen;
+
+	while ((eir = eir_get_data(eir, eir_len, EIR_SERVICE_DATA, &dlen))) {
 		u16 value = get_unaligned_le16(eir);
 
 		if (uuid == value) {
 			if (len)
-				*len -= 2;
+				*len = dlen - 2;
 			return &eir[2];
 		}
 
-		eir += *len;
-		eir_len -= *len;
+		eir += dlen;
+		eir_len -= dlen;
 	}
 
 	return NULL;
-- 
2.39.5



