Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB9C3AF674;
	Wed, 30 Sep 2026 18:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794706; cv=none; b=oUWhI7RdEXnEFv7ZD6/D1zFToYMmrPp1rlv/C8d6wzTC18jmRrOeXcVH6erDNL9xwfjRby0Yyh6feS5noXeR0e/aN5bysQD3TfUai0gBPGsrLuySGnQYGig9BP8Lw3xkKS6cxj5qguV47WS3pR31Iu9zQHiHcCjEfUVq09zL6us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794706; c=relaxed/simple;
	bh=eGWVjsCeMUqmRJdFj4AbnVXTOGYNMRc/UsAjTMuEXlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aq4bG8F4HnhSkazKHb00B7PIt/NWWHL5+2WdHnXdivwkodsmeDwqnOT1rI/uI9SRzaey6BhDMKuzyJWUURSzLNJ/xq9Jy06I1iz323Mw8aTEhdJaN3qTmjJFph87kd1b/bEH11A9Pip+9e55rVaSUlfCtbOR3uoHrRKn+fippVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2gMbrHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2gMbrHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C811F00898;
	Wed, 30 Sep 2026 18:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794705;
	bh=A1QYYW1j7wl4Ecl2/dxxUlv/UQY0vFyw3oGmkZU0gQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2gMbrHq0rPo/H5MRKZGsbFDMxbJEqIGFUWc9ppbv9Qh/Irl0jjowhfs+3h6ysWlr
	 IWeSitt5NoQify19Mny8IjIaOHK/HmnDOJVOLwu4cAj8gh5Wlqt6DYs63YRktqaUt3
	 UHk4+LLcciAbXg3uw9dj6sYnPFexpH+f0pyseVVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0278/1193] xen/front-pgdir-shbuf: free grant reference head on errors
Date: Wed, 30 Sep 2026 17:16:02 +0200
Message-ID: <20260930152440.339451080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 678d59219ce0ae883f04c96936222c6168ef1164 ]

grant_references() allocates a private grant-reference head before
claiming references for the page directory and, for guest-owned buffers,
the data pages. The success path frees the remaining head, but claim
failures and grant_refs_for_buffer() errors return immediately.

Unwind through a common exit path so the private grant-reference head is
released even when granting fails part-way through setup. The caller
still tears down any references already stored in buf->grefs.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260629160517.29340-1-alhouseenyousef@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xen-front-pgdir-shbuf.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/xen-front-pgdir-shbuf.c b/drivers/xen/xen-front-pgdir-shbuf.c
index b52e0fa595a99..9d005b17a14bb 100644
--- a/drivers/xen/xen-front-pgdir-shbuf.c
+++ b/drivers/xen/xen-front-pgdir-shbuf.c
@@ -447,8 +447,10 @@ static int grant_references(struct xen_front_pgdir_shbuf *buf)
 		unsigned long frame;
 
 		cur_ref = gnttab_claim_grant_reference(&priv_gref_head);
-		if (cur_ref < 0)
-			return cur_ref;
+		if (cur_ref < 0) {
+			ret = cur_ref;
+			goto out_free_refs;
+		}
 
 		frame = xen_page_to_gfn(virt_to_page(buf->directory +
 						     PAGE_SIZE * i));
@@ -459,11 +461,13 @@ static int grant_references(struct xen_front_pgdir_shbuf *buf)
 	if (buf->ops->grant_refs_for_buffer) {
 		ret = buf->ops->grant_refs_for_buffer(buf, &priv_gref_head, j);
 		if (ret)
-			return ret;
+			goto out_free_refs;
 	}
 
+	ret = 0;
+out_free_refs:
 	gnttab_free_grant_references(priv_gref_head);
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.53.0



