Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E0835580A;
	Tue, 16 Dec 2025 12:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887711; cv=none; b=IBps4WsTkH5uJbh7Ozfta3YjnKIjmJF11kE2EkIz/LomCLl3GibPwV98Rhg1zGqlF0IKCDl7Jyrwhg5uHzMws9rxdReUUcE6fNJfrbXIzzz6g5We1Enb46QJLpyNvEfoEF4XOQgs7+y0OoFYTM0XVCmFzEWpcSlI+hd+ogw4MVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887711; c=relaxed/simple;
	bh=KKZE3T3XTFMGsmh9i0AIpbipDrxFXNNLqCJMxOgux70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1noedRfS+X4yo5FA4P5orUROK9n6oNuHQbHyiXfURb6kWfst9kmvKDPW5TrdFvIQz0ZgW+vbSf79XdQGor5hv6obZaNuzfnrHbBF6/ictVKLIizC+C4seczdkasHOYjNOMliTVTp/B/rtxPCWjjRrtwZ9VkjFvJaFfpJFBrA+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmKqllS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmKqllS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD47FC4CEF1;
	Tue, 16 Dec 2025 12:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887711;
	bh=KKZE3T3XTFMGsmh9i0AIpbipDrxFXNNLqCJMxOgux70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmKqllS4gZPXBoCA6Gg+w7/oj3UTN0LFG/QcDChuTNmfxzs3Zh0/oaPii6NzKcVsk
	 u/fH+10GJY9+fMtuf6+5222mjJzfKnh7irNz3iaq7ZwrghKaggylLEjm4Bq0KRXF3t
	 DgDsvIvxgoBPaU6cUYeDaKu23NR3dL/ICv4DuRnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 281/614] crypto: iaa - Fix incorrect return value in save_iaa_wq()
Date: Tue, 16 Dec 2025 12:10:48 +0100
Message-ID: <20251216111411.555156930@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 76ce17f6f7f78ab79b9741388bdb4dafa985b4e9 ]

The save_iaa_wq() function unconditionally returns 0, even when an error
is encountered. This prevents the error code from being propagated to the
caller.

Fix this by returning the 'ret' variable, which holds the actual status
of the operations within the function.

Fixes: ea7a5cbb43696 ("crypto: iaa - Add Intel IAA Compression Accelerator crypto driver core")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 23f585219fb4b..d0058757b0000 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -805,7 +805,7 @@ static int save_iaa_wq(struct idxd_wq *wq)
 	if (!cpus_per_iaa)
 		cpus_per_iaa = 1;
 out:
-	return 0;
+	return ret;
 }
 
 static void remove_iaa_wq(struct idxd_wq *wq)
-- 
2.51.0



