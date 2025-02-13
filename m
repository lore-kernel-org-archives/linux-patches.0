Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D8926B0A5;
	Thu, 13 Feb 2025 15:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459740; cv=none; b=jaeP09UqhDbL/Ow84S0aFY7cjkdvTU5wtaNYnvLue+XsB53Qn8zSS4LhTxcgGoDOn72gQ9h7YB5DTPa5HSKaYxVagTe+wtvuVqxYBYFLKcSg0k9umvftFPzV7N1qN4Mm5wbLObG7po8XTsTTA1sRfbMjumiflG0YSF8e+lXnsBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459740; c=relaxed/simple;
	bh=vhTcRMs7pwupKKG0qiWww/rAoCcTilkGJ7yj6uNX0q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENl/rNRTNlbLv0TTWKpwrXQTyupChuJuIxl83Y3QTUNnFHwxKFb6Do1obcVbAAVook8pN+DKYEoyg6wY8GKFYxPFpLKDdflPoQ5fnfxsDs3diBtk6zlLJWfKq/5NnrIx5UOSTQzhebgRFETk4XxvVK/sGXmpK0qwIBhK9cyO2MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=loXELZd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="loXELZd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CEAC4CED1;
	Thu, 13 Feb 2025 15:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459740;
	bh=vhTcRMs7pwupKKG0qiWww/rAoCcTilkGJ7yj6uNX0q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=loXELZd90w+LhpY4oBp88L+ihfBjDWmRNEfDwdAQ0/qasX+Jk+QrtY1+lWJsEIBeu
	 1qy320BNqD6lNSY2JmrIqy/UPL5yuqxlBWju0n5ICdMx7mMzExn/OHfLrOIJ1tiOyK
	 Zt+oglUvdt9h2q5lJMsw55bXz+RPVI1fdO3bxTmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.13 351/443] soc: samsung: exynos-pmu: Fix uninitialized ret in tensor_set_bits_atomic()
Date: Thu, 13 Feb 2025 15:28:36 +0100
Message-ID: <20250213142454.163072165@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit eca836dfd8386b32f1aae60f8e323218ac6a0b75 upstream.

If tensor_set_bits_atomic() is called with a mask of 0 the function will
just iterate over its bit, not perform any updates and return stack
value of 'ret'.

Also reported by smatch:

  drivers/soc/samsung/exynos-pmu.c:129 tensor_set_bits_atomic() error: uninitialized symbol 'ret'.

Fixes: 0b7c6075022c ("soc: samsung: exynos-pmu: Add regmap support for SoCs that protect PMU regs")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250104135605.109209-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/samsung/exynos-pmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -126,7 +126,7 @@ static int tensor_set_bits_atomic(void *
 		if (ret)
 			return ret;
 	}
-	return ret;
+	return 0;
 }
 
 static bool tensor_is_atomic(unsigned int reg)


