Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF471D0F6C;
	Wed,  2 Oct 2024 14:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878938; cv=none; b=cWoEaJhQlkxCPngyfXOKBid2t5WdKq0A8lNt2Eg7K7syWb8Uh5JEdXqGin9IfrmQmprA/w/N7EySC1mJRkSugQQnSh5nbYorcm/vPwCseTpjaMNnw0ZY3ZBbs1yAHPpA98DQ3JRGGRjJZHUDZDCH/VFxor4gcd1oszKEwBvfnPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878938; c=relaxed/simple;
	bh=lZY/SopBCpSQtgzqM6+gg4zeA/0e3uh6RSyxPKNYBP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqoG4apFnbtX7ATxwgeJ9fbeXCVKjBOxTL99l1afsit9AXQwks8qgHoXCKvRpf6AHYusXRhPm8rnBGROIAPjY/REu1EJy0OvKs+m71MXbMRSu2m1NR/GEoQi2RXmEFXu1LNEol3IorJYwKZe7EqKHdIJ8DZ0nbU6K8NF9L96J2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zb8CIl5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zb8CIl5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E9EC4CEC2;
	Wed,  2 Oct 2024 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878937;
	bh=lZY/SopBCpSQtgzqM6+gg4zeA/0e3uh6RSyxPKNYBP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zb8CIl5TVtcrEDJZ/drU+NbCmas9VHn1TEtvt2Qii75Rg5maKtDnSFKQeBDlk1cxA
	 Vj5i3F0QIYpBPEY31A3CHAxpA0wv6kUQ/31hDbRQzOue3M625qeuvaU3z/VnIaXMem
	 h7ziQYoG544FvbLNcN0vEoGljzd+K4Qhi1M6ZwxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gafert <christian.gafert@rohde-schwarz.com>,
	Max Ferger <max.ferger@rohde-schwarz.com>,
	Van Giang Nguyen <vangiang.nguyen@rohde-schwarz.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.10 584/634] padata: use integer wrap around to prevent deadlock on seq_nr overflow
Date: Wed,  2 Oct 2024 15:01:24 +0200
Message-ID: <20241002125834.168299101@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -404,7 +404,8 @@ void padata_do_serial(struct padata_priv
 	/* Sort in ascending order of sequence number. */
 	list_for_each_prev(pos, &reorder->list) {
 		cur = list_entry(pos, struct padata_priv, list);
-		if (cur->seq_nr < padata->seq_nr)
+		/* Compare by difference to consider integer wrap around */
+		if ((signed int)(cur->seq_nr - padata->seq_nr) < 0)
 			break;
 	}
 	list_add(&padata->list, pos);


