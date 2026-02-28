Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7194347FFB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302695; cv=none; b=Ilhnx7jBhnr5KSFm74aTzGxAz3OZJX3QyXjJdrCg36xAPT+r8dam0vaUBOmFvNsHsSeFuRLCllMcQa74cQ4z63ATVWk/mPvN8RH+F3As6+V7Nn4dw8tEu5YeKGkfMafNbDbS9WmrHk86r65BQKFRC54+kQbI6JZbUmz4sF/2WFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302695; c=relaxed/simple;
	bh=oKBMiHrawW1UMfgg/06+sM/jsBW0iBtZ6f/ipsXtVwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USUqXtrA+knkFza4Vkyam1+DDJ3HX4KMLgoAXBOXHvmCe22IvKgPp8DcWRyxo70ICegTB0X7mjZoDNa6md/GzUxB1NqPffissPngaTQcBrH//VvflPnunFwWBLa/lkX+oihPjolmgv2Kb9vboATiBkHlMXTqXUuX7hkfseQbKB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kyhboE+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kyhboE+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DFDC19423;
	Sat, 28 Feb 2026 18:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302695;
	bh=oKBMiHrawW1UMfgg/06+sM/jsBW0iBtZ6f/ipsXtVwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyhboE+dQHm0Ndc46EDzcFXm/3cCSqTzZ46+PwbSXEZs0Bw6a2DwFeBWVVT/3Vuzw
	 IEYwkhA+ExkKOnp1TbyO6ld2oNKWYICpi3DEjBp3xuJzbxu+XHznWm72INkTvLCYtX
	 5QTtSp8u0A18ICFE8a28iLHfzVAl1KI9KzOLX1Aw8ojlIoqmNFx7ABb+WjL1NAiGq+
	 ko236fAPGxamSIAaGfeOL3DCZYjH34SyyXaJdPwXiF7c56dlRgDt/beBR9jc7lIveH
	 NwiIAskQIrnmim24lPBopV2vcpJdWOHXyuyAEuUvD8rrVweMNIzQ0bj0N3VrK+1Ho1
	 6S63xlbvzn+Lw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/147] regulator: core: Respect off_on_delay at startup
Date: Sat, 28 Feb 2026 13:15:58 -0500
Message-ID: <20260228181736.1605592-50-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit a5ccccb3ec0b052804d03df90c0d08689be54170 ]

We currently do not respect off_on_delay the first time we turn on a
regulator.  This is problematic since the regulator could have been
turned off by the bootloader, or it could it have been turned off during
the probe of the regulator driver (such as when regulator-fixed requests
the enable GPIO), either of which could potentially have happened less
than off_on_delay microseconds ago before the first time a client
requests for the regulator to be turned on.

We can't know exactly when the regulator was turned off, but initialise
off_on_delay to the current time when registering the regulator, so that
we guarantee that we respect the off_on_delay in all cases.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Link: https://lore.kernel.org/r/20210422083044.11479-1-vincent.whitchurch@axis.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 86a8eeb0e913 ("regulator: core: move supply check earlier in set_machine_constraints()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0e2129be02265..38c01516d2ed0 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1529,6 +1529,8 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 
 		if (rdev->constraints->always_on)
 			rdev->use_count++;
+	} else if (rdev->desc->off_on_delay) {
+		rdev->last_off_jiffy = jiffies;
 	}
 
 	print_constraints(rdev);
-- 
2.51.0

