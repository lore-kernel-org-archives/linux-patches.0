Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAD344B66E;
	Tue, 16 Jun 2026 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625069; cv=none; b=PlHt4svBZwtnouuLvlU/+MsHthHLvZxqDGL8aj+0vQ4Ihbzi2Cb8SEmdGsDUtQYwjNRNDjvNw17MaXiKzfknxnhWuZRlo1yDx4ga31Fbb6Xq+CACVDXmaa88GyvC35Yb1Yj9qFIdZUbQIxeRGOtI4P2JlcABwfEYLd81VArz/5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625069; c=relaxed/simple;
	bh=ujBkuxjF7yTfOBd+9c1yA9DSXA1AlBfF7lPa4wB4fDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvI+FVE1ikPe3rCC+Vbbryx8Bm/n0SzMsPVoQp7Y+q03vohE9qNKtxbvOcdv78VXtJ2YVZ0qvHb1Ukk0qIbuOuYIVP0bx//DiEsv8btf9Xr1VzWNYkAtI5F2CT7gENhqu4vsnrRXeBmVDrb3P4vexkC8ObQeI7/9F9tSPNkV+bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CplkxtRf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CplkxtRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BFC1F000E9;
	Tue, 16 Jun 2026 15:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625068;
	bh=x65rtoOVcwBamyr63QJFBBUZ937NoxlWjn54SJ2c6LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CplkxtRfYNQ3Z5+Z3WR7hIDrQUj+7QsEGIO1FQJ+jrZULgJVjMQjnRm97UL/u9iLC
	 xJoxiZTU8xeB7NhcFMkcKWfnUY24W2I+zW7GbEeOnHCyqkvi3l2IFvbmQxLN0X+QB0
	 maaGuzn0MO64jiNqltvhTcQUc3sJk53kGI5vz3FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/325] Bluetooth: bnep: fix incorrect length parsing in bnep_rx_frame() extension handling
Date: Tue, 16 Jun 2026 20:27:21 +0530
Message-ID: <20260616145059.973581616@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 72b8deccff17a7644e0367e1aaf1a36cfb014324 ]

In bnep_rx_frame(), the BNEP_FILTER_NET_TYPE_SET and
BNEP_FILTER_MULTI_ADDR_SET extension header parsing has two bugs:

1) The 2-byte length field is read with *(u16 *)(skb->data + 1), which
   performs a native-endian read. The BNEP protocol specifies this field
   in big-endian (network byte order), and the same file correctly uses
   get_unaligned_be16() for the identical fields in
   bnep_ctrl_set_netfilter() and bnep_ctrl_set_mcfilter().

2) The length is multiplied by 2, but unlike BNEP_SETUP_CONN_REQ where
   the length byte counts UUID pairs (requiring * 2 for two UUIDs per
   entry), the filter extension length field already represents the total
   data size in bytes. This is confirmed by bnep_ctrl_set_netfilter()
   which reads the same field as a byte count and divides by 4 to get
   the number of filter entries.

   The bogus * 2 means skb_pull advances twice as far as it should,
   either dropping valid data from the next header or causing the pull
   to fail entirely when the doubled length exceeds the remaining skb.

Fix by splitting the pull into two steps: first use skb_pull_data() to
safely pull and validate the 3-byte fixed header (ctrl type + length),
then pull the variable-length data using the properly decoded length.

Fixes: bf8b9a9cb77b ("Bluetooth: bnep: Add support to extended headers of control frames")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/bnep/core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index b3cef7a4db5412..0de5df690bd0b2 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -330,11 +330,18 @@ static int bnep_rx_frame(struct bnep_session *s, struct sk_buff *skb)
 				goto badframe;
 			break;
 		case BNEP_FILTER_MULTI_ADDR_SET:
-		case BNEP_FILTER_NET_TYPE_SET:
-			/* Pull: ctrl type (1 b), len (2 b), data (len bytes) */
-			if (!skb_pull(skb, 3 + *(u16 *)(skb->data + 1) * 2))
+		case BNEP_FILTER_NET_TYPE_SET: {
+			u8 *hdr;
+
+			/* Pull ctrl type (1 b) + len (2 b) */
+			hdr = skb_pull_data(skb, 3);
+			if (!hdr)
+				goto badframe;
+			/* Pull data (len bytes); length is big-endian */
+			if (!skb_pull(skb, get_unaligned_be16(&hdr[1])))
 				goto badframe;
 			break;
+		}
 		default:
 			kfree_skb(skb);
 			return 0;
-- 
2.53.0



