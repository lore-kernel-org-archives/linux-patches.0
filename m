Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0A046444;
	Tue, 10 Sep 2024 10:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964594; cv=none; b=UE3Pc1SeNpslRmIc169BrDnLc1SMevbGRaCAAr/KifWGL99xmfRGiORJjTZBb5oKdzfxxGubnk1K6Nmf6O83dIwm+c4oxH4ay50uprQQzDEmiQOaOCcNXrDYRdvtAjrdvXAzAoXFRtX7LXCJBulYwPL3r9jy0dDKMNXGj5x4kQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964594; c=relaxed/simple;
	bh=Nto8s5FmooZs9x9l6oh6pAiyL5mEBcw8xa7TpZHXxis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amRwobOTEDzT+vxhqdsPnBPs/7ylJmXjyAR+8Lpa4/Cif4+8VgmC1nAixtGOoSf9XkxBkHUqW4m37af+aCQ242utgzU2QCPOKJCCLkVAEo0GXc68FKxi4peKwq+Na9iLG7DTLe6IsE7vKQVMATVg09cuWPxQOTkiTA3MpLffvY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOjriLI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOjriLI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50545C4CECD;
	Tue, 10 Sep 2024 10:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964594;
	bh=Nto8s5FmooZs9x9l6oh6pAiyL5mEBcw8xa7TpZHXxis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOjriLI6gi8G4oZvqvaKB313SdQuA77cklG0VMxzN7ObBvqi9gIikofcW2PAShTBU
	 K2c9vvNi+YcR4T0j6RsVsEufzmXrfR1v0iGUFbyljcbz5f0iu3J+/TIPFuhRgawWJh
	 IVTPkXUeM4B+5+oCMjbrmyHelUZFIqcE8p6CJuhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dumitru Ceclan <dumitru.ceclan@analog.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 208/269] iio: adc: ad7124: fix config comparison
Date: Tue, 10 Sep 2024 11:33:15 +0200
Message-ID: <20240910092615.458038290@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dumitru Ceclan <mitrutzceclan@gmail.com>

commit 2f6b92d0f69f04d9e2ea0db1228ab7f82f3173af upstream.

The ad7124_find_similar_live_cfg() computes the compare size by
substracting the address of the cfg struct from the address of the live
field. Because the live field is the first field in the struct, the
result is 0.

Also, the memcmp() call is made from the start of the cfg struct, which
includes the live and cfg_slot fields, which are not relevant for the
comparison.

Fix by grouping the relevant fields with struct_group() and use the
size of the group to compute the compare size; make the memcmp() call
from the address of the group.

Fixes: 7b8d045e497a ("iio: adc: ad7124: allow more than 8 channels")
Signed-off-by: Dumitru Ceclan <dumitru.ceclan@analog.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20240731-ad7124-fix-v1-2-46a76aa4b9be@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -146,15 +146,18 @@ struct ad7124_chip_info {
 struct ad7124_channel_config {
 	bool live;
 	unsigned int cfg_slot;
-	enum ad7124_ref_sel refsel;
-	bool bipolar;
-	bool buf_positive;
-	bool buf_negative;
-	unsigned int vref_mv;
-	unsigned int pga_bits;
-	unsigned int odr;
-	unsigned int odr_sel_bits;
-	unsigned int filter_type;
+	/* Following fields are used to compare equality. */
+	struct_group(config_props,
+		enum ad7124_ref_sel refsel;
+		bool bipolar;
+		bool buf_positive;
+		bool buf_negative;
+		unsigned int vref_mv;
+		unsigned int pga_bits;
+		unsigned int odr;
+		unsigned int odr_sel_bits;
+		unsigned int filter_type;
+	);
 };
 
 struct ad7124_channel {
@@ -333,11 +336,12 @@ static struct ad7124_channel_config *ad7
 	ptrdiff_t cmp_size;
 	int i;
 
-	cmp_size = (u8 *)&cfg->live - (u8 *)cfg;
+	cmp_size = sizeof_field(struct ad7124_channel_config, config_props);
 	for (i = 0; i < st->num_channels; i++) {
 		cfg_aux = &st->channels[i].cfg;
 
-		if (cfg_aux->live && !memcmp(cfg, cfg_aux, cmp_size))
+		if (cfg_aux->live &&
+		    !memcmp(&cfg->config_props, &cfg_aux->config_props, cmp_size))
 			return cfg_aux;
 	}
 


