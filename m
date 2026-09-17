Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E1F2E282B;
	Thu, 17 Sep 2026 17:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664985; cv=none; b=pB0ng9j87YTkBIXddtR5Q49zthhmIpDSOCthQLeXXxOt8IiAqg1gUh5EkRfF/SLkpsJ65+z3OETuLjtizFvXGkQNr71bCFXoF98OhQ63kK1ESpuiSK2T+a7rS7hd5TZ7fl3WI4OcRx2L0fe5AGBMPZBL9AXjqLGx0+LrNI1CopI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664985; c=relaxed/simple;
	bh=ewKG9WwYz8JR3jSi3X6Gzj+zKV0vOHmnDqAZehNCpQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihGXXF4PFkw+l15FGC618WFwSNto/ZvAEaeG2kVQmeqcKfM3eW6svWkgNhf6AUW1VXuXiu0E679UvoFXy70Li86dk6A0/eYCFJOpCZKXwR/W2XsYltUJY/7B+RBhaJsOXkbetNCpAy5/Gzh1496dAxKIeaeCA0NUgk3y1gvbQyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucy7aWs9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucy7aWs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9C41F0089A;
	Thu, 17 Sep 2026 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664984;
	bh=Vx9BPypgLYHLYvELhEQqIC5+HxHjG+2nKf73sa/vqHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ucy7aWs9pIFWhY6hDlR9U5GRBYZbAh3UOTCtPcaplnKYw/8dgvgqoRU5BUhQb304w
	 31YIrlzumF5CULl5mH3xn2EeZilkUGvvyBno/6YG0+Uph33x5bTTmHSHbjtrFwhCO9
	 I2HPxSBW+oSv1iqn254Pu5OmTEx7BT+C3q1Mmz7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0552/1250] Bluetooth: RFCOMM: validate skb length in rfcomm_recv_frame
Date: Thu, 17 Sep 2026 16:05:47 +0100
Message-ID: <20260917151606.895520710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6571b33d553ea..45f8cfebcc6a6 100644
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



