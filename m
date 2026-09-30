Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6652AEEB;
	Wed, 30 Sep 2026 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794789; cv=none; b=J67qAF6kGgn8qMvq7JpDGRzu2MlXChXmMcyM4R3p0MBx2hqSKbr3q6xMPujiEYiXJ2VTR7Zqfl0mjLmNnLzj6Z+6ccWPeAVvVzw2jZy/wpqSKdHrS4voY+DLmyVa+uM2Pqf4q0chkwn+Y8akJjlca7Pjcf8QmeyBboWZWTYWRzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794789; c=relaxed/simple;
	bh=gxMfFrYbPj7q8ytqju6XBGUgJTj9PO1vsA7jdP6SUjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exP40IHHAjM8QMpNHLZTO5dTF0LvUlrwCMHY+C7l7UZU0i5i2HwAWaSEYkB6RKhJfMkoL9NDmy+qeetsFHgxnrH71xass1usR7uwivzafOw0AsPBAIAkUa+6Z3IUnXC5kYfC8NeB3LwfcDt72v9A2buqkrpC/mrYCPazQiar3GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FjaN3rE6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FjaN3rE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555461F000FF;
	Wed, 30 Sep 2026 18:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794787;
	bh=FSvTjwzDn9Vl1cAv8rnz3O7b5TQZQe2lJrnDTd2OQf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FjaN3rE66P/E4bUCthZNwR8qTf6ZsBUjjWs3eCcwfIlnH+gEJMPLRF5RnnH2YyA+x
	 eTfeVBagaqxNO2EqHRBBm6m+soPGISAp9rCR5XKNflm6eXqBUb+TU49DxDV0dzQY+5
	 gkjE+aKNNa0GvqYF39/i9AkStHSApMpeYqU3fuSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0335/1193] Bluetooth: RFCOMM: validate skb length in rfcomm_recv_frame
Date: Wed, 30 Sep 2026 17:16:59 +0200
Message-ID: <20260930152441.597021441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit b230e5bf501c5edaf2eb0991cb862ac142031d4b ]

rfcomm_recv_frame() casts skb->data to struct rfcomm_hdr and dereferences
hdr->addr and hdr->ctrl without validating skb->len first. A truncated
frame with skb->len less than the minimum header size causes an
out-of-bounds read of uninitialized memory. Additionally, a zero-length
frame causes skb->len-- to underflow to UINT_MAX, making
skb_tail_pointer() read far past the buffer.

Commit 23882b828c3c ("Bluetooth: RFCOMM: validate skb length in MCC
handlers") fixed the same class of missing-length-check bugs in the MCC
sub-handlers, but the top-level rfcomm_recv_frame() was left unfixed.
KMSAN reports:

  BUG: KMSAN: uninit-value in rfcomm_run
  ...
  Uninit was created at:
    __alloc_skb+0x474/0xb60
    vhci_write+0xe9/0x870

Fix this by rejecting frames smaller than sizeof(struct rfcomm_hdr) + 1
(the minimum frame must have a 3-byte header and a 1-byte FCS).

Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 390107643a76c..9801e236c307f 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1817,6 +1817,11 @@ static struct rfcomm_session *rfcomm_recv_frame(struct rfcomm_session *s,
 		return s;
 	}
 
+	if (skb->len < sizeof(*hdr) + 1) {
+		kfree_skb(skb);
+		return s;
+	}
+
 	dlci = __get_dlci(hdr->addr);
 	type = __get_type(hdr->ctrl);
 
-- 
2.53.0



