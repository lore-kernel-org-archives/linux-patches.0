Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A270F168C4;
	Mon, 27 May 2024 19:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837490; cv=none; b=dkuIVp4utfbhSTrwy2yUt8OzhFHWVE9J35MduKIp+WDhfkkdGep0G4qviEJxnUo3L/nTtvdAvfwOtKSTMyke3F9F8NvZ7P0TjxwFm66jlXSxUUxMxeTueJo96K01qyJrHl3f3E4mAN0ltSniPtD0dLCHJnlgBQoCalRMwktjGq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837490; c=relaxed/simple;
	bh=1NVt+IzFEY6m2Ro7y7DswQpm1uWnT2U4GRhChWcVjAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmKSMbe5mi4xTo1QOlfGshnZ46vrCTaztHihXGJAxH5ItP8fSj2rQfv1Q5cSkkeYihXFdwnutbz4W0Ynz+p81AcSGBxToM20mOF7Pxo6qfN8dl3ViZXqAvQ8/Z9SY4mWTmtX3mpsSbgCoTXXrAolAV6PuMJsKe8OO5+lVnDwAzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpbOC0R1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpbOC0R1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385DAC2BBFC;
	Mon, 27 May 2024 19:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837490;
	bh=1NVt+IzFEY6m2Ro7y7DswQpm1uWnT2U4GRhChWcVjAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpbOC0R19+AMoaU8f/YZ1Zi0yCm80iT1cp7gJ27dFqVxSifp9eyE9oHP7aJLGhMNY
	 i+79FZKq4IvG2ms38dznFYSlV6cFURD5dkEqRWx82/Mwcv6YN7afmm2fIswx67Kdnn
	 y3DOwlI+bKKrgaM8DG/QeXqSsbgy/ED4fVgKrsEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.8 030/493] fs/ntfs3: Fix case when index is reused during tree transformation
Date: Mon, 27 May 2024 20:50:32 +0200
Message-ID: <20240527185629.358400887@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


