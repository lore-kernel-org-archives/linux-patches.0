Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D621A59E34E;
	Thu, 17 Sep 2026 15:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658777; cv=none; b=goFQGvtIbFnSTrDFuhZUB5HZlQHrLZ24EAItQsIRBNG9raN3glI6JM8BuppyLYyGdAUNMUbwRT2KgvTlWU2++I00d8iTHuzzLu46oUtcmhaSgijBPxL8uG/53V1xfe6ImcQGR5sObKU218C48HK7lu4IiQlZfq20ltfMM4zwgjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658777; c=relaxed/simple;
	bh=XWWdfoVHfTvtjkSpWQntrE8XnEz5yYRb5Dcz/8BuNHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kP5dE27nHu/f4N/rm6a4rCsXjszjATzUCDu/yxV8mfBqthKpM4fi7KO2FjaWq5wXKUTCEmdfpqVIty2Y1JhUyGE1inJ/kmCizTvunH6dt/5raWmXPouZLdgNMRaHb7iHJ71q12ZzGh8XWM/gFHUNpiaiBy5QVcl5P2zCouQVFxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8kyKWr5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8kyKWr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20741F00893;
	Thu, 17 Sep 2026 15:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658764;
	bh=OtiLMArsxMxX1OhgfkqovGELHcroA9u343BbwQgi1A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8kyKWr5BFPnPTdIn7J6+YsjkxAhLsWlH3jv/EJAjdPef2IRMTj1vEZNz2UYjoroY
	 SXEHv+KJEZYkywBDYdPqBk3Upztn048h5BDBXVVeTiqcmeRYh31SW9c0rUNkATKBOo
	 TlXYw3N5vTXl4cmjbctIDRQMWU30CQj5eu3nrMeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taimuraz Kaitmazov <taimuraz@kaitmazov.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 031/733] accel/amdxdna: put the chained BO when its mapping fails
Date: Thu, 17 Sep 2026 16:05:39 +0100
Message-ID: <20260917151351.504769886@linuxfoundation.org>
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

From: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>

[ Upstream commit 7e33ba3a1d48c2d20ed270dec9d2d08332585c8e ]

amdxdna_cmd_set_error() looks up the first BO of a command chain, which
takes a reference, and drops it at the end of the function. The mapping of
that BO is established in between, and the failure path returns without the
put, so the reference is leaked.

Ordinary use does not reach it. The chain has been submitted before any of
this runs, so aie2_cmdlist_fill_slot() has already called
amdxdna_cmd_get_op() on that BO and amdxdna_gem_vmap() has cached its
address. What makes it reachable is that the BO is resolved again by
handle here, and the handle is userspace's to recycle: closing it after
submission and importing a dma-buf whose exporter implements no vmap onto
the same id leaves amdxdna_gem_get_obj() returning an object this cannot
map, since prime_import() types every import AMDXDNA_BO_SHARE.

Fixes: d76856beb4a4 ("accel/amdxdna: Refactor GEM BO handling and add helper APIs for address retrieval")
Signed-off-by: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260819230852.287751-1-taimuraz@kaitmazov.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ctx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index 31a414c3f0d96..888e857ec5582 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -183,8 +183,10 @@ int amdxdna_cmd_set_error(struct amdxdna_gem_obj *abo,
 		if (!abo)
 			return -EINVAL;
 		cmd = amdxdna_gem_vmap(abo);
-		if (!cmd)
+		if (!cmd) {
+			amdxdna_gem_put_obj(abo);
 			return -ENOMEM;
+		}
 	}
 
 	memset(cmd->data, 0xff, abo->mem.size - sizeof(*cmd));
-- 
2.53.0



