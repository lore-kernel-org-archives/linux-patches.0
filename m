Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79506267F6C;
	Tue,  8 Apr 2025 11:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112123; cv=none; b=mPYcioM06lhxT/plvBV1ZpKiXm5SoYZG1o+7V2MkgKdb8q005urbKCx1yejO1IfMc+JH4ejuUJmPRhGM0oowOJplh82zuLcVLiNftCu6q9IMcsbmQQee7zlJ/mde4FACh/RX6BUChzMlT9S5fnPvbWwE02InVYXGDjwcYig8jDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112123; c=relaxed/simple;
	bh=MyjsErwoVHcF8aG01ws1fcEOfE+uSO5JJRAkZoFF0UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aBsTpOjJzhoB4HLtARJ8GZR5BMS73IyE0S10ufjqzXzcXoJFZA6W4AX+WzkMYButwkUxoaJY61lw2HiXeYpriaDgO9UulcEzilsGx+CH8e6yUw5Q3viZG0l/aM8TgBR3eeigwEEpZ35q4vIsyVyoZF/9H0pVBfhIYIMmHguLuk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ohh/OEti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ohh/OEti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B4AC4CEE5;
	Tue,  8 Apr 2025 11:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112123;
	bh=MyjsErwoVHcF8aG01ws1fcEOfE+uSO5JJRAkZoFF0UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ohh/OEtiZmtMO5/8yDC9qVEfAL9s3x+1EHbBEJfHDPWt212J9t9RNmHtdU/sfh3hX
	 KaASs7nE9xJ7GCWPZSxaTd0DHXiNstNGgsWrDUJu5Hw99d5mF3dmvZBtcLtsFkBwgj
	 h6cdHb5Gn4eiWZ/cHSqH7ATj0Vng/yciPJsXooSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 6.14 677/731] ntb_perf: Delete duplicate dmaengine_unmap_put() call in perf_copy_chunk()
Date: Tue,  8 Apr 2025 12:49:34 +0200
Message-ID: <20250408104930.014256585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 


