Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D6E38910F;
	Tue, 21 Jul 2026 18:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659771; cv=none; b=olnmiaFxWySkUiNR/IEOFpcmvbPZN3+vQuHD2Q1FMknOkjmnynSwnvMejHuwsX1NgNE2B0IiydLKrIHL22eOI4uH+yNhBpvjxzqULMji9V91hVJVJjzPhc1ywod0wNRX+DXGPRCo3aaY+oO664vmt3nXkqCyEOygNIs6iarMPBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659771; c=relaxed/simple;
	bh=z9ssM18nSq5o+aQYdaLCH2FPxPtzjNYl0NKlbLZIHCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlCqyauPc5ZICCw3wnzic6BPnpXqdno1YYtCPZws+gI85gWJWOftXJqPb4QvNIun6ar8RmLgPPZRtTVTDXdHD7EBPupty5YzftuJdvd9qavDj2Sf9pZ4lvYYfeKXHKuidzaZpW5+uf7SFZQLDsdonmZ+wupcDbM1+GBXbC0WOY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOgZfKjk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOgZfKjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB091F000E9;
	Tue, 21 Jul 2026 18:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659770;
	bh=xh2faLQr+TQKQGJcnG3tB43sGKDJVsZBS072fg3SsU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOgZfKjkIjnRxRwmrDlslz+JKsu0/42VYXJNOfJT/NWmSBYyR0VgpS3b1k0UCqhhK
	 HLns73gn6BWnglfkzFff+hcyRetE5Kyj9PBoTUiZf63TS2o/Us8NPfchfp6OyE+6AV
	 AeonjrAwhOxxIHoHuGctTfzffXAGYF0XdmP0Wnpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0690/2077] RDMA/core: Fix FRMR set pinned push error path
Date: Tue, 21 Jul 2026 17:06:03 +0200
Message-ID: <20260721152609.065865575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit 41a707d0275cdec9ac125e826dd6836fa9623cbc ]

Add destruction of FRMR handles in case the push to the pool fails.
This prevents resources leak in case pool page allocation fails.

Fixes: 020d189d16a6 ("RDMA/core: Add pinned handles to FRMR pools")
Link: https://patch.msgid.link/r/20260610000145.820592-6-michaelgur@nvidia.com
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/frmr_pools.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/frmr_pools.c b/drivers/infiniband/core/frmr_pools.c
index 927642c06f3a4c..1cfdddc3fcdaf6 100644
--- a/drivers/infiniband/core/frmr_pools.c
+++ b/drivers/infiniband/core/frmr_pools.c
@@ -461,11 +461,16 @@ int ib_frmr_pools_set_pinned(struct ib_device *device, struct ib_frmr_key *key,
 		ret = push_handle_to_queue_locked(&pool->queue,
 						  handles[i]);
 		if (ret)
-			goto end;
+			break;
 	}
-
-end:
 	spin_unlock(&pool->lock);
+
+	if (ret) {
+		/* Destroy handles created but never pushed to the pool. */
+		pools->pool_ops->destroy_frmrs(device, &handles[i],
+				needed_handles - i);
+	}
+
 	kfree(handles);
 
 schedule_aging:
-- 
2.53.0



