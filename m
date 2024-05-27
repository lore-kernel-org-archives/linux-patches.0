Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D9515FA85;
	Mon, 27 May 2024 18:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836388; cv=none; b=p7554ienc1GILnuFR9hF5QLx4yKqqhspZ1DIeTibWuJ13ctq5G8ZjODVe3VvfJNb2g+B3eCNIcMsNLjIdaGAM3hht55NGdZ3h/A1upADbeQs69B8w3tTNMUw5Z5/ClxirRm2GG7aYlhFE9BAk0uR7tL1wsBR9FaVEpBe5rheExU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836388; c=relaxed/simple;
	bh=9fF1HuWHuqoKTkqflum+SVkYnN14ILJsSVLJkQTpiDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ew87Ly2Y0178jJbxDiTlSMf1zgfUmwaCv+GZRcrkiFvy/H8GXNUA3pZCmH4nPNzSpJmhyWYGcxCg/wECYDlNpmRZeSSNDldfmz8oyuKJgSwOV9aly2N1ZUCwzAjcZe/7Z/C3u2sEJfimPNf/VmPlRL0n/gCCTxcWOk9c50wfdGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7DfKVl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7DfKVl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CBDC2BBFC;
	Mon, 27 May 2024 18:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836388;
	bh=9fF1HuWHuqoKTkqflum+SVkYnN14ILJsSVLJkQTpiDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7DfKVl91J6V3CR0cRMhDZdgp/7NEUNIUiYx32gWsRseETs/3r+jUte0/XpjhsJ5q
	 nWy2vF/XLCTHcVNd47XJD8W3fmDWSl4YsXfZvxcS+WsFcED7Ing1ZWju1qM9cqMBFR
	 WfV47tQJnmpJnRAN8oOHIvLbUZFgGlBX1wngqth4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.9 033/427] fs/ntfs3: Fix case when index is reused during tree transformation
Date: Mon, 27 May 2024 20:51:20 +0200
Message-ID: <20240527185604.749710718@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


