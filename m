Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C1B364C1;
	Fri, 24 Nov 2023 18:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRhW6bgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8979C433C8;
	Fri, 24 Nov 2023 18:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851374;
	bh=L1i3RITl47cD3NmIRTu3hAeIpAVec2p0Y6Db3E5HP24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRhW6bgn6yENyfYi5HacQfvQ0CJFqOh1MzWdr/3qNU3X7EG3pxeS9YMvTJT+DwX3e
	 6Zff3jSa6D/nBOkS0MmQhOqxxUegTrSm2Ml4n2NzwlC3AeOytxy28mSEtNm4GiNUzk
	 vc0rk+PwB4A9KGb2GZv2pUehxH2T5HM+48C+LkMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.5 423/491] media: venus: hfi_parser: Add check to keep the number of codecs within range
Date: Fri, 24 Nov 2023 17:50:59 +0000
Message-ID: <20231124172037.322262821@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikash Garodia <quic_vgarodia@quicinc.com>

commit 0768a9dd809ef52440b5df7dce5a1c1c7e97abbd upstream.

Supported codec bitmask is populated from the payload from venus firmware.
There is a possible case when all the bits in the codec bitmask is set. In
such case, core cap for decoder is filled  and MAX_CODEC_NUM is utilized.
Now while filling the caps for encoder, it can lead to access the caps
array beyong 32 index. Hence leading to OOB write.
The fix counts the supported encoder and decoder. If the count is more than
max, then it skips accessing the caps.

Cc: stable@vger.kernel.org
Fixes: 1a73374a04e5 ("media: venus: hfi_parser: add common capability parser")
Signed-off-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -19,6 +19,9 @@ static void init_codecs(struct venus_cor
 	struct hfi_plat_caps *caps = core->caps, *cap;
 	unsigned long bit;
 
+	if (hweight_long(core->dec_codecs) + hweight_long(core->enc_codecs) > MAX_CODEC_NUM)
+		return;
+
 	for_each_set_bit(bit, &core->dec_codecs, MAX_CODEC_NUM) {
 		cap = &caps[core->codecs_count++];
 		cap->codec = BIT(bit);


