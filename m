Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2AD3AC1C;
	Tue,  8 Apr 2025 11:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112956; cv=none; b=KeTEH5Nl3bAtc9SPNPhrz6BzyjwIU4dmJ90cZFxjnN3CPr2yj5RSaopp/lBvwTQz0r/mNlTCWbM4XIsd6iLohcXXxntUnTV55+XwCYxFmbr3NJM7Y0htQyUssJqKwDFdNU7mVIPDOzSAwBBSo09FsogDPSTlDOWhgS6IDyYqrCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112956; c=relaxed/simple;
	bh=APQpdh38OJZNTxalekmIQ7L+jlehVHeyuab3zTj1KKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1CsBkFQneB/xq8eMXGJ6eE+JZKQo48hFj94+oJWZRkNbw3tZdqgQdQHkjGKMnhWqcXvXhn3AJH8Pcz9KjdN4K35SxXigYqXFXuS1tB/kp1+RlbG3PoGB8YQhUxqPQbCz4TLbdtkQcKGfURjl8s5Yp2dvWUpgwp9iFZN+6V6vCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXchbvK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXchbvK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A39C4CEE5;
	Tue,  8 Apr 2025 11:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112956;
	bh=APQpdh38OJZNTxalekmIQ7L+jlehVHeyuab3zTj1KKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXchbvK3ZG5+0camcmf1dWcolKOFSWGPCrdv5MQUazGvbDB/YgY30yH488JwOUGXe
	 LdqDsWO4d6FVx/VWXPbVZL6I360fp0RGafgyLsf62db4+viRiuZAbN1FWGbgttFlQw
	 i0EQ4pAd2tQSqgR/kMjRCojtleSP3yDdlqu0Xe80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5.15 261/279] ntb_perf: Delete duplicate dmaengine_unmap_put() call in perf_copy_chunk()
Date: Tue,  8 Apr 2025 12:50:44 +0200
Message-ID: <20250408104833.428044167@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

commit 4279e72cab31dd3eb8c89591eb9d2affa90ab6aa upstream.

The function call “dmaengine_unmap_put(unmap)” was used in an if branch.
The same call was immediately triggered by a subsequent goto statement.
Thus avoid such a call repetition.

This issue was detected by using the Coccinelle software.

Fixes: 5648e56d03fa ("NTB: ntb_perf: Add full multi-port NTB API support")
Cc: stable@vger.kernel.org
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/test/ntb_perf.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/ntb/test/ntb_perf.c
+++ b/drivers/ntb/test/ntb_perf.c
@@ -839,10 +839,8 @@ static int perf_copy_chunk(struct perf_t
 	dma_set_unmap(tx, unmap);
 
 	ret = dma_submit_error(dmaengine_submit(tx));
-	if (ret) {
-		dmaengine_unmap_put(unmap);
+	if (ret)
 		goto err_free_resource;
-	}
 
 	dmaengine_unmap_put(unmap);
 


