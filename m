Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D867943CE6B;
	Mon, 17 Aug 2026 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976166; cv=none; b=caHhDUvmd2FUb0vEqjf6B5GVPOck87OVH5eqPewaRMQYorKMxjW2ANRBjDD7mW/qMrtWZI/93hA4ncMdAPZUhXAh7QtfEvAms+mRDSbAcUAvswZnlZ6BXDCoYzO2SEsdaWJ4HPNYpl0iwPf0eY+3BLMkJXmtWFHPSpAME5THvEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976166; c=relaxed/simple;
	bh=ESOogm8tiqA/OgwzsFjmkC6md3fWJ8AJ03imU+5norg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPWvOtna5Bay7m6T9SW8cj9ay0mAZDRGq4Qhgpm//HT5BKxtDyYigET0eRVAdnn+znWB/uLWCj7btKs0OCKWSOnlUg7btT9+oJIZP0c5J3x9I2Mk8l+tlbxJok3QbdjVF4Y232+z2FftxDiq1elFxcDsI/AEZjVH5OpEPiLtMEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aw+MuuWb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aw+MuuWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0679D1F000E9;
	Mon, 17 Aug 2026 14:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976164;
	bh=+vK0cg0d4a4QgwwF+sbyIPmItvJ5Bp5jOqod6a1ghNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aw+MuuWb9/5mc0ylkjHl+KJHAvaFmJpCcq5Yf/3C51sP31Bju4MSq3PMg0s259hwq
	 qq0zjjBK0yrohMm3797NdRsB10A6c07hwjRiwzo4AIjWZC44uyqPoUhHzUiES7o9uq
	 hBV1nZDLiXI6DxDV7vUQkP09GqfykG4EZgEL+abQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 5.10 240/389] pinctrl: devicetree: dont free uninitialized dev_name on error path
Date: Mon, 17 Aug 2026 15:31:19 +0200
Message-ID: <20260817132548.642646093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 015b5bcbcb622b32317642be91a7f79aa5413649 upstream.

dt_remember_or_free_map() duplicates dev_name for each map entry. If
kstrdup_const() fails, dt_free_map() frees dev_name in all num_maps
entries, including entries that have not been initialized.

Some pinctrl drivers, including pinctrl-imx, allocate the map with
kmalloc() and leave dev_name for the core to initialize. The untouched
entries therefore contain uninitialized data which is passed to
kfree_const().

Reproduced on qemu's mcimx6ul-evk (pinctrl-imx) with failslab injection
while binding the pinctrl-consuming device, under KASAN:

  BUG: KASAN: double-free in dt_free_map+0x34/0xa4
  Free of addr c425a900 by task init/1
   kfree from dt_free_map+0x34/0xa4
   dt_free_map from dt_remember_or_free_map+0x184/0x198
   dt_remember_or_free_map from pinctrl_dt_to_map+0x33c/0x4c8
   pinctrl_dt_to_map from create_pinctrl+0x9c/0x5c0

Initialize all dev_name fields to NULL before duplicating the device
name, making the full-map cleanup safe after a partial failure.

Fixes: be4c60b563ed ("pinctrl: devicetree: Avoid taking direct reference to device name string")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/devicetree.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -69,6 +69,10 @@ static int dt_remember_or_free_map(struc
 	int i;
 	struct pinctrl_dt_map *dt_map;
 
+	/* Initialize dev_name before any allocation can fail */
+	for (i = 0; i < num_maps; i++)
+		map[i].dev_name = NULL;
+
 	/* Initialize common mapping table entry fields */
 	for (i = 0; i < num_maps; i++) {
 		const char *devname;


