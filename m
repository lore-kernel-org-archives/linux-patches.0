Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1E13B1EFC;
	Tue, 21 Jul 2026 20:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667000; cv=none; b=d+3mkxfwrdtw9QTE4v2lSKRn9Yhp3t+X0hPw4XTjkEPldLDdPMI6V0xoa30NOGIfvA2H1xSw61Azgvl6if9oSDX6+ujbGTexua2LzhXr0yDgTzI344T4bfNGstMO1KpLMnC96TbGKMhuqoynUtcfjGagndtzRQ7f9M2eQJVRXKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667000; c=relaxed/simple;
	bh=qjPPr2OkUvWtDGSNd49KeYVYyecd8TxUMW3MC+lbOP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PIV32r9Elz+gcBzfAhNrg868aRaNUb8ypbSFgxIKxh/iGwp6zjehMwNO3u4YTDZR3QaFHMFpZCKB65C8U+8+O32VWXtloX1TVhdGXW3HZv67LfeV/fAV9+PmfR82JEHeKfXTIXzpcbV1z9/CWvO7vM436i0FEwnwgk1pPDwoKcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csXx/Sq0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csXx/Sq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670D21F000E9;
	Tue, 21 Jul 2026 20:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666998;
	bh=qAvH3qWFCJsLLkeCEyfX/lQloID6eOO0EEx8Ts0inlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csXx/Sq0HLizyeQhX5VtGDqfXCe2Zmj0VPW6dS9d/dq6foAFLrOSWySAfRs4l+SGI
	 8pj7U2vmaNdG3J3FpfaCV4w6rEt8C6RmzWp7aqvStEciAfDhBoMivXCCXHaFCL6Jfz
	 Q3NiPsAX8cFuIIn4XNy/Y2A66grcn5PyZ3kSPGPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0895/1266] ASoC: SOF: topology: validate vendor array size before parsing
Date: Tue, 21 Jul 2026 17:22:12 +0200
Message-ID: <20260721152501.876858279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 8468dd79cfb2ffbdeaf7c353f63d64941cb8ba05 upstream.

sof_parse_token_sets() reads array->size while iterating over topology
private data. The loop condition only checks that some data remains, so a
malformed topology with a truncated trailing vendor array can make the
parser read the size field before a full vendor-array header is available.

Validate that the remaining private data contains a complete
snd_soc_tplg_vendor_array header before reading array->size.

The declared array size check also needs to remain signed. asize is an int,
but sizeof(*array) has type size_t, so comparing them directly promotes
negative asize values to unsigned and lets them pass the check,
as reported in the stable review thread reference below.

Cast sizeof(*array) to int when validating the declared array size. This
rejects negative, zero and otherwise too-small sizes before the parser
dispatches to the tuple-specific code.

Link: https://lore.kernel.org/stable/CANiDSCsjR5NHqu_Ui5cOqWdJgFqmYsQ9WR8O7m0WOhngaYXFpw@mail.gmail.com/t/#m9b3be379221e79327cc13fd71009287368ef4f23
Fixes: 215e5fe75881 ("ASoC: SOF: topology: reject invalid vendor array size in token parser")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260603-sof-topology-array-size-signed-v1-1-84f97879a4ef@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/topology.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -719,10 +719,13 @@ static int sof_parse_token_sets(struct s
 	int ret;
 
 	while (array_size > 0 && total < count * token_instance_num) {
+		if (array_size < (int)sizeof(*array))
+			return -EINVAL;
+
 		asize = le32_to_cpu(array->size);
 
 		/* validate asize */
-		if (asize < sizeof(*array)) {
+		if (asize < (int)sizeof(*array)) {
 			dev_err(scomp->dev, "error: invalid array size 0x%x\n",
 				asize);
 			return -EINVAL;


