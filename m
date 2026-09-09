Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08607563FBD;
	Wed,  9 Sep 2026 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962704; cv=none; b=bzHZqSR4yU1Dqf9SV2DCqtBQ5niDAFt3QJlHfAnkzhWO4s9Lmz2t01yWdIQTWJ2wp0nREJU+gJgcKK+llQYO41Yt8f6joH3a23h4pms0lpI7BCYjLKdk3C8qTqaNTIikqRiumTFaf3ri4tWqLvK9Qn6QwslXmfykeT/8wgZLqyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962704; c=relaxed/simple;
	bh=48hr0yBQEjBWCPjg6hSAt+W1balEBvgZv7tBocgft2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai2Y2vZvwxuRUCgLYMuAo8IgqHAcT8l8mo/ZW/eF7c9uy6UBfelEqKrFq/B2wtDVWJI1UeJqMjc8IF2INk/kWV/9Cp5cD/oSkEMcq35vdhKd1fRiT9QRAMizbbqFVZUiSAFTm/+Y7yhk9kmxmiYc0k0Fx4zkauoIAzVKsaUpuNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s41r8fAi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s41r8fAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F2E1F00A3A;
	Wed,  9 Sep 2026 14:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962702;
	bh=eNtq/zAMEidhxjx0ilmShoCxDn1DTh1lvEWaLqZbj3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s41r8fAigV73AqPRZZNMmN38DXU4qGmItFcj/opl6pdNk01qPGphHxRq0GM1oF508
	 NsR/zWRuns1UHahSXui2JX3Oq3fXBGjgH8pgGMteFyjGBhjQslrGW7AVubfoGeGnMo
	 CihbIOMeU5XMCM+DCmiiTIv9/zz2blrJv0enLsFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 381/556] media: mali-c55: Fix clock leak on reset deassert failure
Date: Wed,  9 Sep 2026 15:41:01 +0200
Message-ID: <20260909134244.080026938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit f499befeb668436b67bdb2b610b34db57732703f upstream.

__mali_c55_power_on() enables the clocks before deasserting the resets,
but bails out on a deassert failure without disabling them again. Both
callers treat a failed power-on as already cleaned up, so the clocks are
left enabled.

Disable them on the error path.

Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/arm/mali-c55/mali-c55-core.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-core.c
@@ -698,6 +698,8 @@ static int __mali_c55_power_on(struct ma
 					  mali_c55->resets);
 	if (ret) {
 		dev_err(mali_c55->dev, "failed to deassert resets\n");
+		clk_bulk_disable_unprepare(ARRAY_SIZE(mali_c55->clks),
+					   mali_c55->clks);
 		return ret;
 	}
 


