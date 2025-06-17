Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18292EF297;
	Tue, 17 Jun 2025 16:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176862; cv=none; b=Zl3x9vfY9BXkAmj64mtL18lkYmN/ZT8dyAlw29KHPegRZxqCQF9VcZ9GFJkxfbg2qX8Xyx4MAIvc9WvjghJUNSLRulI9R8YOuk48bdvPTA4a6vrKAjYCOUiivwqHYh1l0OJaMzDSRIQGqHTSHi6NYB4Ev/trQMTsptx2N7mf94g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176862; c=relaxed/simple;
	bh=osnnhtOlVUHEhwU7Cgvas2yPhiG3pjAmRS/fUzKNQuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeuV2izuwZWYMxHB0k+ahm2A8Qu3VM/K8JARUvmRi24kNkVye61EZR4cF9/HOwiQWFflJIxbUmLgq2fIoBLWIoix7ajhlMAeQg8INukWvSx/9A6U2M4SDm0JxorECt0JpeKPXI1iamY4aMA0c3mpsYsrDHabfdbaCiwff5f6cwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtXdlhUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtXdlhUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3828C4CEE3;
	Tue, 17 Jun 2025 16:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176862;
	bh=osnnhtOlVUHEhwU7Cgvas2yPhiG3pjAmRS/fUzKNQuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtXdlhUKEhmnKBbTVXGcl6lS9ljaiPA6LsfY8kbt9Ivv5+b6zOjh2eafMD9EsvO9i
	 /7X0GUygCOUCsgQMIXDWhTpxGO8hcKVwoaC84RPS1LyRrnXGe+0rcQ0z9pOd72lPJP
	 Ib4hBX5h8PPd5GEth0xNGQfchZa1+CNe5YcKC3Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 320/356] Bluetooth: Fix NULL pointer deference on eir_get_service_data
Date: Tue, 17 Jun 2025 17:27:15 +0200
Message-ID: <20250617152351.039178473@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



