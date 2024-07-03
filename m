Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0B845945;
	Wed,  3 Jul 2024 11:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004986; cv=none; b=gNF+8Gi2qNImlxZympqEQBH7jthRjIDx6e9op4CICOuKTCvyk58emhAp3QKbdIIz5C3wZXQl7Euo7sLi82w4xuToFrrzu0TJulfFEwazadCgaI96YSCr33b2E+YkO+iypJ7zqKRoZoo9ShphvZP51uNjFm0jt5zFabGdIMN0YcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004986; c=relaxed/simple;
	bh=RfhwJpzppGHaV4lVUrC55x54u5kLR7x+fyIEebCV7fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEKat3tLQvCFX+DDxcICuE6nzxgPXtseEamEj1+2gNnYwjoBtJ2UUG4qC2YFvmkuJjM5L0BmmtecnYQQn6QnZ1B3WNfkkGPDpSIiC8spPZon6PukxQVn/8R2MDKbzE3HR7fTtr33UnQrxUkO0/ZjnwJzPUBEAdo2J7Ph0ffcAhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJKZGGyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJKZGGyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ECCC2BD10;
	Wed,  3 Jul 2024 11:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004986;
	bh=RfhwJpzppGHaV4lVUrC55x54u5kLR7x+fyIEebCV7fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJKZGGyPklXT6rSx0bLiqKiPhViaCtgRH4Vn8LBvLSj6u6Fh+31R0K7SbvtEhflOw
	 8xBsztevCoH1IX0lLDyll/OxidaBeWfV2gl7cF8KAgLO4WZvTCuXCnpcii1FKsXkJ0
	 gXi83m1i5mkZpQD30D4kuCUWKITpcZS+H9MKWe4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/290] xdp: Move the rxq_info.mem clearing to unreg_mem_model()
Date: Wed,  3 Jul 2024 12:40:02 +0200
Message-ID: <20240703102912.506007356@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a78cae2476812cecaa4a33d0086bbb53986906bc ]

xdp_rxq_info_unreg() implicitly calls xdp_rxq_info_unreg_mem_model().
This may well be confusing to the driver authors, and lead to double free
if they call xdp_rxq_info_unreg_mem_model() before xdp_rxq_info_unreg()
(when mem model type == MEM_TYPE_PAGE_POOL).

In fact error path of mvpp2_rxq_init() seems to currently do exactly that.

The double free will result in refcount underflow in page_pool_destroy().
Make the interface a little more programmer friendly by clearing type and
id so that xdp_rxq_info_unreg_mem_model() can be called multiple times.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210625221612.2637086-1-kuba@kernel.org
Stable-dep-of: 7e9f79428372 ("xdp: Remove WARN() from __xdp_reg_mem_model()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/xdp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index b8d7fa47d293c..0f0b65981614b 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -113,8 +113,13 @@ static void mem_allocator_disconnect(void *allocator)
 void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 {
 	struct xdp_mem_allocator *xa;
+	int type = xdp_rxq->mem.type;
 	int id = xdp_rxq->mem.id;
 
+	/* Reset mem info to defaults */
+	xdp_rxq->mem.id = 0;
+	xdp_rxq->mem.type = 0;
+
 	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
 		WARN(1, "Missing register, driver bug");
 		return;
@@ -123,7 +128,7 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 	if (id == 0)
 		return;
 
-	if (xdp_rxq->mem.type == MEM_TYPE_PAGE_POOL) {
+	if (type == MEM_TYPE_PAGE_POOL) {
 		rcu_read_lock();
 		xa = rhashtable_lookup(mem_id_ht, &id, mem_id_rht_params);
 		page_pool_destroy(xa->page_pool);
@@ -144,10 +149,6 @@ void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
 
 	xdp_rxq->reg_state = REG_STATE_UNREGISTERED;
 	xdp_rxq->dev = NULL;
-
-	/* Reset mem info to defaults */
-	xdp_rxq->mem.id = 0;
-	xdp_rxq->mem.type = 0;
 }
 EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg);
 
-- 
2.43.0



