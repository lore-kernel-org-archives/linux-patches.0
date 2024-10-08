Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1983D1DE2A5;
	Tue,  8 Oct 2024 12:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391697; cv=none; b=ShLAj27JsAG6oyRLGZkYzXMOMsK0xnKhlnTDfdmuHHuK76OibDElhYZAaQaem6eUNxnhpSgWDbpJO8UqqcqzscytedRb2i7S6ecFDw0IUj0nERmYoYnfG4p4rLdkOuHd6vdJfkEPcE5QseK0rOqLxiTAcyh31GE6MLX65j1zJc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391697; c=relaxed/simple;
	bh=eH15FFDkG2ObAYpzFZ4lh5M8/vZjcgehhJmmO7V4Kk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDxRJ4HYsatn9OliHOC7XApr8/eHO2G6ppYx5V4gO5S4clWK7rDQ9PYKvbXd7OJCOZeohzMDJYQ8GdcWAY42Ea0GpJWoNN3cKr3bvoX8ynLdmqM2pQsAHtTCFiZPbGIQPuaLQ60TLUMSuA5u8JHl3Ge+A+XCQhfpqSWsjYy6ae8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIXL9IGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIXL9IGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341C3C4CEC7;
	Tue,  8 Oct 2024 12:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391696;
	bh=eH15FFDkG2ObAYpzFZ4lh5M8/vZjcgehhJmmO7V4Kk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIXL9IGqeq580DpzIdu23iNhdYhrAW3f3/CrClW8nNb4j6MHdDTsZ6WOmFuvRAIYk
	 dp5/91f4QYr1PYpzBZow99eyOfohNUeQ8YO+UKb2r2JjXmMKm8gI9MpoM8EMfh50yr
	 WjUL5JXmGY9eotUCTWuQv+WA/CPdFIHnNVVKFSJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 195/558] power: reset: brcmstb: Do not go into infinite loop if reset fails
Date: Tue,  8 Oct 2024 14:03:45 +0200
Message-ID: <20241008115710.024529600@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit cf8c39b00e982fa506b16f9d76657838c09150cb ]

There may be other backup reset methods available, do not halt
here so that other reset methods can be tried.

Signed-off-by: Andrew Davis <afd@ti.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20240610142836.168603-5-afd@ti.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/brcmstb-reboot.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/power/reset/brcmstb-reboot.c b/drivers/power/reset/brcmstb-reboot.c
index 0f2944dc93551..a04713f191a11 100644
--- a/drivers/power/reset/brcmstb-reboot.c
+++ b/drivers/power/reset/brcmstb-reboot.c
@@ -62,9 +62,6 @@ static int brcmstb_restart_handler(struct notifier_block *this,
 		return NOTIFY_DONE;
 	}
 
-	while (1)
-		;
-
 	return NOTIFY_DONE;
 }
 
-- 
2.43.0



