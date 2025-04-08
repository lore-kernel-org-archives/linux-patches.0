Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69A126B0A2;
	Tue,  8 Apr 2025 12:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115986; cv=none; b=YoZSIhVI+ByUTldUcET4e6M9CpWXzYgu0a+LqXM9g0s7M822tI/XvLHDtLgts7d0EvRcebX9OlWCTeH93hxW/WzrBEJp8mZH2n0ATB360KmnqQarluwwW7J0L2vemb4P9wvCkHQ+U4ivpjHKTqhuibKUc0YBN9Pe/yR2gy66Zys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115986; c=relaxed/simple;
	bh=/m0vb2wEOYBWgIlyONHLcA1D+OrEXNOM0byyywrxwqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qAdCl+7z2Qk9Z76zJmX5v4oOR5ExE4yvGsl/qD8y6z4OlM53hr4F0qgt2TBEVmavxsLrQnfNZWR8A4ved820Iq5o8CHXp/U1StVrBJQTT6URaCC+KQlzmRXFCxlOAzuM3uMEgbtCpL+86ePA1P/BLP8+L17ae8hxEsHXQ8K2Kq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zGl3jbE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zGl3jbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AB3C4CEE7;
	Tue,  8 Apr 2025 12:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115986;
	bh=/m0vb2wEOYBWgIlyONHLcA1D+OrEXNOM0byyywrxwqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zGl3jbE6A4lkBVFNN5i8JYNV5+6vH6Piek4UodgcncUxXgK0D/+YWIlLZZvc0Q25
	 n7mFYAJo06JnUw5mlRn9HdRYfKbbIElnc3iyXbxV182mNSLN73gskVS6HlT486dDGz
	 k7SNFE3aA29Z4fLBGUu+nTfT0kFd5d+Y4xZFwOgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 6.1 178/204] ntb_perf: Delete duplicate dmaengine_unmap_put() call in perf_copy_chunk()
Date: Tue,  8 Apr 2025 12:51:48 +0200
Message-ID: <20250408104825.542918069@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


