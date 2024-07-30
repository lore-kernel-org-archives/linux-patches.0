Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A231898EC;
	Tue, 30 Jul 2024 17:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359240; cv=none; b=HyXfIlnbBItVq+x+lePU8USq0Xl2p/aAv7TPoJLNdCRZxyuDW5wUa62FAbhjONGCZPGhaA0/tF6gBWXBXDmefL4fjKvZgRehSO2c/TxzVDCheGZhtg8QvlTrcdyBmye6x0VYHUiTj++zff4tmDsbLcyPpWGvqOm3Li+68VqX84Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359240; c=relaxed/simple;
	bh=FOvgCYyturHe09qju+uNHSuQlyb9S3lW4NfmsBb15Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6PAvU6PfUKeTE1KTXuxAjU0Kf4mKaFMZrQKAT9hRxjY4j2bigdmSF97eII9dKbVJWBsVIleVYKrPvF2ZGWS9V1YcaVXY7MGaqnGsZv5M4iroQszJ/rGSpG3vsufznvg+epFTR5hBMWEmdXviDu4D5EZmgMX8QRIoiuT0FCHsaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meI6rBXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meI6rBXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2984AC32782;
	Tue, 30 Jul 2024 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359239;
	bh=FOvgCYyturHe09qju+uNHSuQlyb9S3lW4NfmsBb15Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meI6rBXCU/FS6QBFLPBzukn3mwUtqkpWw3Q+hXXUA682C1p8IWt2EBx1XJxY/Oi2q
	 EQn1H7GuIqR7IHWoJ+EVjuAwLU4P89EcuiHdmQ3xPBtbdVzD97p/MeRgL/iZsGXo0Q
	 GCb6pFYHtuarv+f2CbtSvD5qrbOO5pj2j6n+OxBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.6 452/568] devres: Fix devm_krealloc() wasting memory
Date: Tue, 30 Jul 2024 17:49:19 +0200
Message-ID: <20240730151657.678699812@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit c884e3249f753dcef7a2b2023541ac1dc46b318e upstream.

Driver API devm_krealloc() calls alloc_dr() with wrong argument
@total_new_size, so causes more memory to be allocated than required
fix this memory waste by using @new_size as the argument for alloc_dr().

Fixes: f82485722e5d ("devres: provide devm_krealloc()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-2-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/devres.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -896,9 +896,12 @@ void *devm_krealloc(struct device *dev,
 	/*
 	 * Otherwise: allocate new, larger chunk. We need to allocate before
 	 * taking the lock as most probably the caller uses GFP_KERNEL.
+	 * alloc_dr() will call check_dr_size() to reserve extra memory
+	 * for struct devres automatically, so size @new_size user request
+	 * is delivered to it directly as devm_kmalloc() does.
 	 */
 	new_dr = alloc_dr(devm_kmalloc_release,
-			  total_new_size, gfp, dev_to_node(dev));
+			  new_size, gfp, dev_to_node(dev));
 	if (!new_dr)
 		return NULL;
 


