Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2481E569F26;
	Wed,  9 Sep 2026 14:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962727; cv=none; b=H5bw1hodl3eVRC8IrN4YS7l9nPvR/sTHKfKyc0YDTUtu79OB51kgqr596fGTuneyPCAPF4hBN2IsShflbfzptV4j6krmEtG7/8vA9243IV0MAduJC0ab9rKN0oCaI5Dj0xmr0n41bjjD2HMQTuX+Tuhs+/1MPLibECV33viqx0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962727; c=relaxed/simple;
	bh=w4YLi9Ia3NqSa9pW3/cICEPt6kEUdWYULKmI4yahVt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M613YUldOpZKVk/eTpkf8ibGqxV3ZKykDXyR26WL3WINRZthr+cBOM2z9VF75G7bHnWc2aTD+Mn+RKanyP7lOlgq61Nb/Dr0CDOJOTt05piX2bgzfP/BhWngIPYAx4GAs6v/9kja67H+hlym9GL9xDIYWaSJGH4R2a9COcat1fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBoEODTF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBoEODTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421B91F00A3A;
	Wed,  9 Sep 2026 14:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962725;
	bh=+pnK6BUJnojesDiXKV+Z7RMdpxoNGI8jkkMlQzHrZRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VBoEODTFixkb3gK9GK3BELKGiGhojbxRJfVD9F1rEzFk2KvjFLiZVUeYuCESdnKZl
	 MoWwAGUqUMrUzZyKVV68EVm7qajAO5GCJ/RVQs5/CVtmsweLw1HS/obw9Tzb82T8iz
	 L8eeBIWhhVcZCdfDXFec8mJQg+6pZDuDVX1IAd/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Ding <yi.s.ding@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 352/556] media: cec: meson: ao-cec-g12a: name the CEC core regmap to avoid debugfs clash
Date: Wed,  9 Sep 2026 15:40:32 +0200
Message-ID: <20260909134243.041957052@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Ding <yi.s.ding@gmail.com>

commit 172c5a7d81deb922ddedd1bc920751c7fed6c43c upstream.

The driver registers two regmaps on the same platform device: an MMIO
regmap for the AO CEC registers, and an indirect regmap (using
reg_read()/reg_write() callbacks) for the CEC controller core registers.
Neither regmap_config sets a .name, so both default their debugfs
directory to the device name and collide:

  debugfs: 'ff800280.cec' already exists in 'regmap'

Because of the clash the second regmap's debugfs directory fails to
register, so its registers can no longer be inspected via debugfs.

Give the indirect CEC core regmap a distinct name. The two debugfs
directories then become "<dev>.cec" and "<dev>.cec-core". This only
affects debugfs naming; register access is unchanged.

Tested on an ODROID-N2 (Amlogic S922X): the warning is gone and both
/sys/kernel/debug/regmap/ff800280.cec and ff800280.cec-core are present.

Fixes: b7778c46683c ("media: platform: meson: Add Amlogic Meson G12A AO CEC Controller driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yi Ding <yi.s.ding@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/platform/meson/ao-cec-g12a.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/cec/platform/meson/ao-cec-g12a.c
+++ b/drivers/media/cec/platform/meson/ao-cec-g12a.c
@@ -405,6 +405,7 @@ static int meson_ao_cec_g12a_write(void
 }
 
 static const struct regmap_config meson_ao_cec_g12a_cec_regmap_conf = {
+	.name = "core",
 	.reg_bits = 8,
 	.val_bits = 8,
 	.reg_read = meson_ao_cec_g12a_read,


