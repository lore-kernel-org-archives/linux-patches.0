Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663AA1D04B8;
	Wed,  2 Oct 2024 13:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877071; cv=none; b=sPIrcuyF6bVdXfNrQ5gCCyEeaO+dGCpECcQl9zW/Vox5uJA8mbATFkyNC+tx8c5qC5gzdu0eJCJsIbv5/dZ62klNOdcF6vGyAhPCqdjgX/roGSduL+ZFFBRYfh2Yx/Oeo7vCGK8xTh1wKunZO4t0jGGZz8+7hNoGYInXcMzOsUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877071; c=relaxed/simple;
	bh=Tm1X6A0u+bw9FGwX0+bLc4DGqaogIdV0ZF+jc2JiAbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoxeYv2YN5b7RcMk6SUK8hJbnDWuv42/IfDkc1xDd+QUTL9aSJJQuJtLXWYcozBtnVese5bXi/hkwyIVSdYQIsJ/m2fmZq+COHQBvu2h1872gVYURbM/gD56eDKRXOPVGu/3X8gHwZPE7oNFZ6E/uC7nF7B80Jj9C1vSBV1lz4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3B9UmO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3B9UmO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59ACC4CEC2;
	Wed,  2 Oct 2024 13:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877071;
	bh=Tm1X6A0u+bw9FGwX0+bLc4DGqaogIdV0ZF+jc2JiAbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3B9UmO2KDmafG2J5TjMd0tO/JpP2qjuuMvO+gAzSY7KBul/9PHkfeDEk523+hlEQ
	 c7CCwH0XO0INt5+3m1amg0LJznr8T7f4R98/ipqQyLr5fWbC4IMTJnB/Jla6n4wu+5
	 pweN7dLEx9I4iiQiqZvE6mYxtEALqtOiblHnZ6wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gafert <christian.gafert@rohde-schwarz.com>,
	Max Ferger <max.ferger@rohde-schwarz.com>,
	Van Giang Nguyen <vangiang.nguyen@rohde-schwarz.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.11 654/695] padata: use integer wrap around to prevent deadlock on seq_nr overflow
Date: Wed,  2 Oct 2024 15:00:52 +0200
Message-ID: <20241002125848.618139100@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


