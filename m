Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E13051B16D;
	Wed, 30 Sep 2026 17:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791103; cv=none; b=ehkYbrlPDs1G6QOu5JywxXcyhdLC1lQqHv6efI8tos9QWflcpjUpkge84LW4orQgQYhThcifMluU/rmL2R+92sC/2oNW7QxrCINEKxyj1pWxWRX8eVAriU1a2reLtSoKVIjj+A5zDXM2TeqPyj6OmkRESt6lXb/IVdsAyXxOBd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791103; c=relaxed/simple;
	bh=0ZLdxjAnyEgoO4/oMlJ5duT1KBrWZQMy70yp/65o1j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyKDe54R2cRtujoGiYtglhMl9Y10P80k/BouNS/wlopE0Y+y65nl2vo984F2YKCnbyQ/rptG1wu3+grbRUO8j5oBjdzcAh4egE2PxRiZbD1LATTR6Cn295UA6Imkx9Qo0K7NRmKneTr6DLb50i+vYEwDRSm4upCXD57jNOE+wks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSIa+/I2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSIa+/I2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C561F000FF;
	Wed, 30 Sep 2026 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791102;
	bh=/XOjUG8dyv2E9+uyMNnub1SI2GdmHAgas1Bwk9MSHoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSIa+/I2C7FPz4/XWnNedlfkfBcLOHeomtjKpZ3EdmGz9XBkCs6ctglxq8vPyXrBv
	 U97cxzvtdAy/OCEg84ncccBxBEKfUas5p5eziA1lwklKMXM+sKQseCgxUPH+7cypBr
	 aRozDe0jX7K74/BryMNFCTydyeFZVXG+2utcsefk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/752] xen/front-pgdir-shbuf: free grant reference head on errors
Date: Wed, 30 Sep 2026 17:20:56 +0200
Message-ID: <20260930152402.233337844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 81b6e13fa5ecb..43c5f7c226d2c 100644
--- a/drivers/xen/xen-front-pgdir-shbuf.c
+++ b/drivers/xen/xen-front-pgdir-shbuf.c
@@ -456,8 +456,10 @@ static int grant_references(struct xen_front_pgdir_shbuf *buf)
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
@@ -468,11 +470,13 @@ static int grant_references(struct xen_front_pgdir_shbuf *buf)
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



