Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD196EB56;
	Thu, 13 Jun 2024 12:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281718; cv=none; b=CR7nNdgVUKmh6CPV+quyzi+RyrcoNx9RFTKo7lxgiLnzdYh8cwcJjnI/GBUpmHOW8deJEwMvB3jLdU2DZZyI2/jqM3zUODoCU+1SIrTzZIE408eF+39hkmSvH1Di2fxgFySPxVAgrdbX6ERGHvpWq89TgzwP79i5A/O9MvRzCvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281718; c=relaxed/simple;
	bh=RgkaJeNKnr0VpG0eutLTsr4uelEFfo4MLYldbogzju0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiQE53CdY6fAv93sxNkV2QCpP/ndpd1h+RE7Cn+rzwVG5UcbLfEdwW0tkhULvOWdSj1O1/ck9YxebmrYnU3gqJDkvt8+yIFJBEqDVAh6PGt3oKlx2LmXzR0SRX39Mo5SdgvHMh4j/MSqur0RLMHBtq+UaEh31J2IJsf98fgIx0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkeMro1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkeMro1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4446FC2BBFC;
	Thu, 13 Jun 2024 12:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281718;
	bh=RgkaJeNKnr0VpG0eutLTsr4uelEFfo4MLYldbogzju0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkeMro1YhlIiU83FQdRVn9mpKos1fx1aoPH5EiVwANxWxyBDgO3450TA9vhATL7nw
	 HBEtlRj2CcQ7c8N8jSFcpgPtFDMthqcQfS8HAjOsjx5Ikg7mPtgikpZGi8HdPszJcM
	 bKVw2XYCJaxVe3DcFhfiRB6UHkqFLh8bkmkSpAu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 015/402] fs/ntfs3: Fix case when index is reused during tree transformation
Date: Thu, 13 Jun 2024 13:29:32 +0200
Message-ID: <20240613113302.732013091@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 05afeeebcac850a016ec4fb1f681ceda11963562 upstream.

In most cases when adding a cluster to the directory index,
they are placed at the end, and in the bitmap, this cluster corresponds
to the last bit. The new directory size is calculated as follows:

	data_size = (u64)(bit + 1) << indx->index_bits;

In the case of reusing a non-final cluster from the index,
data_size is calculated incorrectly, resulting in the directory size
differing from the actual size.

A check for cluster reuse has been added, and the size update is skipped.

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/index.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1538,6 +1538,11 @@ static int indx_add_allocate(struct ntfs
 		goto out1;
 	}
 
+	if (data_size <= le64_to_cpu(alloc->nres.data_size)) {
+		/* Reuse index. */
+		goto out;
+	}
+
 	/* Increase allocation. */
 	err = attr_set_size(ni, ATTR_ALLOC, in->name, in->name_len,
 			    &indx->alloc_run, data_size, &data_size, true,
@@ -1548,6 +1553,7 @@ static int indx_add_allocate(struct ntfs
 		goto out1;
 	}
 
+out:
 	*vbn = bit << indx->idx2vbn_bits;
 
 	return 0;


