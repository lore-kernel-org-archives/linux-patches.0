Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539D64ABBBF;
	Thu, 17 Sep 2026 15:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659430; cv=none; b=uvIBPI1jZ0miTZPgKC/cny1ntNUsmfd09gDJ4/TQRqKIbkovvycTnLGqLGQ2DU/GZBGje8SD1wtoql3KTIlcErfwkydyQaori2P3z8hJt1GU4i/RcmaFiF8pE5hoJFXKn1Yw/X+GNULYN+tHWybMmGu244N4rwnx7wfpk5ShJhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659430; c=relaxed/simple;
	bh=96/y7YoKbrZ2mbpjqRGkNCo0FASUy2FoRXM6mouNXMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngOfNV2mn0H84Kk95cDpOVXE+RMlg+mJZdANgIOeV+HPRtfjHYqcnASBZX9ho8xFRyIPMMDrleuqG5kjl0zfhUBPtrQ2YKJC9mI8G0+UkvM4E50biFuKqk7gqvZ0AI4/5Muuwg90eK0ZrdsIYgQh2/ZK47APZa+NVQo66TcpKoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdRDrhhh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdRDrhhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D95A1F00893;
	Thu, 17 Sep 2026 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659424;
	bh=vgfMSXplGCeevVz8hvHqQE9OZcepMPYvm3sQX191JVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdRDrhhh6sauGCBGX5XTkRphNbftZ5uGNAZIl4fltGgsKT5vBbEjTOQeulaND+qZa
	 2sGUP8e0Ec+ylP6x6pqrYu0th3qYqrDEOWsMDOtfs52YzBgkDTHcWmztLiAR/vqfQf
	 Yj+oTJajub0GAQ3XONuCj/0clvG+WqM63tOwZK/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Danesh Petigara <danesh.petigara@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 245/733] net: bcmasp: fix tx_spb_ring_full() checking same slot cnt times
Date: Thu, 17 Sep 2026 16:09:13 +0100
Message-ID: <20260917151357.384814655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 0c5cf62e72d7a666ee4da757e122dc1600df1ecc ]

The loop initialised next_index from intf->tx_spb_index on every
iteration, so incr_ring() always produced the same result and only
one slot was ever tested.  Move the initialisation before the loop
so each iteration advances next_index and the function correctly
checks that cnt consecutive descriptor slots are available before
allowing a new transmission.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Danesh Petigara <danesh.petigara@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260831184235.4133351-3-danesh.petigara@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 2bd035f74fa24..f2176ef3a127b 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -148,8 +148,9 @@ static int tx_spb_ring_full(struct bcmasp_intf *intf, int cnt)
 	int next_index, i;
 
 	/* Check if we have enough room for cnt descriptors */
+	next_index = intf->tx_spb_index;
 	for (i = 0; i < cnt; i++) {
-		next_index = incr_ring(intf->tx_spb_index, DESC_RING_COUNT);
+		next_index = incr_ring(next_index, DESC_RING_COUNT);
 		if (next_index == intf->tx_spb_clean_index)
 			return 1;
 	}
-- 
2.53.0



