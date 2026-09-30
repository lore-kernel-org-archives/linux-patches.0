Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76894FE2E6;
	Wed, 30 Sep 2026 16:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785525; cv=none; b=Vv3euDJ+rIgFCIoN8zbpWZQKtIQJuJ6dK/gzamMBzmlHtx/g8s17fTsjOY1fhlAEhmMX87W5CLpGe7rRrJ+IGUfzT6gdqdlh9eOCNpUWB1rAeGO/FeYEZyy8Xcj8qU8sYUS85VC1seqJXQvaIUfy7D+kcCkb6eb4PZWXa+pFXnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785525; c=relaxed/simple;
	bh=FcD/HT+f6OtEYkLadMo1xy+qKD9YSTLaslZvPT2ULHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1JFGS+4f2THIvubIQgcs+Xyaq6WN/Z1h/srmu14CDc22wP261FEzxqZzhXlSyPkjy7Up2pNVWmdwhnET6p3DzhX8LyD6l2Ay97AYbQBdG9bYrb4/rc2nSA2/5KmeAyG3kjpPsMFQgClQXI5EIWzVE7b66/33seFDvQO0nkyPfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9Of7LFV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9Of7LFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090721F00898;
	Wed, 30 Sep 2026 16:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785520;
	bh=MMtotpXjd8pXaV2f0Kf/HPHUEUuFt5mlScj0SCjQqKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9Of7LFVV6+YoVilMUNkCLUu905FNeVMU4ONoeHSat2lLomFTV8m8rcZfEy1AcEVP
	 Rkfpv8wiBrtQWLdogPC9z9BTzVxpwg58wZf7UmLVB27ZXQ6L1ei1di5Rtjy03ebZ7k
	 RG94wQBX3ztRClCshA/CWkj38xT0JRiDemLo1JUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas@ndufresne.ca>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 536/982] media: v4l2-h264: Fix memcmp() size in B1 reference list comparison
Date: Wed, 30 Sep 2026 17:21:12 +0200
Message-ID: <20260930152428.282852902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


