Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD2627453;
	Tue, 29 Apr 2025 17:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946875; cv=none; b=iquGp2+nAyoBrhaOWiOsqYfFCrzC0U2WDp/4EKKMwhMIgXMiCRwAwbocsQiPdJVCJCWq2wsqXUf81DLfowc5MrHOIbdvu5jmGNr6slyO5bNpw/z6fozaknQnNGjwNXzddxoZa14sjxWYWHqyoFttu6x85zhhx+VlUuVtQlREOPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946875; c=relaxed/simple;
	bh=aEmLQdKKsJkPjhcFscwdp34P4aJ54gnxowfF/vyeUzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbs6LuR9I1UMjnu1B6dDSEuhPEQPlc2RBrF4xs7BOvIvJXfK65uOsIUni7mu25h9Ah6i/yKqcM9U0j+j6tbeVczOhLO/+UYQTzU4B5yz1Bv+tinmBhZqNu/YNpkqlGAFwkFegDTT0yJldL7NpqM1COW1M3OvndgAIw8BThShrxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLQA753s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLQA753s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD4EC4CEE3;
	Tue, 29 Apr 2025 17:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946875;
	bh=aEmLQdKKsJkPjhcFscwdp34P4aJ54gnxowfF/vyeUzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLQA753shYVNoHgT0ElMIZY2PCc114cvRDAjCMvuEsjLPAahFEfLKDvCwiivF97jk
	 1DzldkJUxiGZCR8gXHzWvT9x+AG8AhMtd5moBS+5lj355qQHP5p77CBTRLnrZuyHcP
	 jugJnHAqkiOIqm/pbYr/Lx3zIzwXNIWF+SOjxw8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 067/286] media: venus: hfi_parser: add check to avoid out of bound access
Date: Tue, 29 Apr 2025 18:39:31 +0200
Message-ID: <20250429161110.596892749@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vikash Garodia <quic_vgarodia@quicinc.com>

commit 172bf5a9ef70a399bb227809db78442dc01d9e48 upstream.

There is a possibility that init_codecs is invoked multiple times during
manipulated payload from video firmware. In such case, if codecs_count
can get incremented to value more than MAX_CODEC_NUM, there can be OOB
access. Reset the count so that it always starts from beginning.

Cc: stable@vger.kernel.org
Fixes: 1a73374a04e5 ("media: venus: hfi_parser: add common capability parser")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -19,6 +19,8 @@ static void init_codecs(struct venus_cor
 	struct venus_caps *caps = core->caps, *cap;
 	unsigned long bit;
 
+	core->codecs_count = 0;
+
 	if (hweight_long(core->dec_codecs) + hweight_long(core->enc_codecs) > MAX_CODEC_NUM)
 		return;
 


