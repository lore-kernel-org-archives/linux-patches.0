Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89DA2EA161;
	Tue, 17 Jun 2025 16:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178170; cv=none; b=dF95rrulLwubQOurL5FlCnzrPTTBc5YBFfGynYkMNDHFNgwx7T9PN9kwB6yY3ua0RejO9ZAywrbmrrNz8hAjO01YZ7ZsyyC02D6KTKKOnb/OgoyWLXSqL+/Zugiek3XlfJvkT17mP9MHwPfLG/C5qyB9/zSzelOMRtA2WEPqHv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178170; c=relaxed/simple;
	bh=robSoHqr+uHniB7bDjoVC6fA0+ijXjqGLYqkeqC+Vf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZylY3kwFSUbDcWqJG+u6LMa+WCFTleSYSz1DI7/suPXcOoMdWW03mC+ABsuMrr+hVvyd+hgviPE+A/4rdNOTIntcQ4XUVhLSvfkUr/GkAnubLcWzI4jEEslHhG2HXjLPZO7oYUSOq9O1/9aKfrpDdq+KKr2t7tQNVzW2Lr1WaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeHz4Sez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeHz4Sez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22794C4CEE7;
	Tue, 17 Jun 2025 16:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178170;
	bh=robSoHqr+uHniB7bDjoVC6fA0+ijXjqGLYqkeqC+Vf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeHz4Sez9D0i0WEnWFjA4qb8M5CgXWy41g9HlQnpmEJtneRYivcLN6f9RSXBz9N+H
	 O8R7kxYY2sji5su7v8UO6Q01sOjuI2xrzkx6kg5U0sYo787/2ENrNRSLsDaDhKLxNv
	 681kj08Dcr1wlDeAepAK5KnevFD9sY/mIlZLf3x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 456/512] Bluetooth: Fix NULL pointer deference on eir_get_service_data
Date: Tue, 17 Jun 2025 17:27:02 +0200
Message-ID: <20250617152438.050523517@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



