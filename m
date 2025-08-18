Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0237D3090C5;
	Mon, 18 Aug 2025 13:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524054; cv=none; b=OzfrUiPdwBDxUEcgbgfDWD/qti7QJWuEPEuj0XWChxxAKLrXDhaUdNAmNiQev1Cut11n6+cH4E3RVZFdGIHuKhEcOsC3yehJtj7JzgY0SNksZ5imWb2CpRqFntM9IiojdMdZ0gzrlIqNTkzvOVfhzsMC8G8eX5b4obM4SgUG564=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524054; c=relaxed/simple;
	bh=hhpNHVbwUwYECsZg58OM9ZUObS86nFEiTFskp9+tb/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5KA0+mYYd65BcTu9zjP6oOMD0wL1I+JIU1Qj/gkVxpAX7jB7fYl+cdwq7j9Crny+eiQpAEpCb+HQu698uFlIoJh02luUsR684xIGVsG3zwnVsiutLcYwgkntFpC9U2jprSHcCQc8eqy+wOUYnjnEc0VCAX0g3cZ887Dmt431X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzg1pm2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzg1pm2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324E2C4CEEB;
	Mon, 18 Aug 2025 13:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524053;
	bh=hhpNHVbwUwYECsZg58OM9ZUObS86nFEiTFskp9+tb/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzg1pm2+H2n92Gm1p5XPYiqoaTctiSqPxLyBIxp0QCVJ1+GvQxv6MT16V9uwt6sIA
	 lHYAC5Omhypriig/Nv7od/6o4A9iHw3TDFY5HxEhZFRZg9Mhobni5l+BonY8fUtOiU
	 YaYjie5WbL94EYYoddXjeIZqq8qNIcx0Jnxmf5pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 353/515] media: hi556: Fix reset GPIO timings
Date: Mon, 18 Aug 2025 14:45:39 +0200
Message-ID: <20250818124512.009596474@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index aed258211b8a..d3cc65b67855 100644
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



