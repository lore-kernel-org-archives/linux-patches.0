Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9189622A7F6;
	Sat, 12 Sep 2026 14:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221949; cv=none; b=s6BK6GzIBj3MYH7ryiWNfAYl4iYiV8lAnB2VPtnjHaPGGhCCpbhCR8i/+JJT70u4rKSmSExgF7IG4iGM4LRgPdO0N2/3Qbb9K0bOktL5VP0mxN9DKSL40S6LySHPxR5Eyo5kVLUit/yrkKWkAwVd6g/Cy7VniSLUzBD6H+//C3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221949; c=relaxed/simple;
	bh=wV7nhu74SQpvh31/GGYhthJGOuEhhcuAbIiTdRRh+pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pgzzz0yTLNOJfJ6khS0/WqcXq6nQAg8Q4NgFhsFt/QcihIqBvhBFfi/tOxgAbzVfiAEnc/Lq16oh9w9RE/KDjx+gUP+KifHVJMexEhqp5VrCBvc/6lfewlC3LM5UKq1AlvkkL6xDR0FZ9pqWG7Xw0qt6oZN5YTBnwDh7ymUA+JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4JQZb/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4JQZb/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D1A1F000FF;
	Sat, 12 Sep 2026 14:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221948;
	bh=Py8CRtMd/eW1ePJfg0C5NwzZJSqdnUv15A09nUBiFFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4JQZb/fdqJTn5S9eBxItA9DKrn+oBhLZWobJmUjQzdq9epzP9FkqM26ocd1pCWuW
	 +fNudA911w/ArWfFZctulPfE3TF8g9Ly5psIxTvBOeFqE/1qsRbI0kmqHzPbjxGsYZ
	 Km8DfSmYujUu42d6164C26kqJAUo4DB1LpFkyaHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Ding <yi.s.ding@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0443/1424] media: cec: meson: ao-cec-g12a: name the CEC core regmap to avoid debugfs clash
Date: Sat, 12 Sep 2026 08:47:55 +0200
Message-ID: <20260912065617.206128537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


