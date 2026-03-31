Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862F9413225;
	Tue, 31 Mar 2026 16:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975717; cv=none; b=pz9uoqWaATrfCAAsGf5DifRJ5ZhwcjspoLBTSNQZ/nN+389ayPzCxe6DdkR4SxeFUbRBkvxFNdrl4h8k+F1WNFuINnwA3XLYAoCRLYdIm4kZEVQBX3m+Y2HNWSDy5n7fD+16vZtcLhjqr1xlM4etSg9/bk4CcKZ+/K6oFidGyj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975717; c=relaxed/simple;
	bh=Ak4oB30WJLkSj8ms+BZ3I7hihOm5bIh3LqkN4RUm390=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lo8JLQ9t+4UM278LpPUIYcI3kXxgFK5dsNHqFEi7HAjaLZBuKvEFx9ZzYd/Eb3hX50jF204Q3TJJZiAMGXIVz5edBQR+jyY529l8XnljwxqP8MtXtwfDfJ+Vmy1MK5IR+vPpHtNifKNV2Q+/xw7MxFoleXjlpZX8iYjjXa0zSG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IecMb9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IecMb9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EC9C19423;
	Tue, 31 Mar 2026 16:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975717;
	bh=Ak4oB30WJLkSj8ms+BZ3I7hihOm5bIh3LqkN4RUm390=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0IecMb9ZCoOHevoHYqEQ114L9r1wx/1a9bCZNzM7Kl3QkY5JHSvdyCUr4dleiMf0y
	 6C7VBsH9xZssh3KL4OzzMc9Lkplg5ZxeG+J0cHL+Su9TYXFhY6yzheMPqIxQEWHTs/
	 aMgJx6VURQMxlRAiMgIVzjS1r9A28I/9sUBqVd08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/244] Bluetooth: L2CAP: Validate PDU length before reading SDU length in l2cap_ecred_data_rcv()
Date: Tue, 31 Mar 2026 18:20:09 +0200
Message-ID: <20260331161743.870315929@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
index 13f124cc4b6b1..c65724d19fcfe 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6637,6 +6637,11 @@ static int l2cap_ecred_data_rcv(struct l2cap_chan *chan, struct sk_buff *skb)
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



