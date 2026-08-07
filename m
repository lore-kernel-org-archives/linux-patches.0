Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0176237F8C2;
	Fri,  7 Aug 2026 15:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116673; cv=none; b=LKOkgXsVCsZtiCwYQBnG9SCxJVs6/XGNJEnzC9Xe7fs/RgtC7RYns1Tf+dPkuIWBKYqfiINIBVTb/I/CvXUsdbEid3D6aiJMqmYF4L1LVNvExno8+dfv/nw9lgbP78HOHb3aA1X5vWvuXzxEnxAm+TTBRruZajC18ahDRTa/JDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116673; c=relaxed/simple;
	bh=AxYLkjwrtDHCwLuU1y9bncynvewm1HraXRJtYYfh43g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eslgnZhrbtQ5hZJyyvQgx3QUH/7N+roJk6SJBazsct4BJZskvc+SkpIVvIBB+TvLHcUrPdnHb/Jrs0k6zPLPgV7vcwyMT3uI5EcHuL9x7f48hzMJlN35isyTzS2XFu5/cCuf1VDp7Pkr2bwBFWIxF9U9fBKIAAJrclJ3/BzvBKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtJe8U9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtJe8U9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA7A1F000E9;
	Fri,  7 Aug 2026 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116671;
	bh=uOlhGFNqpsKXSpdIByq/p66JQQCSxv6SU9VB1VrzM6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtJe8U9bNlMacd/Kklo5dkJZVgPhkNr7jKNMz2jCDUc04U7RcXqewFRc+MvnLPxXq
	 8+INazvt4tLmwcJ0ezkdVKc5+Q6gF5hh4UNw7DruENgxfb5mYfKRsaxsz8ieJkgQaL
	 /S6Mm+db2cvIcp3V9TlawyiR6LnWm+DAaV/k4UHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 049/438] KVM: arm64: Fix hyp_trace_desc allocation size in hyp_trace_load()
Date: Fri,  7 Aug 2026 16:34:05 +0200
Message-ID: <20260807143429.040841679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit ca28278d10ec234592989ad370d58294b9d43e0f ]

The footprint calculated for struct hyp_trace_desc sizes only
trace_buffer_desc and do not take into account the other fields. It
worked so far thanks to the follow-up PAGE_ALIGN().

Fix the descriptor size and while at it, enforce an overflow check after
PAGE_ALIGN().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260710114819.2689386-3-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp_trace.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 73c1731392c74..3f4ba2034a155 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -229,18 +229,22 @@ static int hyp_trace_buffer_share_hyp(struct hyp_trace_buffer *trace_buffer)
 static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
 {
 	struct hyp_trace_buffer *trace_buffer = priv;
+	size_t desc_size, tb_desc_size;
 	struct hyp_trace_desc *desc;
-	size_t desc_size;
 	int ret;
 
 	if (WARN_ON(trace_buffer->desc))
 		return ERR_PTR(-EINVAL);
 
-	desc_size = trace_buffer_desc_size(size, num_possible_cpus());
+	tb_desc_size = trace_buffer_desc_size(size, num_possible_cpus());
+	desc_size = size_add(tb_desc_size, offsetof(struct hyp_trace_desc, trace_buffer_desc));
 	if (desc_size == SIZE_MAX)
 		return ERR_PTR(-E2BIG);
 
 	desc_size = PAGE_ALIGN(desc_size);
+	if (!desc_size)
+		return ERR_PTR(-E2BIG);
+
 	desc = (struct hyp_trace_desc *)alloc_pages_exact(desc_size, GFP_KERNEL);
 	if (!desc)
 		return ERR_PTR(-ENOMEM);
@@ -256,7 +260,7 @@ static struct trace_buffer_desc *hyp_trace_load(unsigned long size, void *priv)
 	if (ret)
 		goto err_free_desc;
 
-	ret = trace_remote_alloc_buffer(&desc->trace_buffer_desc, desc_size, size,
+	ret = trace_remote_alloc_buffer(&desc->trace_buffer_desc, tb_desc_size, size,
 					cpu_possible_mask);
 	if (ret)
 		goto err_free_backing;
-- 
2.53.0



