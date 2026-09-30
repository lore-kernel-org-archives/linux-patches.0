Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8AB50EC15;
	Wed, 30 Sep 2026 18:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791293; cv=none; b=fimTeIWxePOTOnA/AZiVm/3uyo/r28YcMjO9tGWa8UiAxdLKe4jehcGKDqYxBn2eKP6El+5d/PxLD5GFfobLn+DZHYD9WktyBvNYzpYGYDCD/nM6CIt2cduVPDbfjhK6uaJGl5KxCk87IpWLD82yxD3oJRrRrLMi6MgJ1apFURs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791293; c=relaxed/simple;
	bh=1ucMqCNG7m+Fh/ldo7ph2ByA49S5MGE98rscqiF1i/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKY+aYhnIn2WQSOrTCvUmJfeMJJPxNpXUPbmQ0P9OR2xfR5ESx7pCr+NPmGODac4x2VFOOEksM+0b8Ua6fMCso/5y5kohvxDTTUaCfXztB0fo7IlWdVy5jyEmq/FE5MnIL/dpFuhbeyfJupD5ifdJb54QQgzYTS1yLMKmctYW9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsumf5rq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsumf5rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E3B1F00898;
	Wed, 30 Sep 2026 18:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791292;
	bh=b/Y2er3/J4CaTrMxalNOKxU4BhKOTUAIRzRjnBp3lHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bsumf5rqhaZnog7JVJ7TM2ECJwVX77b1A9xGShhscxTpYESVS7W9oNjh4gxJz9Vy7
	 MW2Co5qUi0TSrZzQTL4QaoG5wRUeZaOA/F0cVCsxnED41F6zxYRzHrLyer+mCu8Ty4
	 cgF7JmxUjBy1oG9OcO3Vp8nTrH6KN47Ys1A6eGps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 224/752] Bluetooth: RFCOMM: validate skb length in rfcomm_recv_frame
Date: Wed, 30 Sep 2026 17:21:34 +0200
Message-ID: <20260930152403.102566661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2914ac1c50024..104d75908dbc9 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1813,6 +1813,11 @@ static struct rfcomm_session *rfcomm_recv_frame(struct rfcomm_session *s,
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



