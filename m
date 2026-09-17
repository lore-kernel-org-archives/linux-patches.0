Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7A130566F;
	Thu, 17 Sep 2026 15:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660302; cv=none; b=My2aQp147w77l1Vr4l05zmoXsLgM3bpqZ5jcMfTUiiyK8lfwldf+2mOY/ZgFiA4AVV1A9PglsUUYCJm0D6alQcNd5W8cdzpuRqWrGLJk8dzwKji02eu4yCIQSQNqbozNwmx6MmJjGq8tZAvQNKEU4AhUbn7sZlwZ4ppRnnpDvnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660302; c=relaxed/simple;
	bh=ERIyO4zEQY2mo/ObLwyOCNttJJ13uXYwChdMVMajUGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7M0WBjjiGsjd9zaK+NkZYsk9PK9e/SA/4emLhtO6Q5OijOsl1M+myVxrdPAmRBOAtjeKVI8n7/YmG/slozCFkhU8I+HqnfCNpmJo006D0sUmUhcNC8hd40Gk4hgImf2qfyunqaREyjUwcMQTzfwptxHWOjDVHG/5J7p1XggAxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUOPsDiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUOPsDiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8651F000FF;
	Thu, 17 Sep 2026 15:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660301;
	bh=CuXP8mf28r1Dx9oHpA7WQdGr+kgFpNm+PtgdGoPE8to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUOPsDiQCqXxkYaXKK0x9VO9NmqCB+/Vl3IOc0AYkJZ3O8ppMp6lx2VCbuQBRLv1y
	 KUWPxnTF86OA2e/GZ1OswNGQfeWYk1Lpk4mVxWi69BwxhyU7QTF1SHWYg9DtxjV1Mi
	 s1SbCteS49F9utg1zUenFCFPdrkRQI/+lisKj5ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahil Chandna <sahilchandna@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 547/733] net: mana: Reserve extra CQ slot for the fence completion CQE
Date: Thu, 17 Sep 2026 16:14:15 +0100
Message-ID: <20260917151405.879860894@linuxfoundation.org>
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
@@ -2756,6 +2756,10 @@ static int mana_alloc_rx_wqe(struct mana
 		*cq_size += COMP_ENTRY_SIZE;
 	}
 
+	/* Reserve an extra slot for Fence completion
+	 * event (CQE_RX_OBJECT_FENCE) in case RX CQ is full.
+	 */
+	*cq_size += COMP_ENTRY_SIZE;
 	return 0;
 }
 
@@ -2850,7 +2854,7 @@ static struct mana_rxq *mana_create_rxq(
 		goto out;
 
 	rq_size = MANA_PAGE_ALIGN(rq_size);
-	cq_size = MANA_PAGE_ALIGN(cq_size);
+	cq_size = MANA_PAGE_ALIGN(roundup_pow_of_two(cq_size));
 
 	/* Create RQ */
 	memset(&spec, 0, sizeof(spec));


