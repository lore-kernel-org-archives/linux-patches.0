Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E997C31E115;
	Mon, 18 Aug 2025 13:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522479; cv=none; b=ljYHVXZYG6P77QGjoA/ViXyWPqXkxj0vg5FXlIgPd5jwxByuT7iw0rEiCCdCafY+kE7zJFj3xDTHWoqUeURqTQ0cjMj+++JlzWRfgcF50o56mnbl1EBH39eaaB27WnSL9XdCadq+e2TFoteL646iZHYnms5FfahalDVNVFXDoeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522479; c=relaxed/simple;
	bh=R6Z6JdZZPBW5IMg1CC3DVqp5eLMuT9BxKsMucs/5ZDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpzfUu7qzyXlGHWZXhtTvAFdJ2eBWkip88bc2d9mYZnBxIER5sdRrg2FJ0p/m0PxZZHCD93304YEts2DvcfJcjE3akkOLJZnAfBwAVZoUWfkPbQDWbNW1veGaa4mmvfNrqWEc+ga2SWrqhuH0rzgkKTTz0IGc/ppWICLjyze+Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmBiH6Kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmBiH6Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4CDC4CEEB;
	Mon, 18 Aug 2025 13:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522478;
	bh=R6Z6JdZZPBW5IMg1CC3DVqp5eLMuT9BxKsMucs/5ZDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmBiH6KpJlem3zRw00LBzwvQAOp49w80ymOLYxF2dnpyR/ClVTKSm/8zlFTxX7qLb
	 tSalVj1Q8Bxqf7Y6l9TZOpySwBVa48LKXN95++YkxBtBT0XCPjiqly60pqeY3dLWea
	 zQbjbBbNpEO2/XNYW+CL2rFiEj0l1atQiGPL9o9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/444] media: hi556: Fix reset GPIO timings
Date: Mon, 18 Aug 2025 14:45:21 +0200
Message-ID: <20250818124500.019315721@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 99f2211a9d89fe34b3fa847fd7a4475171406cd0 ]

probe() requests the reset GPIO to be set to high when getting it.
Immeditately after this hi556_resume() is called and sets the GPIO low.

If the GPIO was low before requesting it this will result in the GPIO
only very briefly spiking high and the sensor not being properly reset.
The same problem also happens on back to back runtime suspend + resume.

Fix this by adding a sleep of 2 ms in hi556_resume() before setting
the GPIO low (if there is a reset GPIO).

The final sleep is kept unconditional, because if there is e.g. no reset
GPIO but a controllable clock then the sensor also needs some time after
enabling the clock.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/hi556.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/hi556.c b/drivers/media/i2c/hi556.c
index 0e89aff9c664..3c84cf07275f 100644
--- a/drivers/media/i2c/hi556.c
+++ b/drivers/media/i2c/hi556.c
@@ -1321,7 +1321,12 @@ static int hi556_resume(struct device *dev)
 		return ret;
 	}
 
-	gpiod_set_value_cansleep(hi556->reset_gpio, 0);
+	if (hi556->reset_gpio) {
+		/* Assert reset for at least 2ms on back to back off-on */
+		usleep_range(2000, 2200);
+		gpiod_set_value_cansleep(hi556->reset_gpio, 0);
+	}
+
 	usleep_range(5000, 5500);
 	return 0;
 }
-- 
2.39.5



