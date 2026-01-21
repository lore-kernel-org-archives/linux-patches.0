Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF02F32D0FD;
	Wed, 21 Jan 2026 18:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019496; cv=none; b=c+rnU8y3XV0cqNuu6XvKm8VY+X+kaIYeR4noMBcxJlEppfD1JZd67fU5sT+/EOVHZTc5AqiSFlZ1tEIjDmcj7J1/hhPqxpsedyisVLQe7AkIOaEnkTlJbgglFNy92LFJeqjAhO7nzI4YIBzxvEGOfZLgG0y1kLm6nGG04jmNNSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019496; c=relaxed/simple;
	bh=ZkKSAHwv1GIxZZP+PQOxQOSkrB6XHrK7NCxo9NCiu8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/I8TcVS9KPjCg529CdFetz0+kCeOmTp402xFYf3wfDVIwt3+SUif0T6Sa+vkyO2h3LNLLu3N7cZspgSg+ldSkcx1MjgxL8Cun/EZMczgDHOvkZ6syuQyaVa28MdR6ucbfTlYrAPr73ZTEEW8YFQTuuzgUy8grgB34eILckrleg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vR2tBCKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vR2tBCKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5B0C4CEF1;
	Wed, 21 Jan 2026 18:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019495;
	bh=ZkKSAHwv1GIxZZP+PQOxQOSkrB6XHrK7NCxo9NCiu8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vR2tBCKFWj1/H9T7mMEC8ebuboirsWkg6MDy+RKFgUEcoPPs2ANxjNsLGuKPqGtHE
	 U/oR6kabGY62ZGgTOjVuT8x/0DoZw5pzcySNjkz4yglSCmi4Hi7QDdcfZc/I1hMR5e
	 ThEPPdSs0jnNRUgOakXf3YCHuTOqSJJyNXWU49eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 005/139] ASoC: codecs: wsa884x: fix codec initialisation
Date: Wed, 21 Jan 2026 19:14:13 +0100
Message-ID: <20260121181411.650446515@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 120f3e6ff76209ee2f62a64e5e7e9d70274df42b upstream.

The soundwire update_status() callback may be called multiple times with
the same ATTACHED status but initialisation should only be done when
transitioning from UNATTACHED to ATTACHED.

Fix the inverted hw_init flag which was set to false instead of true
after initialisation which defeats its purpose and may result in
repeated unnecessary initialisation.

Similarly, the initial state of the flag was also inverted so that the
codec would only be initialised and brought out of regmap cache only
mode if its status first transitions to UNATTACHED.

Fixes: aa21a7d4f68a ("ASoC: codecs: wsa884x: Add WSA884x family of speakers")
Cc: stable@vger.kernel.org	# 6.5
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260102111413.9605-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wsa884x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -1534,7 +1534,7 @@ static void wsa884x_init(struct wsa884x_
 
 	wsa884x_set_gain_parameters(wsa884x);
 
-	wsa884x->hw_init = false;
+	wsa884x->hw_init = true;
 }
 
 static int wsa884x_update_status(struct sdw_slave *slave,
@@ -2110,7 +2110,6 @@ static int wsa884x_probe(struct sdw_slav
 
 	/* Start in cache-only until device is enumerated */
 	regcache_cache_only(wsa884x->regmap, true);
-	wsa884x->hw_init = true;
 
 	if (IS_REACHABLE(CONFIG_HWMON)) {
 		struct device *hwmon;


