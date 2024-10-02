Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516F618DF60;
	Wed,  2 Oct 2024 13:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877004; cv=none; b=CmkpGtP/qYduInEMtcBfpZfIJZYrY5fQsxkpIvZK/5REPc68LuSDlnshlffxGvO8NnAgAUN/Nz2fGx/G+KBoQ5cnoEaKRRNDv+YMKD/lCbkXNPazHsS2+2aWGQWSqWvUlSW2sxIJ9jgN4akBEcFJY0G1xp1vBEe3Z0rY70oKBUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877004; c=relaxed/simple;
	bh=gw+mDln4C5kOGMHzROeQO/z1NrCRWAL/ZJirqVhQJ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t8pJ/vtbB7BMNhMX7UvQDgdmUVqIpWSD4vQM/wcAs0X4qQLVQomB9GMs0R6C1OLJIvvTuujjVwEyucRfdz807TuckAl8AM0jamNsGtlUZFt0LF0dqGs9GS+eBf7GdhTs64VOI/zvldIvbO7gFpLNAxfA9JZBVXzQzsAc6MduXW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4Z2/X2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4Z2/X2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793A0C4CEC2;
	Wed,  2 Oct 2024 13:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877003;
	bh=gw+mDln4C5kOGMHzROeQO/z1NrCRWAL/ZJirqVhQJ8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4Z2/X2BBOOlNotpsqPG3KJatnISOfiz5MPxOuEYCVeoDkErP2RW4T3LukwAOhvYI
	 OhZd5y1VMbimcoOw/RPM7ncxG/4vWMcYRk81hwehI5q8L3JK+LmWOQgNh1TrwndytF
	 KMPdnz9MsDO0QqcYOkEhtoO+E5j2N0kTTjNPEBTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ernesto=20A . =20Fern=C3=A1ndez?=" <ernesto.mnd.fernandez@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.11 600/695] crypto: qcom-rng - fix support for ACPI-based systems
Date: Wed,  2 Oct 2024 14:59:58 +0200
Message-ID: <20241002125846.464978751@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

commit 3e87031a6ce68f13722155497cd511a00b56a2ae upstream.

The qcom-rng driver supports both ACPI and device tree-based systems.
ACPI support was broken when the hw_random interface support was added.
Let's go ahead and fix this by adding the appropriate driver data to the
ACPI match table, and change the of_device_get_match_data() call to
device_get_match_data() so that it will also work on ACPI-based systems.

This fix was boot tested on a Qualcomm Amberwing server (ACPI based) and
on a Qualcomm SA8775p Automotive Development Board (DT based). I also
verified that qcom-rng shows up in /proc/crypto on both systems.

Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
Reported-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Closes: https://lore.kernel.org/linux-arm-msm/20240828184019.GA21181@eaf/
Cc: stable@vger.kernel.org
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qcom-rng.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -196,7 +196,7 @@ static int qcom_rng_probe(struct platfor
 	if (IS_ERR(rng->clk))
 		return PTR_ERR(rng->clk);
 
-	rng->of_data = (struct qcom_rng_of_data *)of_device_get_match_data(&pdev->dev);
+	rng->of_data = (struct qcom_rng_of_data *)device_get_match_data(&pdev->dev);
 
 	qcom_rng_dev = rng;
 	ret = crypto_register_rng(&qcom_rng_alg);
@@ -247,7 +247,7 @@ static struct qcom_rng_of_data qcom_trng
 };
 
 static const struct acpi_device_id __maybe_unused qcom_rng_acpi_match[] = {
-	{ .id = "QCOM8160", .driver_data = 1 },
+	{ .id = "QCOM8160", .driver_data = (kernel_ulong_t)&qcom_prng_ee_of_data },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, qcom_rng_acpi_match);


