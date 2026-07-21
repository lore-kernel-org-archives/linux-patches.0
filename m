Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF35400DFC;
	Tue, 21 Jul 2026 20:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664041; cv=none; b=gzh5IFEIRevLfnGZEwj3CuDPREzQwP1n+VYS2+s/n++BT08lLAx8GIG4jbM5GzySotXhT3HEtMsCniyXPegHYnLk4jf7zX8E7kYcKeJ1YzHB+1BMg+eO6S+lQ1g49LjjVhFQl+bZl9QtDiVGmAsd4sla29jiYgg1SudRC/0hB7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664041; c=relaxed/simple;
	bh=h0nzPOH+tBv2GdfTFhZkCDhm3Z639BB/1wU75j+fr0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=am519bn09t2DSnylgzdLZuHdnVHW8syO7LQocrb80HYkIBKMz2GM4cJILEAxKaEFOt/h5d2i7euW/evr3UtombMOWt4Q+N10h0TX6RI/VO1UcpiPXG7SR7vys7gJKzJRb4663UB2NUUK+jaUjfwCa9ObcoQlkrKn9ltFZxI7Gcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lIox14+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIox14+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87E21F000E9;
	Tue, 21 Jul 2026 20:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664040;
	bh=M1d5pke9maFiiTMIhXV0PTfwdekWI6Hkxq+Xt/V/iJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lIox14+n77FW8P513kU8Im0wZHLvAhk3XqjKvx3MMRhSq1idAdkEQ5K7ydLFae/32
	 /TrFItc/6hnvtZY555H9LlVmUMOMfPyGnN8S09XK9Rlhp2CxYxalLmMnHxJBua5yNK
	 /HJAD7PEjI9wK8nMX4NfPPKY05L5GSDq1jnIFzKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Arthur Kiyanovski <akiyano@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 1049/1276] net: ena: clean up XDP TX queues when regular TX setup fails
Date: Tue, 21 Jul 2026 17:24:52 +0200
Message-ID: <20260721152509.464289192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 1bd6676254b4ab6acd44b662b5e92822c036463a upstream.

create_queues_with_size_backoff() creates XDP TX queues before setting
up the regular TX path. If the subsequent allocation or creation of
regular TX queues fails, the error handling paths omit the teardown of the
XDP TX queues, leading to a resource leak.

Fix this by explicitly destroying the XDP TX queue subset at the two
missing failure points.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc7.

An x86_64 allyesconfig build showed no new warnings. As we do not have
an ENA device to test with, no runtime testing was able to be performed.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Reviewed-by: Arthur Kiyanovski <akiyano@amazon.com>
Tested-by: Arthur Kiyanovski <akiyano@amazon.com>
Link: https://patch.msgid.link/20260616142424.4005130-1-dawei.feng@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -775,6 +775,18 @@ static void ena_destroy_all_tx_queues(st
 	}
 }
 
+static void ena_destroy_xdp_tx_queues(struct ena_adapter *adapter)
+{
+	u16 ena_qid;
+	int i;
+
+	for (i = adapter->xdp_first_ring;
+	     i < adapter->xdp_first_ring + adapter->xdp_num_queues; i++) {
+		ena_qid = ENA_IO_TXQ_IDX(i);
+		ena_com_destroy_io_queue(adapter->ena_dev, ena_qid);
+	}
+}
+
 static void ena_destroy_all_rx_queues(struct ena_adapter *adapter)
 {
 	u16 ena_qid;
@@ -2074,14 +2086,21 @@ static int create_queues_with_size_backo
 		rc = ena_setup_tx_resources_in_range(adapter,
 						     0,
 						     adapter->num_io_queues);
-		if (rc)
+		if (rc) {
+			ena_destroy_xdp_tx_queues(adapter);
+			ena_free_all_io_tx_resources_in_range(adapter,
+							      adapter->xdp_first_ring,
+							      adapter->xdp_num_queues);
 			goto err_setup_tx;
+		}
 
 		rc = ena_create_io_tx_queues_in_range(adapter,
 						      0,
 						      adapter->num_io_queues);
-		if (rc)
+		if (rc) {
+			ena_destroy_xdp_tx_queues(adapter);
 			goto err_create_tx_queues;
+		}
 
 		rc = ena_setup_all_rx_resources(adapter);
 		if (rc)


