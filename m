Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A549223E340;
	Tue, 29 Apr 2025 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945350; cv=none; b=Rl10m/AW1V+yuKZxSd2bt9+refNSgp9VGJ4ihGdkeQuQjy7MwuaOMhGj749x8bQifxPUFQUtdffiKaFOfS/2hbBseMaFDyn6P7OltTKUMMvizqSRe3UNjZgW55ugUkxNstnQP6ThLJAMiUtC5gnAhkZA1w+OGr7rtgi+yLGeMyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945350; c=relaxed/simple;
	bh=vyao/Lp8UqqYyRCJaOeXL9jksTWYjKA/D3Vtqps0ufc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SV2NUjEcXz6wIkvVH3s2LpZS+OBmp+PAgawiPNbrvo8CsXTYpklUUfRM4KAN4zuX+qEtttyi90b33uZsUTQpDF9va68LOkWU3THcD99ipRG833d4gPo36y2WFAgqcwvbzcMJZNvXsN1pnhMEHBpnH9KnIfOhMlZWZw/Y2aqxMqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrrW9Bsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrrW9Bsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169DEC4CEE3;
	Tue, 29 Apr 2025 16:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945350;
	bh=vyao/Lp8UqqYyRCJaOeXL9jksTWYjKA/D3Vtqps0ufc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrrW9BskTQa+6gtWvZI4RkP1cGLnDzIEt68MxWczIwrgiUc7jTMDo57eDoEZ7ehM4
	 FHY63h9HLgjgryRAldmb1Wmt6t7VWAxcphAlz2ctuT9nqKzc3AWp5UgrQQopQvvUZX
	 /kteB88aWSSHxrUpNDVVnFMMDsl902CnOPtMBcD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 055/179] media: venus: hfi_parser: add check to avoid out of bound access
Date: Tue, 29 Apr 2025 18:39:56 +0200
Message-ID: <20250429161051.623085805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 


