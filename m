Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451C91DFE38;
	Wed,  6 Nov 2024 12:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896540; cv=none; b=FOtea8HH8m+RNAcU9lk35fpClSgwviW0eELbxoMMUCVq4mT1yppuC5Tm+KCuPVnQmTYinNxIPGbeip0hIhxrWxe7F08MFpz0s/xdvpLdoosc1IQxEf8MczdjB795Om18Jmp1dVQLM9iZoAO+Og+fB9AoIQ1nu+VK/o/DkDIMjlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896540; c=relaxed/simple;
	bh=16Y44MslnunBM6i514PsS2eWfQJJIVDwbaqtMCiQBYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bu58cspEgbbgq+5f/RfmJP+4wrxLL0lvJTzL43T7bbIqAYhKuU8zuB4cru7RYKNJgIg3NkJ1D221QIR0vh1a24lu9mpC3AM9uIYzc1DdDAEhs+OZefaFzgcYH3YU/PUWOYbSU/oESvaoZgnMcP+6EaGZTED9ooGlKjxnM3Eq0bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOXvRZWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOXvRZWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE16C4CECD;
	Wed,  6 Nov 2024 12:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896540;
	bh=16Y44MslnunBM6i514PsS2eWfQJJIVDwbaqtMCiQBYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOXvRZWGcBR4AFabl6vz/rgaNWSHQLNEaapDuOrTPebEg1KlyFn8ZanVumvmeDUxD
	 EmrFWFgB/k+o+58J44I0OIzjqcvi38ObrYS3frrmYbKdkUmRV6er2ySvLmNh35FkNp
	 OWsd2V+vhDava3xI1QS9xr6j/wr+iwiJJ7xCMz2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 200/245] gpiolib: fix debugfs newline separators
Date: Wed,  6 Nov 2024 13:04:13 +0100
Message-ID: <20241106120324.167325739@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 3e8b7238b427e05498034c240451af5f5495afda ]

The gpiolib debugfs interface exports a list of all gpio chips in a
system and the state of their pins.

The gpio chip sections are supposed to be separated by a newline
character, but a long-standing bug prevents the separator from
being included when output is generated in multiple sessions, making the
output inconsistent and hard to read.

Make sure to only suppress the newline separator at the beginning of the
file as intended.

Fixes: f9c4a31f6150 ("gpiolib: Use seq_file's iterator interface")
Cc: stable@vger.kernel.org	# 3.7
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241028125000.24051-2-johan+linaro@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 148bcfbf98e02..1f522499c6fc5 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -4834,6 +4834,8 @@ static void *gpiolib_seq_start(struct seq_file *s, loff_t *pos)
 		return NULL;
 
 	s->private = priv;
+	if (*pos > 0)
+		priv->newline = true;
 	priv->idx = srcu_read_lock(&gpio_devices_srcu);
 
 	list_for_each_entry_srcu(gdev, &gpio_devices, list,
-- 
2.43.0



