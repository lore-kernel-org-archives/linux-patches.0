Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EF84DDB22;
	Thu, 17 Sep 2026 18:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671143; cv=none; b=XS3PR++AVRgnS5fHRFDcS701Umw3W9RSc0ZKjr6mWs12k1HpFiMhS1fhj8GSkZy+BQobJ3n2FRoFfr8WlOzI9DXZVS5r259R0yCHzZhRBT+fHo2PtA78ldg/cKR4o31Yxlxv28ZmhAst8QM+OnUMEyo5V/HMgas2aGzLGUTt1bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671143; c=relaxed/simple;
	bh=Nav06vpEyGurqeY+GrGPcP0qcL86ieCRp9jcAYX8cNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYe1OrO6dG/i9D3jB7s387LGrV6+VIFz5mab7MQvGMq0vvwu2QgYCzB00kbt2mwrGMHNhmB4eqGn+nijUW6pjVflxmh93J3QX5WKzlGm2I1otiXr7sb31r7bjrqiXAkWkiOZ55ym9Jq79WJ1+VaA2pTMM+irmmF+uogSYVavpxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m26DXHLO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m26DXHLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E391F000FF;
	Thu, 17 Sep 2026 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671141;
	bh=3UFNSRnrLEMiAoq7TMUz3CkqCtHXAxA7RadGEBDdoRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m26DXHLOk3RmmkR/3iFneAoxvinjE2fzt+91y+Nr4KPLB6QmZr54DFdia2N7QURyW
	 MRmstdHMzs9QQqGBW2DeHeBjb0MUUTaHcCoRBA5Qg+2s+lS+Nat5k1BOGbM3/iML+b
	 r2qjGTi9U7qYtGhmNPZPYu/BLA1KBy7OKv5c8+hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahil Chandna <sahilchandna@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0843/1102] net: mana: Reserve extra CQ slot for the fence completion CQE
Date: Thu, 17 Sep 2026 16:13:06 +0100
Message-ID: <20260917151601.690007060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Sahil Chandna <sahilchandna@linux.microsoft.com>

commit 80dd7e754b3aa9637a0758ad93fa209f9650ec48 upstream.

The RX completion queue is sized to hold exactly one CQE per posted RX WQE.
MANA_FENCE_RQ makes hardware post an additional CQE_RX_OBJECT_FENCE after
the packet CQEs. The current sizing reserves no extra slot for it and in
rare cases, CQ has no guaranteed slot for the fence CQE when it is full of
packet CQEs. This can lead to dropping the fence completion while the
driver waits holding RTNL lock throughout the timeout duration.
Reserve one extra CQE slot for CQE_RX_OBJECT_FENCE. mana_gd_alloc_memory()
requires queue_size to be a power-of-two and at least MANA_PAGE_SIZE;
the reservation pushes cq_size past a power-of-two, so round up the CQ size
in mana_create_rxq().

Cc: stable@vger.kernel.org
Fixes: 6cc74443a773 ("net: mana: Add RX fencing")
Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/20260901121837.3503240-1-sahilchandna@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2145,6 +2145,10 @@ static int mana_alloc_rx_wqe(struct mana
 		*cq_size += COMP_ENTRY_SIZE;
 	}
 
+	/* Reserve an extra slot for Fence completion
+	 * event (CQE_RX_OBJECT_FENCE) in case RX CQ is full.
+	 */
+	*cq_size += COMP_ENTRY_SIZE;
 	return 0;
 }
 
@@ -2230,7 +2234,7 @@ static struct mana_rxq *mana_create_rxq(
 		goto out;
 
 	rq_size = MANA_PAGE_ALIGN(rq_size);
-	cq_size = MANA_PAGE_ALIGN(cq_size);
+	cq_size = MANA_PAGE_ALIGN(roundup_pow_of_two(cq_size));
 
 	/* Create RQ */
 	memset(&spec, 0, sizeof(spec));


