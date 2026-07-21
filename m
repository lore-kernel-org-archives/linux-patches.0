Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE838401A21;
	Tue, 21 Jul 2026 18:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658332; cv=none; b=oOsKOUzPNFU9ZlkL69HiDUMSa3lcsV7sFU/SruUJ6oJgi7uM/PCx8ECEtkLPpMHFOjV37uvcEjyI/XGPrmVuo65H1LAUXYUoCYndJ0LPr3zKbVbkbqQSoMd5pDLAgpDnMtGk/NJ6IEcan1ojyHxpHil/6CEdi3TobnrSYHZrfxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658332; c=relaxed/simple;
	bh=YiuFF0W862yvI5E7sC4D+kbm0b+I53FVASYCQg7Ae3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AIp/50iflw8mQaDdVd3C9HAKriMJbQjNIyDXFEFQWbBLzPVagab3g1WPbfF5a9XLHNqAXx+pwxUtPmwXKhp/3qNoZ9qAIyIM/2bPcUxxubFJM7/P30LEOkXXIgpUFYVPdQ6lOGvbohNYzwZojnj6uZT9KDZ6zuuguPLp5yJlAnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oD2lbKAr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oD2lbKAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5471F000E9;
	Tue, 21 Jul 2026 18:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658330;
	bh=OEAqQ0XsLfkS5Ug8X1itCgIFxN+d3L8uzIHhhpM0jMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oD2lbKAr/jZLi12tUVpLfhyzFHpFD/kRnXm3aOezPKtdEGF203uhqtzqCn+CGyXy5
	 tGZ7nNBOvSpN1D0EJ0C0JtwnI52T9JBdzOFVzG9YIbqzYar0Nm4Mrn4Bbsh60eBZ+L
	 0PvdqcdULYgjBFJoFy9r2XoZSMg7AzuOvLZtEeaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 1102/1611] ASoC: SOF: topology: validate vendor array size before parsing
Date: Tue, 21 Jul 2026 17:20:18 +0200
Message-ID: <20260721152540.203650409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -733,10 +733,13 @@ static int sof_parse_token_sets(struct s
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


