Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10DC37E5D8;
	Thu, 20 Aug 2026 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239404; cv=none; b=B24Z1IvK0DC2bbS+FJhu+wzoC3Gee0JyDGHEvnfA5csU4BTL2ZcqisyAykn68jrUN4XYvSl6qQ8WLpjqTTrZVk0Vzs3IM+ix4K5QXRIQjFNy2zcPa8v0pzENGFC2os6/kG6nS4amAJVqLEiR0csRgkY84bCOIut0JpvFqzEyR/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239404; c=relaxed/simple;
	bh=y9bibwnhM7NeapMUoU4iqQEvTcSo9adj8sfXxJ/o/0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE9DQiDHrEG21ZB7JAyTovBKiEAxFjABytitxCJ74vRrZC+MzoX/tb9ImDdKaT7O4eyVkGNa4aoTzPBYEVpUFUnsR9n9VyRVxOnFiXhjl6R+kPJi4lFeqseIDYggglYKuwL56QChbDzShQPH6EEyByPCl7rrgkrI5vsNLEp/7yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUn0supI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUn0supI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D341F000E9;
	Thu, 20 Aug 2026 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239402;
	bh=ZQMYaqxjkgkyP/mK34ZuVFzW81ZUo5rt+tjvFje76Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUn0supI6++wcHJmBVNm7fvb5JNJk0pkhegyMLmhWvCbA6KWL+Oujit9MeKmH/k35
	 HLlpqf8Oxtc/9Vzp6fKvsW56waWAyXrm2BOkFU2LiV9RylfV+RirnMu/cpiryMYP5V
	 Dv7VdrScQZJ5hr9G8L0TCGjJ+HzCLXifADW2Yh5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 037/220] Input: cs40l50-vibra - validate custom data from user space
Date: Thu, 20 Aug 2026 16:53:47 +0200
Message-ID: <20260820145224.613678917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit 7d5c576cb1c86047b1fcb1aa9532e17fc5e46c1d upstream.

cs40l50_add() copies the custom data of an FF_PERIODIC/FF_CUSTOM effect
straight from the ff_effect the user passed to EVIOCSFF, without
requiring it to hold anything:

    work_data.custom_data = memdup_array_user(periodic->custom_data,
                                              periodic->custom_len,
                                              sizeof(s16));
    work_data.custom_len = periodic->custom_len;

The driver then reads two words out of that buffer: custom_data[0] as the
waveform bank in cs40l50_effect_bank_set(), and custom_data[1] as the
index within the bank in cs40l50_effect_index_set().  Neither read is
covered by a length check, and custom_len is fully user controlled:

  - custom_len == 0 makes memdup_array_user() call memdup_user() with a
    length of zero, which returns ZERO_SIZE_PTR rather than an error, so
    custom_data[0] dereferences it.

  - custom_len == 1 allocates two bytes.  A bank of ROM or RAM keeps
    effect->type out of the OWT case, and custom_data[1] is then read one
    word past the allocation.

The bank value itself is also mishandled.  It is masked with
CS40L50_CUSTOM_DATA_MASK (0xffff) but stored in an s16, so a
custom_data[0] of 0x8000 or above wraps to a negative value that passes
the "bank_type >= CS40L50_WVFRM_BANK_NUM" test.
cs40l50_effect_index_set() indexes vib->dsp.banks[] with it before the
switch statement's default case gets a chance to reject it:

    base_index = vib->dsp.banks[effect->type].base_index;
    max_index = vib->dsp.banks[effect->type].max_index;

Require the two words the driver reads to be present, and hold the masked
bank in a u32 so the existing upper-bound test covers the whole range.
The da7280 haptic driver already range checks custom_len this way.

Fixes: c38fe1bb5d21 ("Input: cs40l50 - Add support for the CS40L50 haptic driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260718074032.1864861-1-sammiee5311@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/cs40l50-vibra.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/input/misc/cs40l50-vibra.c
+++ b/drivers/input/misc/cs40l50-vibra.c
@@ -139,10 +139,10 @@ static struct cs40l50_effect *cs40l50_fi
 static int cs40l50_effect_bank_set(struct cs40l50_work *work_data,
 				   struct cs40l50_effect *effect)
 {
-	s16 bank_type = work_data->custom_data[0] & CS40L50_CUSTOM_DATA_MASK;
+	u32 bank_type = work_data->custom_data[0] & CS40L50_CUSTOM_DATA_MASK;
 
 	if (bank_type >= CS40L50_WVFRM_BANK_NUM) {
-		dev_err(work_data->vib->dev, "Invalid bank (%d)\n", bank_type);
+		dev_err(work_data->vib->dev, "Invalid bank (%u)\n", bank_type);
 		return -EINVAL;
 	}
 
@@ -327,6 +327,12 @@ static int cs40l50_add(struct input_dev
 		return -EINVAL;
 	}
 
+	if (periodic->custom_len < CS40L50_OWT_CUSTOM_DATA_SIZE) {
+		dev_err(vib->dev, "Invalid custom data length (%u)\n",
+			periodic->custom_len);
+		return -EINVAL;
+	}
+
 	work_data.custom_data = memdup_array_user(effect->u.periodic.custom_data,
 						  effect->u.periodic.custom_len,
 						  sizeof(s16));


