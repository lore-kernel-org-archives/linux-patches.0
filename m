Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B93D26296;
	Mon, 14 Oct 2024 15:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918491; cv=none; b=gKvQXN7DpJCATvlZylkixVUVwPg/0wOxw6aV3i5XAIT1i51jO57T+xTb+9sEJuGWQIPJ3fR3E5+8j3HQTJFF+wZKTtYa5DdZH7Yt7qvaXADp5qXZTJ7frF658lykZYI2iSzaFWooLe+yqPZ7XaZPX292H1/kpfCx1UgwJXTtF+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918491; c=relaxed/simple;
	bh=OTfMYfpQ0R4aJt5FnyjKro9hMWCzkCoJQD9hR6dLt6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4S9/Q+xZ2zrK7ojNJRisBJfv/3EJYgEPUAea+Hwj2c9j3RN5ed9b5PV2Mdt/FrV6OMTrF2qMoEX+uXdwoE51mGwphnYU2Zv+Jcm1JQ0bmAJHpF4yWXjE8mWRdghX2e1dujrnj7wlUuPR1SICLH9Vs0eS1vBYwFAkxz+7Yu3Zc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kw0r694D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kw0r694D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B556C4CEC7;
	Mon, 14 Oct 2024 15:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918491;
	bh=OTfMYfpQ0R4aJt5FnyjKro9hMWCzkCoJQD9hR6dLt6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kw0r694D8VzHY9CowG5tW+5LIyBflCw8IymzKugDcdvn25soYeMb6DEmGXAjzkzCG
	 NQhycXDcTrXamCiAlYwBXuwTv37zpdgDNB2+MYsOG6B5DW9jzZkKQv6tpB9piuB1pm
	 epB96ppIA/Wqg5WO2TzbFPmJM9pCPx454EsODC2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gafert <christian.gafert@rohde-schwarz.com>,
	Max Ferger <max.ferger@rohde-schwarz.com>,
	Van Giang Nguyen <vangiang.nguyen@rohde-schwarz.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 340/798] padata: use integer wrap around to prevent deadlock on seq_nr overflow
Date: Mon, 14 Oct 2024 16:14:54 +0200
Message-ID: <20241014141231.305180476@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: VanGiang Nguyen <vangiang.nguyen@rohde-schwarz.com>

commit 9a22b2812393d93d84358a760c347c21939029a6 upstream.

When submitting more than 2^32 padata objects to padata_do_serial, the
current sorting implementation incorrectly sorts padata objects with
overflowed seq_nr, causing them to be placed before existing objects in
the reorder list. This leads to a deadlock in the serialization process
as padata_find_next cannot match padata->seq_nr and pd->processed
because the padata instance with overflowed seq_nr will be selected
next.

To fix this, we use an unsigned integer wrap around to correctly sort
padata objects in scenarios with integer overflow.

Fixes: bfde23ce200e ("padata: unbind parallel jobs from specific CPUs")
Cc: <stable@vger.kernel.org>
Co-developed-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
Signed-off-by: Christian Gafert <christian.gafert@rohde-schwarz.com>
Co-developed-by: Max Ferger <max.ferger@rohde-schwarz.com>
Signed-off-by: Max Ferger <max.ferger@rohde-schwarz.com>
Signed-off-by: Van Giang Nguyen <vangiang.nguyen@rohde-schwarz.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/padata.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -396,7 +396,8 @@ void padata_do_serial(struct padata_priv
 	/* Sort in ascending order of sequence number. */
 	list_for_each_prev(pos, &reorder->list) {
 		cur = list_entry(pos, struct padata_priv, list);
-		if (cur->seq_nr < padata->seq_nr)
+		/* Compare by difference to consider integer wrap around */
+		if ((signed int)(cur->seq_nr - padata->seq_nr) < 0)
 			break;
 	}
 	list_add(&padata->list, pos);


