Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90BA3B71A0;
	Tue, 21 Jul 2026 21:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667949; cv=none; b=Jd3MeQIFp5jdaMuMs0Fwdy6dK45NFkgsiRmOpHn3VIbXkaBdX5ZjTctpKgZeT4LX6S+dadAj8prCIqq4bGrjC0RfRyOn6tqCRt24Mdx8CHC9mpuihviRDhsHYGCGqZ5Z4U/zuXXO0QHHKJAPGRkbJ1B/kl1oyia83Vmg0Vv01L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667949; c=relaxed/simple;
	bh=r6Dq7uIENrXEc9LMs3vP776E+3uF1R2pXaZKdY4O7pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oje4g2uF6mrf/ytQht3Iz2DUs1MTBi4azcPPPVgfxtz/sQeFI8IzxDexim9RGTvwIca2Ofe9anHQpYAIN0YdutO+W40sopYUFoW8vB1YG1gD5VqyY57TGRMFgPUy6evSnsEeZMyvmmzpOfxNZQ2gfHks/xHZWdsHcPywYxj8Zxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wozD6HGM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wozD6HGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD461F000E9;
	Tue, 21 Jul 2026 21:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667948;
	bh=jLWCDsr4ZuBqu/tXWzuXH9oUOB1fqgyUI780WOD5aaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wozD6HGMvypOQRTHwqL1rtYdo2RBdpyuF3lsPIj7CDzbQskL9pS6rd+/nHluTGGcd
	 b3ZSwDsSNHaGFp8nQDkukB7V/9Klj9ukfGuSfFQ2/7Yz/RzbwNj7wxDpHsBi7BO1Vj
	 wm5CeTdmiap0VYIiR4TIfApyO+EVVxfmV2cX+inU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 1255/1266] Bluetooth: hci_sync: Fix attempting to send HCI_Disconnect to BIS handle
Date: Tue, 21 Jul 2026 17:28:12 +0200
Message-ID: <20260721152509.907999576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 314d30b1508682e27c8a324096262c66f23455d9 upstream.

BIS/PA connections do have their own cleanup proceedure which are
performed by hci_conn_cleanup/bis_cleanup.

Fixes: 23205562ffc8 ("Bluetooth: separate CIS_LINK and BIS_LINK link types")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5529,7 +5529,7 @@ static int hci_disconnect_sync(struct hc
 {
 	struct hci_cp_disconnect cp;
 
-	if (test_bit(HCI_CONN_BIG_CREATED, &conn->flags)) {
+	if (conn->type == BIS_LINK) {
 		/* This is a BIS connection, hci_conn_del will
 		 * do the necessary cleanup.
 		 */


