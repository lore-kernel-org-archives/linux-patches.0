Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A3637F8D7;
	Sat, 12 Sep 2026 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242060; cv=none; b=JL3j+6uHYgYM2ATGEMd5nm682NBpEiU3wx/1pCS+u7VNutyGI2PQ1mNhUiGxidnBL4M1TW6vE1+HGK3hirrvqKjz8rs/A/KeGf6S5hBCFBTkfMVZ36NPBc13qLhKF610ZvrSqkpd4K7Wy1BtUTtlLrTGnasub0gjeWIe4IfA7A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242060; c=relaxed/simple;
	bh=QjV1dXjtStmFJam20CzW9yNJHky33RNLx6GLp+EcH2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=he4I9EAWJFooYefQfwm8whVF4Lx59EvihidoZnE1f3PNnXJuysFLWwwGEzlLnOhoDUFLcklvWajlmS9uQPzpCUab/3vA+YICcJgZCNmZaDLYR7wOjjwve0tZ6SK0KTZQ5cs8H3EdS5cK5VsM6GcsppZpD1v59tzwYFiclpU+T+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyI62Vfn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyI62Vfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5EC1F000FF;
	Sat, 12 Sep 2026 19:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242058;
	bh=ee8T020+8TEOujUnJOGNXRgYk/wEptu18CNk9yrMGWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HyI62VfnQXtkvhMpEv29qgJTaWXHhlOF0KDI667fXhDM+wJRiiHIOWBZ8Oq4j1Pkn
	 sGh2Cm3dEamh2EnLlvqpTZZ9xu/3WGsq90cjnvbMYhfv7zULMGJpv/xxXOd2EY7T0G
	 lv/LIMZvjBbWGddCMl1FIu9eVebKGCCK39Esk6qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Ding <yi.s.ding@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 270/798] media: cec: meson: ao-cec-g12a: name the CEC core regmap to avoid debugfs clash
Date: Sat, 12 Sep 2026 08:58:18 +0200
Message-ID: <20260912065523.346072641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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


