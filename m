Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B75417BF9;
	Sat, 12 Sep 2026 08:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202463; cv=none; b=UV3lSttKXZkKq6b/7OXpo22+Ok083obfLPz+KGoPArDs/vR6cOY/tkB+hudSpo9iGQjnMTte3iqt1811/exZofoVe3ilVQXVJJoUeHfc2MABSWIAhjTZZlQpMJL9Oqz+oGsdOziD3QEU+rWSrTQwDn/R2vTDrYos0/znhbHTLa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202463; c=relaxed/simple;
	bh=zlfinY0ivBYzEzEQYyvoBbZ45o9Ul1VPnpJQ8M+bnD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvMTd3PuLTyU3poRFEHHMyypmlkhuZ44NhkN7seZ1UJNLICA/l/O+Ybi/uRpFl7fqOfnNXnhTQ0H7kVnWXB+01VvmbspA2ET7FZHQHhBl0SgCBR7QPpnrxhLP3FOHnkL7iGtOHtDct9iiTzOA5c9FIZRczxOHJtFpObuY4VriuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXSxhHkS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXSxhHkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE981F000FF;
	Sat, 12 Sep 2026 08:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202462;
	bh=kE8iti82A994kndcKsNEBzwypWXg5uPJOmJ0wN8hJvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXSxhHkSVH0jqT6jGGAEQfgy+zVpR1erZ5VF4K+WX3kYoaqSa8wU1fvoeXkbDxchV
	 XjpQbR5lxE0HUJmw1XFiLfYMexZePdB39KCZaX61keI5rfYTr8z7ajQW2pXW7QxDqW
	 9kndUPTiLd8Y7DBA3z09L1umFMsaVvNh4ifmQLP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	surendra <kr494167@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1208/1815] thermal/drivers/spacemit: Validate clamped trip thresholds
Date: Sat, 12 Sep 2026 08:49:18 +0200
Message-ID: <20260912065717.366632309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: surendra <kr494167@gmail.com>

[ Upstream commit 68b78ad1e3533c1330dc9b7517947491c1a909c3 ]

k1_tsensor_set_trips() checks the requested trip temperatures before
converting them to the sensor register representation. Distinct
out-of-range temperatures can clamp to the same hardware value, leaving the
sensor with an invalid low/high threshold pair.

Validate the ordering after conversion and clamping.

Fixes: 296a977f2bac ("thermal/drivers/spacemit/k1: Add thermal sensor support")
Signed-off-by: surendra <kr494167@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260720103606.93924-1-kr494167@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/spacemit/k1_tsensor.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/spacemit/k1_tsensor.c b/drivers/thermal/spacemit/k1_tsensor.c
index 79222d233129d..a9eaedefdac3b 100644
--- a/drivers/thermal/spacemit/k1_tsensor.c
+++ b/drivers/thermal/spacemit/k1_tsensor.c
@@ -156,13 +156,12 @@ static int k1_tsensor_set_trips(struct thermal_zone_device *tz, int low, int hig
 	struct k1_tsensor *ts = ch->ts;
 	u32 val;
 
-	if (low >= high)
-		return -EINVAL;
-
 	low = clamp_val(low / 1000 + TEMPERATURE_OFFSET, TEMPERATURE_OFFSET,
 			FIELD_MAX(K1_TSENSOR_THRSH_LOW_MASK));
 	high = clamp_val(high / 1000 + TEMPERATURE_OFFSET, TEMPERATURE_OFFSET,
 			 FIELD_MAX(K1_TSENSOR_THRSH_HIGH_MASK));
+	if (low >= high)
+		return -EINVAL;
 
 	val = readl(ts->base + K1_TSENSOR_THRSH_REG(ch->id));
 
-- 
2.53.0



