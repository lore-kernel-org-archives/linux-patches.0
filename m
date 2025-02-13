Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64E926B08E;
	Thu, 13 Feb 2025 14:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458146; cv=none; b=XlJXavYjGEE/GV6xP1e87oMLhYbCzpWc0/VUETmWDvd7GEAHkXASLXMxkkbrR5MN/HUwoUgoWyHWDubcUbyIh+PSWasfLBgT/CYAfFzALPFypRh1Rf8EZVIinm8QOxhTU/FLQjzsTm3J+5GZhPtQ4bp4cqPNZesoM4iWA8DzI2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458146; c=relaxed/simple;
	bh=1G2lTAcxDHa+iBuKESA0yO56ODDvRBxlrd3Vpj5JEQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNQ+HurQ2+H7bQUL09p/dtUvZSQtGsElCpvX7/wg0WAGBmbyJw5UA6mE/b4ZMy6TwF39rNvnDresB/TRdvEZzGV56GPK/2unIIzHQpzZMDjxtmy0PsEyWdMAXavkXCwN2hl3SG6PAxC0sOIhYb8GmDPXVfDN003Mb8lFm4JMeEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwZ6Kc0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwZ6Kc0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6C9C4CED1;
	Thu, 13 Feb 2025 14:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458146;
	bh=1G2lTAcxDHa+iBuKESA0yO56ODDvRBxlrd3Vpj5JEQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwZ6Kc0IGOzpy2whec4MLp1GYP8Fnt5E9ZZhnQ7JO5X1CdKRNOJ4o8exJWugkGpjz
	 Lp36qJXYaaI2RhceXt6EoAkOzA7cuiqZ3hnbsHmJ7B4ehYOd/nNh+IjuzO5xusxcdk
	 Rr3BgX5TVu8rQ5AVcWzFfAHo6TfmimxlyhoRDFWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 316/422] soc: samsung: exynos-pmu: Fix uninitialized ret in tensor_set_bits_atomic()
Date: Thu, 13 Feb 2025 15:27:45 +0100
Message-ID: <20250213142448.745023627@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


