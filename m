Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AAE22ACDC;
	Mon, 10 Mar 2025 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629597; cv=none; b=iZ4/n5Y93xQSpcxi8GllW7t8VkumzM9bW3QNYlxymdB/mL8sTJqujpN/6DIBcRm2DgBaWalmmBFWUcG7WquNXmgIkmTsSKk9bO1B60bMTWLATre/Z2rlhjfPqp9EqmUadHZez9bqQHKBoLuzpA7/fvuYQPb2REOif8pu+SlQkm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629597; c=relaxed/simple;
	bh=kHMHq7pkOAHgruKB+/u1gSNuOByOzsWTkhzUIGBRXXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ja2Sd1kMsENfSRhs4V/1wRxVnRo8OH8TmOiDKO2eBcUo6dUW6uJnLJUlqZMGdEbN6HFAdyMBogwb8Wq0Kyti1914ekIoGNtjiZXBPkqKSxkS9e8ioAfwI11GaFGKExH80VEn6mKlkX5MTbkSEjbmMOfaulLJJYt8pwoVQYxwglo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDTho9ar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDTho9ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23695C4CEE5;
	Mon, 10 Mar 2025 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629597;
	bh=kHMHq7pkOAHgruKB+/u1gSNuOByOzsWTkhzUIGBRXXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDTho9arMr2apTgf0WjBS4k5bZYQ6ikmg7CDqUYN8nYAjVKd/KOo5CRULQ7eXjb21
	 vWDm48zxgYiQGDIE27Wm/k2GeKYsD8xblU0Vx/WLeRK/9YX+ZI9/frGUM2k1yNQpQl
	 qNQ9HRAr4jredggdDy+WBJm6U8LO9ELLpdm2bT28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 348/620] media: cxd2841er: fix 64-bit division on gcc-9
Date: Mon, 10 Mar 2025 18:03:14 +0100
Message-ID: <20250310170559.347656088@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8d46603eeeb4c6abff1d2e49f2a6ae289dac765e ]

It appears that do_div() once more gets confused by a complex
expression that ends up not quite being constant despite
__builtin_constant_p() thinking it is:

ERROR: modpost: "__aeabi_uldivmod" [drivers/media/dvb-frontends/cxd2841er.ko] undefined!

Use div_u64() instead, forcing the expression to be evaluated
first, and making it a bit more readable.

Cc: Dan Carpenter <dan.carpenter@linaro.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Closes: https://lore.kernel.org/linux-media/CA+G9fYvvNm-aYodLaAwwTjEGtX0YxR-1R14FOA5aHKt0sSVsYg@mail.gmail.com/
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/linux-media/CA+G9fYvvNm-aYodLaAwwTjEGtX0YxR-1R14FOA5aHKt0sSVsYg@mail.gmail.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[hverkuil: added Closes tags]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/cxd2841er.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index e9d1eef40c627..798da50421368 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -311,12 +311,8 @@ static int cxd2841er_set_reg_bits(struct cxd2841er_priv *priv,
 
 static u32 cxd2841er_calc_iffreq_xtal(enum cxd2841er_xtal xtal, u32 ifhz)
 {
-	u64 tmp;
-
-	tmp = (u64) ifhz * 16777216;
-	do_div(tmp, ((xtal == SONY_XTAL_24000) ? 48000000 : 41000000));
-
-	return (u32) tmp;
+	return div_u64(ifhz * 16777216ull,
+		       (xtal == SONY_XTAL_24000) ? 48000000 : 41000000);
 }
 
 static u32 cxd2841er_calc_iffreq(u32 ifhz)
-- 
2.39.5



