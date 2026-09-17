Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7222C4BA1F4;
	Thu, 17 Sep 2026 18:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671133; cv=none; b=n1sr14dHumW0YHn+7Tg5I4MzG1rKPHj3ZhhrZ4uRooDJzK9cb/LTjUieBfRLUK5UVl7YJ9E5LA6SyEUYdOXABk+fnh7SpyeWw8Nz7Co+Teu2I60xfYmIq0FqEqB5L2H7k+v5zCw3iVSY4QSe5qYH3RQaGCey6nl2M9+2KuDd30w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671133; c=relaxed/simple;
	bh=thtFHtwJ9n6RN4yssO3cJFX8rHkvL2zWAtZJvPDI2zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrGATn0FTXOhfbbW+9X0IqQrP9Kgvb4bsezt92ffLbkn60oFX0jzsuQbNOIEQochEc9OPTURfI8ZMHrScyUUHSW1+mA4XV+h+zQS/v1UWic4qdw4Ap6opcKnc1abOPhPgDgcdAXtb9WuXqDY9j+/L/c+X5hHaYBNzuN0oL5YhiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mzzh9GOv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mzzh9GOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AB91F000FF;
	Thu, 17 Sep 2026 18:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671132;
	bh=IfVsSa9wcPAecHmsVJw6NVSIIPtYQ2nc25NdFnwLR58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mzzh9GOv1Na5Pf4HeZ1DWPWd1ntFetX53/szWS7gn0pU28lkA9oYZiSQyS2jlgQFY
	 cztD6ryHu4T81Xcq4UA73+PxLUnjP2q0J03tiez4E9D/s4ufSPVexQV6Fb1SjWBiU9
	 0sNxq5+NRhBX1mdXEdZegaFVBZhiFq9Ok3jWNeik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas@ndufresne.ca>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0877/1102] media: v4l2-h264: Fix memcmp() size in B1 reference list comparison
Date: Thu, 17 Sep 2026 16:13:40 +0100
Message-ID: <20260917151602.582243034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

commit 10e59fbdef13597836bd6459095caa02c80af3d7 upstream.

In v4l2_h264_build_b_ref_lists(), the B0/B1 list equality
check passes the entry count builder->num_valid to memcmp()
instead of a byte size. Since struct v4l2_h264_reference is
two bytes (fields and index), only half of each list is
compared, so distinct lists can be wrongly treated as equal
and trigger an incorrect swap(b1_reflist[0], b1_reflist[1]).

Change the memcmp() size argument to sizeof(b1_reflist[0]) *
builder->num_valid so that the full byte length of both
reference lists is compared.

Fixes: 624922a2739b ("media: v4l2-core: Add helpers to build the H264 P/B0/B1 reflists")
Suggested-by: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: stable@vger.kernel.org
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-h264.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/v4l2-core/v4l2-h264.c
+++ b/drivers/media/v4l2-core/v4l2-h264.c
@@ -440,7 +440,8 @@ v4l2_h264_build_b_ref_lists(const struct
 	}
 
 	if (builder->num_valid > 1 &&
-	    !memcmp(b1_reflist, b0_reflist, builder->num_valid))
+	    !memcmp(b1_reflist, b0_reflist,
+			sizeof(b1_reflist[0]) * builder->num_valid))
 		swap(b1_reflist[0], b1_reflist[1]);
 
 	print_ref_list_b(builder, b0_reflist, 0);


