Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8D83438A6;
	Wed, 30 Sep 2026 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791725; cv=none; b=nyaNYZWildM6VyKRgVZ3VfUMMsgit9ucsVMk+6460y8rGJz+6YTka/7C53l4mg12rSChdXiU5+1Jz03Gv/3F86S5YOJM1i6mhye+jRh4AFVTDDuLFRT8Kb97gLhr23O+OWsBxuhgohC/Sr8LWYzi+P053+/1I9rDDd9Mi+wjmTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791725; c=relaxed/simple;
	bh=Sbt1kY166w6Ta5jbP3q+rrH6vsASyK1h4QmxR8mE2wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E278RWnNcK++OqY/mVuHBf+rVl1UiVqSyZK0lo3LIcDk0iNBjk4QFaMViNRK8QRTR+nADf+5/VHtHgmXRdYsY8kXVEnU41fQ+MiQ/x2jMDIoLwBnvZhR6cMv8IGURwX/g0t/0A0oPM39TG7iCYm8SXE3ABbyMGt1KW50g6Ud6HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJpT4mVY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJpT4mVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F62A1F000FF;
	Wed, 30 Sep 2026 18:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791723;
	bh=/DF3nju9D7RgmehzuWHKWFxquzch5jlfmv5yljiSVN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJpT4mVYI4Hbi/PQAJrakUg0YM9/PEgKQYL0WdXrmH03Nax2UzusbCEI0Py6RWxI5
	 LfzjNWBgzWfPK+Ew46Z5LH+f7X0DHbE+NAVTxrBhR1sTVW3MFh4pYeehbiP5VnlmTu
	 Md2Xs9fHvh8Vj+3bDOHFIl9B5YH7jWNzf/mGXaGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas@ndufresne.ca>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 402/752] media: v4l2-h264: Fix memcmp() size in B1 reference list comparison
Date: Wed, 30 Sep 2026 17:24:32 +0200
Message-ID: <20260930152406.980821136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


