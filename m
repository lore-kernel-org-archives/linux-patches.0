Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD6B4B44CB;
	Thu, 17 Sep 2026 15:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660462; cv=none; b=VVMPq1V7CbWh/9TbhhsWx/YYpzv9ugjv7TcnPH880A5chILMCjrROpiWtrdj/bM7Vwuj+6sFV4BvVlm6rw3vIKHufMDw82XNfC2bYOfFJmEatZabBMZuboiKyeRh+rp3zrEOpVv0BRllMh+xcOTSYWounZK3E3ZLf5qxPBZjysk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660462; c=relaxed/simple;
	bh=bV7CjtbuZrd0KRyAQtPFQleRbEnIHQaoHrQ5+Ba6Ihc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sq4BHGqpQzzrv7veDcOu8NNJjwlEC4BuVb9hPPHZ7jlDJ+RSm7VPb/Kpcv3UFtuYWvSTeFBI0COIOqqfaumx8lqZpSWckQoBHJlN93050rkBz6lz0QiRqM9rj0lsrHGgpebqPHmqCjB2OYD1UAUobtEFO/XN2m5wuudJZEjaTMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/TY3MVU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/TY3MVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9394B1F000FF;
	Thu, 17 Sep 2026 15:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660461;
	bh=N9Ic6EqAbLGsNuuTFoJIAh++UAWOPxflnOQlKt9YeAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/TY3MVUe22qgs7De13JdrAv9E7FOBrpP7dx8ssFQ9kTR4soZS5WDP/OP7VW3u1T5
	 GRtav7qRZI9swRdTINDy6Vu3DiD14C42me5OHWVqQuy1qRq0gvCRzGCC+T3RtxM2iI
	 n2i6QpWnk9LUcs33SyGU7BGTVV6+CQU848/PGoWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas@ndufresne.ca>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 600/733] media: v4l2-h264: Fix memcmp() size in B1 reference list comparison
Date: Thu, 17 Sep 2026 16:15:08 +0100
Message-ID: <20260917151407.413312296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


