Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523EB3081DF;
	Wed,  3 Dec 2025 16:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778179; cv=none; b=kGCx8HyqvGZFZng+KWpBYce/G+z2nb1F9DdzTG+pu7ptyylgWmkbMbM5aO1Mf/C9muKGgpWQHyhjKztK22QX43JEsSOG2PFP6oDQjX5ylB2Pat9eFiBtBJaYXrhr90K3dWLxoGlDNaF3nReURPjll4teUQP067FIbueV7ytoUM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778179; c=relaxed/simple;
	bh=9cQdeC/9xnTi0HN6DxOgJyBxreyWgeocexcrkg2hhlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emFaoqF5NFnRtEF79bkAS3btYkSoPuTSEN5Tsc3X155nkTh+ttal5rqYByWUxv+t3ove+6FfE4VYnn+lt/w2HveQNpP1UAMaUO7k+RPkeCtD2UhubdYo3Z3IS8e1NiNc3+D2mCWY5rJhOodYPlbHh6q2vnNVLqoglC2teAcVbGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOIhEiG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOIhEiG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3693C4CEF5;
	Wed,  3 Dec 2025 16:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778179;
	bh=9cQdeC/9xnTi0HN6DxOgJyBxreyWgeocexcrkg2hhlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOIhEiG9PeJSt23Ce/oyZwGbfS62Lh88zHl2RFejc5lNXJoZ5uJ7n8dd4IXUYzooc
	 t1MNZydbrvKTnTdt+4TXhkChHZMKN6cAz9/AgPlqHyEgbCPKJQ18pVMzIXgywr3Xtk
	 lTuq4XEImuJXlqAorqv1OP0T1AZzXKRMPmQVzx3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/392] Bluetooth: 6lowpan: fix BDADDR_LE vs ADDR_LE_DEV address type confusion
Date: Wed,  3 Dec 2025 16:26:30 +0100
Message-ID: <20251203152423.007324096@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit b454505bf57a2e4f5d49951d4deb03730a9348d9 ]

Bluetooth 6lowpan.c confuses BDADDR_LE and ADDR_LE_DEV address types,
e.g. debugfs "connect" command takes the former, and "disconnect" and
"connect" to already connected device take the latter.  This is due to
using same value both for l2cap_chan_connect and hci_conn_hash_lookup_le
which take different dst_type values.

Fix address type passed to hci_conn_hash_lookup_le().

Retain the debugfs API difference between "connect" and "disconnect"
commands since it's been like this since 2015 and nobody apparently
complained.

Fixes: f5ad4ffceba0 ("Bluetooth: 6lowpan: Use hci_conn_hash_lookup_le() when possible")
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index cfe3753a6f160..db3e2d5290966 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -955,10 +955,11 @@ static struct l2cap_chan *bt_6lowpan_listen(void)
 }
 
 static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
-			  struct l2cap_conn **conn)
+			  struct l2cap_conn **conn, bool disconnect)
 {
 	struct hci_conn *hcon;
 	struct hci_dev *hdev;
+	int le_addr_type;
 	int n;
 
 	n = sscanf(buf, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx %hhu",
@@ -969,13 +970,32 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
 	if (n < 7)
 		return -EINVAL;
 
+	if (disconnect) {
+		/* The "disconnect" debugfs command has used different address
+		 * type constants than "connect" since 2015. Let's retain that
+		 * for now even though it's obviously buggy...
+		 */
+		*addr_type += 1;
+	}
+
+	switch (*addr_type) {
+	case BDADDR_LE_PUBLIC:
+		le_addr_type = ADDR_LE_DEV_PUBLIC;
+		break;
+	case BDADDR_LE_RANDOM:
+		le_addr_type = ADDR_LE_DEV_RANDOM;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	/* The LE_PUBLIC address type is ignored because of BDADDR_ANY */
 	hdev = hci_get_route(addr, BDADDR_ANY, BDADDR_LE_PUBLIC);
 	if (!hdev)
 		return -ENOENT;
 
 	hci_dev_lock(hdev);
-	hcon = hci_conn_hash_lookup_le(hdev, addr, *addr_type);
+	hcon = hci_conn_hash_lookup_le(hdev, addr, le_addr_type);
 	hci_dev_unlock(hdev);
 	hci_dev_put(hdev);
 
@@ -1102,7 +1122,7 @@ static ssize_t lowpan_control_write(struct file *fp,
 	buf[buf_size] = '\0';
 
 	if (memcmp(buf, "connect ", 8) == 0) {
-		ret = get_l2cap_conn(&buf[8], &addr, &addr_type, &conn);
+		ret = get_l2cap_conn(&buf[8], &addr, &addr_type, &conn, false);
 		if (ret == -EINVAL)
 			return ret;
 
@@ -1139,7 +1159,7 @@ static ssize_t lowpan_control_write(struct file *fp,
 	}
 
 	if (memcmp(buf, "disconnect ", 11) == 0) {
-		ret = get_l2cap_conn(&buf[11], &addr, &addr_type, &conn);
+		ret = get_l2cap_conn(&buf[11], &addr, &addr_type, &conn, true);
 		if (ret < 0)
 			return ret;
 
-- 
2.51.0



