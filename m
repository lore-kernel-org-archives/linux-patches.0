Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5274646D2B9;
	Tue, 21 Jul 2026 17:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654077; cv=none; b=kVklpRAjbCHh7r+I0prmjlQ4X2FzRPYWpP5XfGNOCeK5nnXxVuHnWPXWdqTabIzoGGqtTMQa/3H1QK9v0sVW7v5gz2DkPqOb5nBXpPZcaSj9huK0oGrLBJW3MB6ZyJYqqVOGzzK4kMEp6zkqem1EZplJjfVtuQnxE0pQW4pnjNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654077; c=relaxed/simple;
	bh=40PxGdONYqCVMXKi16iKr8IQrCi5G8hW69NYn08IirM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fT+LyQfjWIsVlfh2idbt0bfTyfTaLWf0jpRKJKEK0T7kT+kWLtgoDCsXpzYwSDqhXaWuNhJ92ZasH+xZD2wR9ZqE91Wdf1dE20ObKDzxmhDQb89DmXIrqO5C2aA5RHJ5yEXLK4zNLox1hhG8+iXokmFrk4wyX6hos2y5DiS2Jz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fqna3XKa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fqna3XKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42F01F000E9;
	Tue, 21 Jul 2026 17:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654076;
	bh=wzhtPVAX9zT74hkbB2eQmUaiUnavp3Y+YCRuQrxja4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fqna3XKaRujN6v/oHY/1xhO3tPLt6JBTWetzTilBIRvoPsU+8dYoRDkk3w+0j4ZqE
	 T0Q3Ikcu4ASnuaGFhyPMZoLHOP4PkiwopK+sbiWwfLWNJX6yWYSKAtFW2+yJcMW+iJ
	 IHlp3Rr9siW8GHcfjUNPm3xRpE1V/F69f49qnhx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 1524/2077] ASoC: SOF: topology: validate vendor array size before parsing
Date: Tue, 21 Jul 2026 17:19:57 +0200
Message-ID: <20260721152628.727792584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


