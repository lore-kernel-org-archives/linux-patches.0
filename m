Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF471612D7;
	Tue, 20 Feb 2024 21:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463840; cv=none; b=MhMWaaTTzADakto+J7EYewOc/v9V4ssSPWf1LMdMiLt84j31z0o2l7gOLxKGmQqxxlMqM4wV1R6FaE5AtsV7hfqKbs8b8JBSNVlpOIui5aQ87Fc01I18/sVLzyWTmCcaAPWUMiDP46/dYC+jv0Vr9l+n/gDNwFl3L5CKCm09s6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463840; c=relaxed/simple;
	bh=VPXLMb8pq2ap+hdoELr0NUhBxkRt9MqIUof6RDp9J5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WYCj9wIZZHj4s8c1QGTPcKdtMZ5Uak/xUKxFk3wx8wr/3A1dLps1DehblIhPwfPuLQDYr+0DRzYKGQ2+O8liXJqvBSFmSHWvHN6ItUQyML3z+IcTu3CLhPjqCVIBn2wN9jkNXJorTFMxxhyY5cs0s6Vw1narPPliv+QoDifhvOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fLf71k+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fLf71k+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EBBC433C7;
	Tue, 20 Feb 2024 21:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463840;
	bh=VPXLMb8pq2ap+hdoELr0NUhBxkRt9MqIUof6RDp9J5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fLf71k+830BNiUj+08XJZP+cPochX41a1VGyQ1QiNKKxrllF5jXvdSb6YnqaALEk
	 AXY31+nhTNEdJgy9lGIIqu3w/2DwyZWRaJzswuvzBWYloAcZ+5oucmfMlJJz8tTNXf
	 eYvOSer7HFZ5l2iwO81z6DD8xKxol/EFgwxUPL0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.6 169/331] drm/prime: Support page array >= 4GB
Date: Tue, 20 Feb 2024 21:54:45 +0100
Message-ID: <20240220205642.829090480@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


