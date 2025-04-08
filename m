Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55B2269816;
	Tue,  8 Apr 2025 11:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110236; cv=none; b=t8wxWV25dbYR+ezlaEpljua/mLtUcvlh/HPZ8m1pT5RVh/H6DExSFZyP1G2aJf+rdhDNpg7V964WGswrTE8Q3Cl/5YfxCmC1K4rOubAvN3Fo7KTUncdBBDf60OHgfa5Pe+Ey36aP/L8mqBupyWnklLQfRZ783lsCD+VKOcAhh9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110236; c=relaxed/simple;
	bh=yvpzMc2Yztrm8jbvNbPEyY+F6gG7f7QslcUcopKx1B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FOEoz97ZnHP2hJvJ7fr3Zd3NU0gx91RlcRXQfNtfc0GCZQGdHDXa//KKtCf3v7rKP78MYMDCaKKZzwVb3fq6+kh2x7gCmudJ764wAN9fHMVnEtZM6quHykOxQzVDxaMK0+ml7npJdPty0bnbt+MHjpMeTOvyRz6tvNG4u0QdQew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkHj9M9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkHj9M9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF74C4CEEA;
	Tue,  8 Apr 2025 11:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110236;
	bh=yvpzMc2Yztrm8jbvNbPEyY+F6gG7f7QslcUcopKx1B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkHj9M9AGwTB93XEvWP6WN/tY73Hz+EmGlUb4FmIpMegMeO3Ub6g6dSjbTHym78ze
	 Vmx1A3tTFbDZPCRAAJqbJz2OxyNL/JciE05UUImv7IXKtBYxF8b4N+KPvvY6FN8ggD
	 Axyfe2jBbQors/zfTnjWSZNR2+zZXksgY74lFlM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5.10 211/227] ntb_perf: Delete duplicate dmaengine_unmap_put() call in perf_copy_chunk()
Date: Tue,  8 Apr 2025 12:49:49 +0200
Message-ID: <20250408104826.643034692@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


