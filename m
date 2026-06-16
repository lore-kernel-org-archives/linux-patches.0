Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127863D8105;
	Tue, 16 Jun 2026 18:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634080; cv=none; b=O1j1Z/khL9v2bagAMtbMlZiW1LG4kAVv1no7M3rv51cLW0d6sjaHonOPyrbNp4h3qqv2MpCnBt45vNYZUFKFy87iuQ8w443A6RZagLHVWdjE2y5Y1tPARERndblOFoaFEmwOQ7RBB3ifpRH9l05FGpmPb00buBO8izc3YsStoXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634080; c=relaxed/simple;
	bh=0DRJpwypuUaUxO6/G2qfesozHrif0FvpqVB6T9jh6MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eP8mZBFuuk0KwXQPvO/guAvhGP8azlU1APMOXV28cibTCST9U0fe15gahOlwVdNpGi4iK20s4giGkOxf8QPDeu8Xa+tw4UKFuukdCGLNOp+51IZdEmPDutdq2heyEupYY53OqnHbXQy5l+RZDqtV378jkE9jxwevohAV3gnnx7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p21VZ8J6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p21VZ8J6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D431F000E9;
	Tue, 16 Jun 2026 18:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634078;
	bh=VRF47LZJGngGM7uR3x2yZbARpjXYtHE761ejhfGmVzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p21VZ8J6wP/2cXQ9TaljD4g6AfyNWCkgiQu0KKUB63hwqFCuj5FGWJbc/Uojj31x/
	 EqL1EVS9YQiOlIQ2nH1N6xcARBbbffanTzpdD4unr/9yjlkqlLiuYJMWGBnnAHrtac
	 hyF3rQQ6KJizThZNvX53QLiUHCswlB13+oWGor0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/411] Bluetooth: bnep: fix incorrect length parsing in bnep_rx_frame() extension handling
Date: Tue, 16 Jun 2026 20:26:43 +0530
Message-ID: <20260616145109.285555902@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
index f3b9c1dee1bb61..1798069ce79149 100644
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



