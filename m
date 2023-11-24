Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F10539FD4;
	Fri, 24 Nov 2023 19:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwSUBgDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930D4C433C8;
	Fri, 24 Nov 2023 19:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700854076;
	bh=79KP2Ou7wShKcUawHzzQIVgVDTq9KfgdTX2SMAzEM5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwSUBgDbBT46mDbTJtE2a641F1FAB8YLgztiuv5fniYZ/OG152aqpJvd5qPKZOG+y
	 wLka/ASkj9lsuC3yFKwObgCW2pC6Lw9AkcyutgBNmVu5ds+GQqS6joOWpi5Zddrtuo
	 bzVDCkqsgh2p9eB1OMwE6dJkBrV7e5taVBNL4Uag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.4 122/159] media: venus: hfi_parser: Add check to keep the number of codecs within range
Date: Fri, 24 Nov 2023 17:55:39 +0000
Message-ID: <20231124171946.914989186@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 	struct venus_caps *caps = core->caps, *cap;
 	unsigned long bit;
 
+	if (hweight_long(core->dec_codecs) + hweight_long(core->enc_codecs) > MAX_CODEC_NUM)
+		return;
+
 	for_each_set_bit(bit, &core->dec_codecs, MAX_CODEC_NUM) {
 		cap = &caps[core->codecs_count++];
 		cap->codec = BIT(bit);


