Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF2914F9C8;
	Tue, 20 Feb 2024 21:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465010; cv=none; b=iRFBHrgcqVukSXWdZcJPbKJ2rebxvMrPnzQglRGFKTANgjWc9mZ6BpoyzEZrzqCayJfsPLhPYJiXXgugauKoNBiJVozaLodXYAWrthR2Uamu2TtRQza/KvzFLoALVlKVkXnvd6Xib4Lo9TQCUxzqVkx7yXVbIJXmq2cLbiHiyyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465010; c=relaxed/simple;
	bh=2X+SggTiJ5RDirAcvMJ9F+D+PzeYpIIwUYBsliiYyWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pMeZp9d6t4FVZ1yN5l3s9BbKoqnBM2tkLHeOcEpjScH6XPsKnglJrfr22ApI203SAz3/R3dpv2xsnryqzMgaCocGuRKNaQCnU4g6wqBpwffsbPjiN44AlPOi3OP8EEXYV5shLiz1TGAdpazpZxbOYDQLPK3ctK4cBheinQR29Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhK9Ulhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhK9Ulhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C736CC433F1;
	Tue, 20 Feb 2024 21:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465010;
	bh=2X+SggTiJ5RDirAcvMJ9F+D+PzeYpIIwUYBsliiYyWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhK9UlheuqyUbRgY2dKO9uh9OabsAR1csb3g32gH3CI0G8JiVuqyLIgk0FlTAGV8y
	 fMP1IwepoZCHwkAOWjp+xFcOdLp+5xx81M87EHpZ/tMS74bzzCc91QF+RvBLJgpXfm
	 21t4yzTpIn5Rh5H/xHt40Z8p2oA5+3L5l4HFMmtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.7 208/309] drm/prime: Support page array >= 4GB
Date: Tue, 20 Feb 2024 21:56:07 +0100
Message-ID: <20240220205639.692219081@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

commit b671cd3d456315f63171a670769356a196cf7fd0 upstream.

Without unsigned long typecast, the size is passed in as zero if page
array size >= 4GB, nr_pages >= 0x100000, then sg list converted will
have the first and the last chunk lost.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
CC: stable@vger.kernel.org
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230821200201.24685-1-Philip.Yang@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_prime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -820,7 +820,7 @@ struct sg_table *drm_prime_pages_to_sg(s
 	if (max_segment == 0)
 		max_segment = UINT_MAX;
 	err = sg_alloc_table_from_pages_segment(sg, pages, nr_pages, 0,
-						nr_pages << PAGE_SHIFT,
+						(unsigned long)nr_pages << PAGE_SHIFT,
 						max_segment, GFP_KERNEL);
 	if (err) {
 		kfree(sg);


