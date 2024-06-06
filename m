Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4C01A01D0;
	Thu,  6 Jun 2024 14:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683147; cv=none; b=lh2S2a/DnDe2xVV1SghTmqZzPewA0qb0K/eJzlM8+53cXDWyezmaVmk9yNxKDnAXzgLAsLAPQ9KYpBJRGkOztiXLf8TppuP8PuM8ZtbumnBDv/FY4Ebltfc/Yje4jAWX09BKPamCJrsb3Xm5GrI8K3OagIs8zKLn/JWz6VbG6QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683147; c=relaxed/simple;
	bh=VmzLJSRVZwD3YQ37IwxwonRjJTVdvMsaydT6yu4ebJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FANS+gQ96tqWSag9OE1urde+KBFrBJTalDZwYaYN3azFZQl9XW8PU2/mcn0xwtw6QXzC1megO84YvraNauHcHDHssFPPSVIPkaHYZWy/P7sy0D0N/pFHbpTwLbpq/RA+6UGFv8LRxJKeUgN9AOpbA9CbESFZnDxAVXEtzC2uHMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fut9DC+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fut9DC+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEB4C2BD10;
	Thu,  6 Jun 2024 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683147;
	bh=VmzLJSRVZwD3YQ37IwxwonRjJTVdvMsaydT6yu4ebJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fut9DC+3S0/HpBNU3FQRE/pj9Y3HQD1ms08nVbiuObuhfjTgBol8SKQGWdvOCZgqX
	 OxVLzjp3k6aeS+zwBf3996fyCOnsAC531iHAq7Dw/HQXbN/BCPHg/NxtMmZL+gMwp5
	 5NOJcpuNEoOFHOq3t3xetueB9+q/j7sFf2OR2Af4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 019/473] fs/ntfs3: Fix case when index is reused during tree transformation
Date: Thu,  6 Jun 2024 15:59:08 +0200
Message-ID: <20240606131700.488791995@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
@@ -1531,6 +1531,11 @@ static int indx_add_allocate(struct ntfs
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
@@ -1541,6 +1546,7 @@ static int indx_add_allocate(struct ntfs
 		goto out1;
 	}
 
+out:
 	*vbn = bit << indx->idx2vbn_bits;
 
 	return 0;


