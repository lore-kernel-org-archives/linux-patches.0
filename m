Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032DA50257F;
	Thu, 17 Sep 2026 17:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666385; cv=none; b=JeB+3Y1lfjtJHsEtOdkfkA2J0OW05siDc2XdOUbxZLM5bHArzDQa1g9BorLdBOCaDgZnnLMFNmGoIZ/RAxq98JwpixF0af1vFcmQUkrwybKv2cQPXseOWu0nVT2RLjm0LmKBhJGs5f7Dm6brDvj/bxu+qe1PZ4YVX0ZeGQGrKxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666385; c=relaxed/simple;
	bh=xhY58GOjwSbiH5KI4jXCVNsgjsdCqan8kvmA8iryeFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqS7gkbysGF1wYbQQfCJ4T2kqurMhNpfqBYuDEqx1jxDV/MIpNhtwnJXURSSoxjQ6YTmhrGhUHIHGoPkLC2cndeDq5wevSBUSMW6tJNPZHuPyIZrQaQOtg1aFOUioHKsD5jjdDeRDFv+NudbsCg3r9v6V1VIIX9MKff0CifqkGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hM9OuN6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hM9OuN6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574CA1F000FF;
	Thu, 17 Sep 2026 17:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666383;
	bh=q7aul3TRe6r5EBGEtSic8QY142jIi4tTj3oLRvoWo5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hM9OuN6aV28dcaYDIJq8sxowKNBTYbvQiDl5bVkbLHQn35xzpA92KIv6yOhMao+mK
	 Iqst/EEtQqw0Sycbub6hzqDm8R7RUoXxqYwiShELs0I/mZBZV2SiIzvZ1qKtPxsa3s
	 oaNfo8VapgAl0Q5GAi1mNl0AH0O7zpBgcLgoiGLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahil Chandna <sahilchandna@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1018/1250] net: mana: Reserve extra CQ slot for the fence completion CQE
Date: Thu, 17 Sep 2026 16:13:33 +0100
Message-ID: <20260917151619.644462911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -2616,6 +2616,10 @@ static int mana_alloc_rx_wqe(struct mana
 		*cq_size += COMP_ENTRY_SIZE;
 	}
 
+	/* Reserve an extra slot for Fence completion
+	 * event (CQE_RX_OBJECT_FENCE) in case RX CQ is full.
+	 */
+	*cq_size += COMP_ENTRY_SIZE;
 	return 0;
 }
 
@@ -2711,7 +2715,7 @@ static struct mana_rxq *mana_create_rxq(
 		goto out;
 
 	rq_size = MANA_PAGE_ALIGN(rq_size);
-	cq_size = MANA_PAGE_ALIGN(cq_size);
+	cq_size = MANA_PAGE_ALIGN(roundup_pow_of_two(cq_size));
 
 	/* Create RQ */
 	memset(&spec, 0, sizeof(spec));


