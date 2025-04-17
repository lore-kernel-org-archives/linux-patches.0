Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3296C256C97;
	Thu, 17 Apr 2025 18:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915828; cv=none; b=NO/hAMWjomCqKgs70n6Ffkx6KE4IkkRkuNT6dFHyz9XUsaPbTWvxYHW5KVGyG2q3JufDBcG8/vFXCuiXAtVNBC3+vZMInxDoyKv9NU/PtgxZq6DrKlXiy7i2jxzs5Tuvnxe1L5D6Z37lG/+XnC8ZizMl01ibf58tF7KeatJpPF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915828; c=relaxed/simple;
	bh=5h3BYgDNGvCd66C3A9z+ZYGG+YT1fTgof0dP3VblnRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhhE47zBQFhsezR61++HcEIvMBwDaM7+MR7zh9rZnTW8s8DhGkTYoj5+D41R0kCCBcPtymAACyNP8T//GMCPY1I6LR1i1U5Y089JpKZG5gtYLgK94JFBEHg1nIiCv2wM4VSzrqG6iLe1Y0id64T6QB46QBejDMbO3RL7t0K4XF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUvxLqbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUvxLqbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEF1C4CEE4;
	Thu, 17 Apr 2025 18:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915828;
	bh=5h3BYgDNGvCd66C3A9z+ZYGG+YT1fTgof0dP3VblnRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUvxLqbKq9gcKhA+7aIo3cua9+eE2ryi/vv0otK69L29nCnnsqf3IjuhbCrvgxtt2
	 OJI5kn18XmkCt3T7vhS3NNZJt6aTjt7qRpaWU/JplnNlrRTjZOap+FweVhQ6IsimT3
	 e5kTAUjtHBCcW5pRUaxMTDZQgtS9eJV6p2FqkFu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 224/393] media: venus: hfi_parser: add check to avoid out of bound access
Date: Thu, 17 Apr 2025 19:50:33 +0200
Message-ID: <20250417175116.594384730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


