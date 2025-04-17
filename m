Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A001A3178;
	Thu, 17 Apr 2025 18:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913199; cv=none; b=SFz4HMKa3/LFUhDcp9AoLGOO9aQwzzVnCflRVcTr0BZc9q+PcmlGy6rtdT/9qeAVvV2ZfJIrKYo/GUmXvBqNc4cDeXYBmZOtY0b7V+EaCnKu3GfSb4JicM68K32BWMERBMElk5EhsR/0ERMeWD+7f0EeUHNph3etvARtiVScMyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913199; c=relaxed/simple;
	bh=VWOgztvISG8H+4+anfHN/f4j2VCD3B/Fpc7cvKwjkV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7YI0rgnSb+HtXpiP/8hCJ8fBEsWZRtG4rGG0WLWvlu/RrTWb4EFBKw1pq9GQG2wSw3utrYipXyHReN2dkLWWqjUH5/6sWhLThgqjoA62bzHBWOurjKle2RUvdakKoyoeZv6siZL+3E9Uu5JqZdVFBs9cjNxhRtcVCNW18h08jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AC4vH2og; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AC4vH2og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C8EC4CEE4;
	Thu, 17 Apr 2025 18:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913198;
	bh=VWOgztvISG8H+4+anfHN/f4j2VCD3B/Fpc7cvKwjkV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AC4vH2ogL9r7b3Sm0QzvtixRXvPvXoeh+k7EEKMmHU+6iWJw++3IciYWOJutErQJm
	 58RhROAz5YkVOS6zKKY1ajEQgn7DZHRZIny56LkNesc2oOuv7uxGYI7V03Vaog29FD
	 eoD70ELnS9AjPdzh5T5TxdabxsZZ/8xzqVYzDSVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 258/449] media: venus: hfi_parser: add check to avoid out of bound access
Date: Thu, 17 Apr 2025 19:49:06 +0200
Message-ID: <20250417175128.385609188@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 	struct hfi_plat_caps *caps = core->caps, *cap;
 	unsigned long bit;
 
+	core->codecs_count = 0;
+
 	if (hweight_long(core->dec_codecs) + hweight_long(core->enc_codecs) > MAX_CODEC_NUM)
 		return;
 


