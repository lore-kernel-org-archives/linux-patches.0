Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AA83B5308;
	Mon, 23 Mar 2026 15:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278939; cv=none; b=d5V7/jsWhCu8zWvuSBumMAxqkCeCQRU1bq/dDu+ongKZD1kKSjGF7+i5CgCx0X/Yffi1yCNY8+mvNhoeOOW5Dm0vOyjZcRkoJP0ZJ59YE6Y9sTgluH1om4ThyVH4GJMjHesnfLemkGkjlq1YRMSuCfrJV4WeXJSyRs8LvMGicdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278939; c=relaxed/simple;
	bh=ty7j8Q0wyQG56YIiHMSq9CBuiFu0PpkP+qDm9qzopzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LmzSVd2ylpWAArHmzO1S5kf//jct1Z7yp3j6/iUOEgaQ2jDXtIkQlYsATBSGggaxqHGgX2kftqpXPbqbkM+bQjnN8drWQmZZXIrELdx5ftHJUWjDb6Mjelda9aF/SJhlpFbiJ30I6CErHrle6U6qm3UzjAavooE4n9Vz5h3RGWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnxLUxod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnxLUxod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2699DC4CEF7;
	Mon, 23 Mar 2026 15:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278939;
	bh=ty7j8Q0wyQG56YIiHMSq9CBuiFu0PpkP+qDm9qzopzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnxLUxodxdozc5E+BU6ZVXsmxK7WuTqfjTy6WMsK48cDzNSw2pRvtO5m3Ho73Ym7z
	 PvQkhDnbC0SkwrWTYNd9hO3LyLNuF//P4bXJ1JogteSuJnzb1uFjCSXLNjeVkiEhIn
	 L36oqLchSpUU1GPhPaRtmRbABAJ5Y73CSYgMQLoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lukas=20Johannes=20M=C3=B6ller?= <research@johannes-moeller.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 460/567] Bluetooth: L2CAP: Validate L2CAP_INFO_RSP payload length before access
Date: Mon, 23 Mar 2026 14:46:20 +0100
Message-ID: <20260323134545.365747060@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Johannes Möller <research@johannes-moeller.dev>

commit dd815e6e3918dc75a49aaabac36e4f024d675101 upstream.

l2cap_information_rsp() checks that cmd_len covers the fixed
l2cap_info_rsp header (type + result, 4 bytes) but then reads
rsp->data without verifying that the payload is present:

 - L2CAP_IT_FEAT_MASK calls get_unaligned_le32(rsp->data), which reads
   4 bytes past the header (needs cmd_len >= 8).

 - L2CAP_IT_FIXED_CHAN reads rsp->data[0], 1 byte past the header
   (needs cmd_len >= 5).

A truncated L2CAP_INFO_RSP with result == L2CAP_IR_SUCCESS triggers an
out-of-bounds read of adjacent skb data.

Guard each data access with the required payload length check.  If the
payload is too short, skip the read and let the state machine complete
with safe defaults (feat_mask and remote_fixed_chan remain zero from
kzalloc), so the info timer cleanup and l2cap_conn_start() still run
and the connection is not stalled.

Fixes: 4e8402a3f884 ("[Bluetooth] Retrieve L2CAP features mask on connection setup")
Cc: stable@vger.kernel.org
Signed-off-by: Lukas Johannes Möller <research@johannes-moeller.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4585,7 +4585,8 @@ static inline int l2cap_information_rsp(
 
 	switch (type) {
 	case L2CAP_IT_FEAT_MASK:
-		conn->feat_mask = get_unaligned_le32(rsp->data);
+		if (cmd_len >= sizeof(*rsp) + sizeof(u32))
+			conn->feat_mask = get_unaligned_le32(rsp->data);
 
 		if (conn->feat_mask & L2CAP_FEAT_FIXED_CHAN) {
 			struct l2cap_info_req req;
@@ -4604,7 +4605,8 @@ static inline int l2cap_information_rsp(
 		break;
 
 	case L2CAP_IT_FIXED_CHAN:
-		conn->remote_fixed_chan = rsp->data[0];
+		if (cmd_len >= sizeof(*rsp) + sizeof(rsp->data[0]))
+			conn->remote_fixed_chan = rsp->data[0];
 		conn->info_state |= L2CAP_INFO_FEAT_MASK_REQ_DONE;
 		conn->info_ident = 0;
 


