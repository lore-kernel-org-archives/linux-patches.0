Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44523750AC;
	Wed, 30 Sep 2026 15:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783208; cv=none; b=lektHHCE1Ki/vHysPkEffUktbghJUzhfnLinxu6JAQw5vIPjG2L2c5GKXq8iVQBjgSI6BBVg0U0r5+AxvkkBvMp3w3scfuFI3gexN6jwaP4O6c//UMrfM+eKl0XAviMu9RyVvP6wM8hBnbLxZbMSprdLq9AhMMwC69UMo9NFOfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783208; c=relaxed/simple;
	bh=WVo/NwLm+2gAqK4Rt+nZbsQ4WBVKDUA9QxeEYSrlAI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2E05QESeCZ1fyaPjM8qu9kIl/WCnpocopImzPnC4IGablWSLDkjfb1/Q0wj81NvzuFYuvZ8ex3p2KCzVdQce6oNl9TvY6wK04Sci4YE69OSrugz/ZQ+WThXb+Ig6KTxBTvTmPi5L7Dx/WItUxc30FhfdaXvcKbRO5eF0dyU+bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZYbwmYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZYbwmYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BE31F00898;
	Wed, 30 Sep 2026 15:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783199;
	bh=3pbL3GuqGoZcmqqRqP5159sy4Mjr/h3Oqu/932hTnBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZYbwmYiTgIo7warMRj5QYstlsKbeC/YGbLOOP1FOQjUnZDC2VVgsGytPp2EFCo6P
	 +URHqYqQiQWvUVMuWr4ExrEoqu629bVVKGqiGN60MMryBL+iopLubFp3Y/bMk00xKm
	 PLlwtscIxw4ADy9yplngyOBQy86gI8qCoIiQHF40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas@ndufresne.ca>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 316/595] media: v4l2-h264: Fix memcmp() size in B1 reference list comparison
Date: Wed, 30 Sep 2026 17:23:29 +0200
Message-ID: <20260930152354.484530410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -258,7 +258,8 @@ v4l2_h264_build_b_ref_lists(const struct
 	       v4l2_h264_b1_ref_list_cmp, NULL, builder);
 
 	if (builder->num_valid > 1 &&
-	    !memcmp(b1_reflist, b0_reflist, builder->num_valid))
+	    !memcmp(b1_reflist, b0_reflist,
+			sizeof(b1_reflist[0]) * builder->num_valid))
 		swap(b1_reflist[0], b1_reflist[1]);
 }
 EXPORT_SYMBOL_GPL(v4l2_h264_build_b_ref_lists);


