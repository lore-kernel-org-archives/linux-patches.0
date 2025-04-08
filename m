Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF63224AEB;
	Tue,  8 Apr 2025 12:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115057; cv=none; b=nADqXiV6Slc5kjLqw9bQuheogcTgaKQl+PcqQoIZyo7UqGUQkvB6VN80DD0nki1qHp/Qi3RYQC1zcw1dwLudqA11/ySFpaotFFIAG6R6w1z62briZc9O1r6n1yPK4ytk+RlDXVtFhZ7LDx0G+OmbTdUlRxjAJDXm+VLLtKHFzl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115057; c=relaxed/simple;
	bh=A06r6HIQgYAn7B20NmV6gmW30NAcGpw5hjfDw9kguGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J4glcrd/+XddiONGrfYfmWp0Gj1fyY1ctevIviKGs9YCR+Y27l2uxQFxYv6Kew+eEBQiAx5IIlP5j57ftaYj05iAubUrEnEOrbW5WC1UHoHRR0T6CW3VY6ceUdSjcxyqg9xgBnYrT+nMh1BisebckcnYSQGJQMZ8p4z/OXxkmXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F60518lb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F60518lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C03C4CEE5;
	Tue,  8 Apr 2025 12:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115057;
	bh=A06r6HIQgYAn7B20NmV6gmW30NAcGpw5hjfDw9kguGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F60518lbqS6pm1XFpUHXxP71QlIM5pby+zAk3rxJKAoNnyY412TPAWRhGKko0CHcb
	 qhjjkpDE0BtFyQHZ4DAkibz7ndmvmUuFCjLLEfXV24Tcc+m8o7cupIlHTgB+b9L7e0
	 czDWdr9vePV+Mv1zVFTfIIt4K/Ed1ScelUcBY6Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 332/499] ASoC: codecs: wsa884x: report temps to hwmon in millidegree of Celsius
Date: Tue,  8 Apr 2025 12:49:04 +0200
Message-ID: <20250408104859.506851565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit d776f016d24816f15033169dcd081f077b6c10f4 ]

Temperatures are reported in units of Celsius however hwmon expects
values to be in millidegree of Celsius. Userspace tools observe values
close to zero and report it as "Not available" or incorrect values like
0C or 1C. Add a simple conversion to fix that.

Before the change:

wsa884x-virtual-0
Adapter: Virtual device
temp1:         +0.0°C
--
wsa884x-virtual-0
Adapter: Virtual device
temp1:         +0.0°C

Also reported as N/A before first amplifier power on.

After this change and initial wsa884x power on:

wsa884x-virtual-0
Adapter: Virtual device
temp1:        +39.0°C
--
wsa884x-virtual-0
Adapter: Virtual device
temp1:        +37.0°C

Tested on sm8550 only.

Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20250221044024.1207921-1-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa884x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wsa884x.c b/sound/soc/codecs/wsa884x.c
index 86df5152c547b..560a2c04b6955 100644
--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -1875,7 +1875,7 @@ static int wsa884x_get_temp(struct wsa884x_priv *wsa884x, long *temp)
 		 * Reading temperature is possible only when Power Amplifier is
 		 * off. Report last cached data.
 		 */
-		*temp = wsa884x->temperature;
+		*temp = wsa884x->temperature * 1000;
 		return 0;
 	}
 
@@ -1934,7 +1934,7 @@ static int wsa884x_get_temp(struct wsa884x_priv *wsa884x, long *temp)
 	if ((val > WSA884X_LOW_TEMP_THRESHOLD) &&
 	    (val < WSA884X_HIGH_TEMP_THRESHOLD)) {
 		wsa884x->temperature = val;
-		*temp = val;
+		*temp = val * 1000;
 		ret = 0;
 	} else {
 		ret = -EAGAIN;
-- 
2.39.5



