Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1EE46EF73;
	Tue, 21 Jul 2026 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656645; cv=none; b=BraUpu5SjUdY6mGglce0B4NUugp7u3LRU65KNFwfc3Jy/igyeAFgcvUrd2ZwyeEjyOiTr85Qv6fn3idoQtJu3E9LXc9AemtFx+A6NdU5GSs4OnF1E2gRo/LwIuhU/kSd3vrMPc5Hj1Hg+SCCiV8hs9mi/Ga4Nu7OyXRBRk+Fa+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656645; c=relaxed/simple;
	bh=4U4Q+NOeD+u9hIY4zeB5QJ6OVErh56BWnJTUcA12kRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szIrll6l/oQb6n0YhU7MQGY2bAYZ5KpTwBR3DGtINbhIx0M3fDkSINq1APRmnL0YtR0bDNGwlmAvwyX28X3Vghxw+2AI3HN4Nm6Qe2pNYU5i4nIccDKKgPko9LGnJJmmlrNLY+o9P893T5ANOGnPqpAW4ElDfwTyUPoPAEQxVwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZvx8AH3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZvx8AH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D58D1F000E9;
	Tue, 21 Jul 2026 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656644;
	bh=gn75nDTwmqcTQjJwRHpB9XRYTqhyYwOeAXR+8ecD0eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZvx8AH36MVZhGrQMRmHm59vpsQmd+pksCb0Blc2Q4xD19mYDyiYSkR9p1wQwjFLF
	 JJF0cOpHe4L8Xeb4mYU89Axrn9EgyjPWtKF5OebhMHErlFUHoRphw433+OI/+0OC6u
	 dfrbJaxASAQ/XsNq0zjgoapQc8USxkDEFKPvs3hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0463/1611] ASoC: cs35l56: Fix possible uninitialized value in cs35l56_spi_system_reset()
Date: Tue, 21 Jul 2026 17:09:39 +0200
Message-ID: <20260721152525.728272011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 007699d278a655871b07d45a1268761260d03124 ]

In cs35l56_spi_system_reset() initialize val to zero before using it in
the read_poll_timeout(). This prevents testing an uninitialized value if
the regmap_read_bypassed() returns an error.

Read errors are intentionally ignored during this loop because the
device is resetting (though SPI can't really detect that so shouldn't
fail because of that, it's safer to ignore errors and keep polling).
Because of this, val must be initialized to something in case the first
read fails. The polling loop is looking for a non-zero value, so
initializing val to 0 will ensure that the loop continues until a valid
state is read from the device or it times out.

Fixes: 769c1b79295c ("ASoC: cs35l56: Prevent races when soft-resetting using SPI control")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260611132221.1100497-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-shared.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index a13e8eaf277d40..646bb4fbca0250 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -515,6 +515,7 @@ static void cs35l56_spi_system_reset(struct cs35l56_base *cs35l56_base)
 	 * The regmap must remain in cache-only until the chip has
 	 * booted, so use a bypassed read.
 	 */
+	val = 0;
 	ret = read_poll_timeout(regmap_read_bypassed, read_ret,
 				(val > 0) && (val < 0xffffffff),
 				CS35L56_HALO_STATE_POLL_US,
-- 
2.53.0



