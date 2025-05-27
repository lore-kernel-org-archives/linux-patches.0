Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B5642A9B;
	Tue, 27 May 2025 17:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367709; cv=none; b=Jt7gmw4wTmga3sDz+OHcz8MoelUjksDGu7Ri4tA6DjjN9/OnIRLbbtxuXXHIg9L/93pe2IaqTRaMkE7OM9LZF8L3WX1G07/isZvx6r4C1vYQM/OlLk2dTYJDOvv78hCM0Y7F2n1yWJGiiODfEOOGc+nmTGK5LihdPj5HqUedKXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367709; c=relaxed/simple;
	bh=F8X8eyFy0eonZ86zPC1nrC0fthwmQJ9Mw5LJZ17FOo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7Qdki+VF0REOaMMaEf8VyvCeS/Tnl4ran8Tjgth4oX12dCVjGMO0WOCMkbT3TpmGaXVxAojJOTQMHSiuqicLahzevTXbnrQjona9vrm8aO/q8MrZDqVLjuFSevxBCzczKhN8adoSUpPX5NxWV98hkkExy4gaXnDS9Aq08vYDJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwLaXe21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwLaXe21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E41C4CEE9;
	Tue, 27 May 2025 17:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367709;
	bh=F8X8eyFy0eonZ86zPC1nrC0fthwmQJ9Mw5LJZ17FOo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwLaXe21VIgm1nDYFQ1xd1HZCoCuGFy2UG20Hv8QBhPcJfIBWkEephYiaJL7FHmYp
	 AXpodKg6UrwkMJYoaDyrY76Mlp9+3ciuvkfoQKEBbLIPJTsXzjI+SlIZwKrBqznpdw
	 Wiew06wmqnP0JLf+yETfrx315oty1kmhTnrDPkgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 473/783] soundwire: amd: change the soundwire wake enable/disable sequence
Date: Tue, 27 May 2025 18:24:30 +0200
Message-ID: <20250527162532.390776188@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit dcc48a73eae7f791b1a6856ea1bcc4079282c88d ]

During runtime suspend scenario, SoundWire wake should be enabled and
during system level suspend scenario SoundWire wake should be disabled.

Implement the SoundWire wake enable/disable sequence as per design flow
for SoundWire poweroff mode.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20250207065841.4718-2-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index 5a54b10daf77a..9d80623787247 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -1139,6 +1139,7 @@ static int __maybe_unused amd_suspend(struct device *dev)
 		amd_sdw_wake_enable(amd_manager, false);
 		return amd_sdw_clock_stop(amd_manager);
 	} else if (amd_manager->power_mode_mask & AMD_SDW_POWER_OFF_MODE) {
+		amd_sdw_wake_enable(amd_manager, false);
 		/*
 		 * As per hardware programming sequence on AMD platforms,
 		 * clock stop should be invoked first before powering-off
@@ -1166,6 +1167,7 @@ static int __maybe_unused amd_suspend_runtime(struct device *dev)
 		amd_sdw_wake_enable(amd_manager, true);
 		return amd_sdw_clock_stop(amd_manager);
 	} else if (amd_manager->power_mode_mask & AMD_SDW_POWER_OFF_MODE) {
+		amd_sdw_wake_enable(amd_manager, true);
 		ret = amd_sdw_clock_stop(amd_manager);
 		if (ret)
 			return ret;
-- 
2.39.5



