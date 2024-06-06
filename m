Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BA019E7CA;
	Thu,  6 Jun 2024 14:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683104; cv=none; b=ltZ1pX6rV231vsg2KAZ6IhniY4TL6xoxwI2pr/hH/Y3WB5p3pv6FfgMFjEGh7gIAKVBgKf2f0ZBRODLzDetdtRlBEV0mGzjeCC9SArE08/b/tfYmlTCbY3ywt803XSKwcua+TC6oWr+2F98MjqNFNz95fBufRDm3AMP7imNHSWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683104; c=relaxed/simple;
	bh=MM8UMOlMhWeMXhAJoMTYzGDPHRuzgI1D4a1NLMFC1o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXiDHC5xWIQFpFoL5qejGdBvJMj0l9YVHx2WfpdL/g0HiXB1QbsUryzAlg9zyOg22mDidpuiweniAPFzg+JIRa9CnHVA76+lLBCyN2lXzAYAIzjSnhrcuMP9Zm3SB5Kyewh5iTaykw35Jtg7W1sURM04D641sjhpfGuCVgg8R2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7VONj3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7VONj3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD57C2BD10;
	Thu,  6 Jun 2024 14:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683104;
	bh=MM8UMOlMhWeMXhAJoMTYzGDPHRuzgI1D4a1NLMFC1o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7VONj3VlE64xRuIgfk7G90QiSzkXsfNKQQOq94wKHiqpI22vLyV3HPaCL6FUIKEj
	 YDXViZyUBhIdkxsbMoFv6+RWxcup1AuVXLCIDBTs8o4SlkedACwnCKqjuG55Zqa3EY
	 v+uXjh54oXKPVGsI+BXZg4HqVLKlQhInu8PADfS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 025/744] fs/ntfs3: Fix case when index is reused during tree transformation
Date: Thu,  6 Jun 2024 15:54:57 +0200
Message-ID: <20240606131733.245057777@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1533,6 +1533,11 @@ static int indx_add_allocate(struct ntfs
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
@@ -1546,6 +1551,7 @@ static int indx_add_allocate(struct ntfs
 	if (in->name == I30_NAME)
 		i_size_write(&ni->vfs_inode, data_size);
 
+out:
 	*vbn = bit << indx->idx2vbn_bits;
 
 	return 0;


