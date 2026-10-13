Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4A64FD287;
	Tue, 13 Oct 2026 12:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893107; cv=none; b=KAHNWhF+Dsn96lUJC/cXsnLBk1CB9C2cuLlzoM24KrP3eC7mNmU0IeGGJcU3kysbXj1p6t/KpDxnqiBhi3RWKEmW4h4ErRvkhy0yF8rwfm1Qegtwoc5aAiXAMU37GapiefIOwK8hvEn0BMktIffVXHpWp3Q3er+9dc0CYs08+9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893107; c=relaxed/simple;
	bh=wkD+n9Of63NuTm1+6g0AjUgURhX3HqJsotxQkWOuskU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laeD1R7/OpDVo13ykqSvS+wDoAjMko57WlDt7PaFDKNEy6F9FwjwacuXj9HF8IdkrK2oJFaMPr6ZWntkBqJ0iJTw1HnGN/MQ4PIQYRPJ+XsTOGayLr1XUQHsy0KJpIlv5zYPrM64iNmo/AdFvyyyWYjgOKyH3yR4KWKUNE/JUJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=it2AV6xS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="it2AV6xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1DA1F000FF;
	Tue, 13 Oct 2026 12:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893106;
	bh=aJyisxaHNds+Zr9vv/aiddNxVevk8iW4XKwu9RzHbv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=it2AV6xSWU9aZJ0JEgOHqPTLHgakCmY3fgCyBh8DPwKetwqXZhnBcmR/8YPAzkYIV
	 gkOdivqHZkBA+b5LXqzMTmpMBoxQ3v5Ojf8Q2tM5UWcfjcgGgUaLFRvbpxrItaDuaf
	 0loW5box+P91WYN1gGMY9gHWFZ+n9Hr90KCHt+Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 060/621] ibmveth: h_free logical LAN on open-fail after register
Date: Tue, 13 Oct 2026 13:30:55 +0200
Message-ID: <20261013112922.287564110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Mingming Cao <mmc@linux.ibm.com>

commit af0524bf4ce1a4cbd2946aa81751582951cfcab5 upstream.

ibmveth_open() registers the logical LAN, then allocates the RX
buffer pools. A pool failure jumps to out_free_buffer_pools without
h_free_logical_lan(), so PHYP still owns the buffer-list page when
it is unmapped. request_irq() failure already issued the hypercall
before taking the same label.

Move that h_free to the shared post-register unwind so both paths
deregister before the buffer list is unmapped.

Fixes: d43732ce021f ("ibmveth: properly unwind on init errors")
Cc: stable@vger.kernel.org
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
Link: https://patch.msgid.link/7a56fbfb9e0674f011f4e310fbd7dfd8e67c30aa.1790357373.git.mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -718,10 +718,6 @@ static int ibmveth_open(struct net_devic
 	if (rc != 0) {
 		netdev_err(netdev, "unable to request irq 0x%x, rc %d\n",
 			   netdev->irq, rc);
-		do {
-			lpar_rc = h_free_logical_lan(adapter->vdev->unit_address);
-		} while (H_IS_LONG_BUSY(lpar_rc) || (lpar_rc == H_BUSY));
-
 		goto out_free_buffer_pools;
 	}
 
@@ -737,6 +733,9 @@ static int ibmveth_open(struct net_devic
 	return 0;
 
 out_free_buffer_pools:
+	do {
+		lpar_rc = h_free_logical_lan(adapter->vdev->unit_address);
+	} while (H_IS_LONG_BUSY(lpar_rc) || (lpar_rc == H_BUSY));
 	while (--i >= 0) {
 		if (adapter->rx_buff_pool[i].active)
 			ibmveth_free_buffer_pool(adapter,


