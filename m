Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23EF186E34;
	Mon, 12 Aug 2024 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479159; cv=none; b=PPRORq08xtISjvM2ADL6wKq3CIvRVSkj7NDhUAdKbhbENJAN+q2EnzhfBcKkuN7UW4wITFe5Ft+8AZ5WQxy+o6mnzu9wsc7Jftw007lEghiodwT/cz6NgdVeo0XHjwz2UBUN7H4iMuEjzU/wJe62zG3UB9tsdF6tL/t/pS/MbAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479159; c=relaxed/simple;
	bh=zWRuBQNHu2CGfDnQcWArHU14oJVgdWEXZ36JHp61hJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyxG4gBoy2L/IwrF5Bw7zcqjSmtd9sXCyEqf9tpWfibKMAl/+ijp6aZ5DTQ9Gsr2sIlFLqx8D+v6a4O2OtTmUeO467bOUOCf7jIg8lIws2xWe6ZSkpAEAFNmXKdVL8db4DqO0o2npYIVbhY0hJm1A/R5GbzSTcPAQPUIohWs8uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zgt6K8EH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zgt6K8EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC098C32782;
	Mon, 12 Aug 2024 16:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479159;
	bh=zWRuBQNHu2CGfDnQcWArHU14oJVgdWEXZ36JHp61hJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zgt6K8EHNim7fsSK/2njE5Jn+8hq6320dDqEc5WLQf06R1sesFf+mfOSHRIp/2kzw
	 TAnQzycE3qYFlPn+6hB6x3/a8qPecsGkHmcEhaDVycWDmoA7oBNOuXsixmRJ73poO1
	 OAaf78ABNKIB8aeqpf7DZZDqBK3RNM1I7sT/0GCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Muller <philm@manjaro.org>,
	Oliver Smith <ollieparanoid@postmarketos.org>,
	Daniel Smith <danct12@disroot.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Qiang Yu <yuq825@gmail.com>
Subject: [PATCH 6.1 126/150] drm/lima: Mark simple_ondemand governor as softdep
Date: Mon, 12 Aug 2024 18:03:27 +0200
Message-ID: <20240812160130.024646147@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

commit 0c94f58cef319ad054fd909b3bf4b7d09c03e11c upstream.

Lima DRM driver uses devfreq to perform DVFS, while using simple_ondemand
devfreq governor by default.  This causes driver initialization to fail on
boot when simple_ondemand governor isn't built into the kernel statically,
as a result of the missing module dependency and, consequently, the
required governor module not being included in the initial ramdisk.  Thus,
let's mark simple_ondemand governor as a softdep for Lima, to have its
kernel module included in the initial ramdisk.

This is a rather longstanding issue that has forced distributions to build
devfreq governors statically into their kernels, [1][2] or may have forced
some users to introduce unnecessary workarounds.

Having simple_ondemand marked as a softdep for Lima may not resolve this
issue for all Linux distributions.  In particular, it will remain
unresolved for the distributions whose utilities for the initial ramdisk
generation do not handle the available softdep information [3] properly
yet.  However, some Linux distributions already handle softdeps properly
while generating their initial ramdisks, [4] and this is a prerequisite
step in the right direction for the distributions that don't handle them
properly yet.

[1] https://gitlab.manjaro.org/manjaro-arm/packages/core/linux-pinephone/-/blob/6.7-megi/config?ref_type=heads#L5749
[2] https://gitlab.com/postmarketOS/pmaports/-/blob/7f64e287e7732c9eaa029653e73ca3d4ba1c8598/main/linux-postmarketos-allwinner/config-postmarketos-allwinner.aarch64#L4654
[3] https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/commit/?id=49d8e0b59052999de577ab732b719cfbeb89504d
[4] https://github.com/archlinux/mkinitcpio/commit/97ac4d37aae084a050be512f6d8f4489054668ad

Cc: Philip Muller <philm@manjaro.org>
Cc: Oliver Smith <ollieparanoid@postmarketos.org>
Cc: Daniel Smith <danct12@disroot.org>
Cc: stable@vger.kernel.org
Fixes: 1996970773a3 ("drm/lima: Add optional devfreq and cooling device support")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/fdaf2e41bb6a0c5118ff9cc21f4f62583208d885.1718655070.git.dsimic@manjaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/lima/lima_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/lima/lima_drv.c
+++ b/drivers/gpu/drm/lima/lima_drv.c
@@ -489,3 +489,4 @@ module_platform_driver(lima_platform_dri
 MODULE_AUTHOR("Lima Project Developers");
 MODULE_DESCRIPTION("Lima DRM Driver");
 MODULE_LICENSE("GPL v2");
+MODULE_SOFTDEP("pre: governor_simpleondemand");


