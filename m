Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A37D3DB62F;
	Tue, 31 Mar 2026 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974338; cv=none; b=QM63+vfecGLJLaYV1fTsORqECBaz3RQPWOI6W7YV/ID8x0ZUwuSUVNmJwGmKXNz+a5dy8yG5bhKvFdRcbej3D2zhPAoPlwtJ+kGKPz+vYS1H8x5cwnxM77cGqYukSrYYpa2fqhyJdRDGWpJ+WqmxFdSE6oFRjlwekXSwYoCVoBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974338; c=relaxed/simple;
	bh=5JOkLw2mSP9GaRewlEWX33YNxIWYK1aGXCV/hqwLfAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lo/bpmXwhJxDkVf0vSFnSJDnNdCZCF2MBiZc5HnLBE8OF08cJpqGsSHIxClBzC/8uwXWvz8dMrwKC4yohfm3mDkqp/SRbjQ76EqI5fOUyRgsZMtYReGdEuKPeR8ZZT6Cfz3fIXhRYZ2SiD6tjVffFuy0ppotQyLvNe7JxTE9LAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6z3AJMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6z3AJMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9F3C19423;
	Tue, 31 Mar 2026 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974338;
	bh=5JOkLw2mSP9GaRewlEWX33YNxIWYK1aGXCV/hqwLfAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6z3AJMVGk3cXe/GNpGHAXEFx+8DEcbcEPwXxN4oxkxd3n/ELXZ4rN5RZxOZ/wwxD
	 mNmvMda3LfFheP8EGWSJnUP07v+QrQAj+bdAn4pQnsYELyumLw1LtZo+YsSgaqVv8w
	 SoSm7Q9NuHWsKNPE4ZayxPn60zZHQOi5UjG96i5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/175] Bluetooth: L2CAP: Validate PDU length before reading SDU length in l2cap_ecred_data_rcv()
Date: Tue, 31 Mar 2026 18:20:23 +0200
Message-ID: <20260331161731.221556874@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit c65bd945d1c08c3db756821b6bf9f1c4a77b29c6 ]

l2cap_ecred_data_rcv() reads the SDU length field from skb->data using
get_unaligned_le16() without first verifying that skb contains at least
L2CAP_SDULEN_SIZE (2) bytes. When skb->len is less than 2, this reads
past the valid data in the skb.

The ERTM reassembly path correctly calls pskb_may_pull() before reading
the SDU length (l2cap_reassemble_sdu, L2CAP_SAR_START case). Apply the
same validation to the Enhanced Credit Based Flow Control data path.

Fixes: aac23bf63659 ("Bluetooth: Implement LE L2CAP reassembly")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 16cc5c878305b..59cbb8cee6ee7 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6636,6 +6636,11 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
 	if (!chan->sdu) {
 		u16 sdu_len;
 
+		if (!pskb_may_pull(skb, L2CAP_SDULEN_SIZE)) {
+			err = -EINVAL;
+			goto failed;
+		}
+
 		sdu_len = get_unaligned_le16(skb->data);
 		skb_pull(skb, L2CAP_SDULEN_SIZE);
 
-- 
2.51.0



