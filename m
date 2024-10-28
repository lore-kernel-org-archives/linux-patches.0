Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D15F15B10D;
	Mon, 28 Oct 2024 06:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097813; cv=none; b=fkt/a8YJBwzKSPXsybVuzJdJY6SwDLKl/NVVIeflmBV+0Ns4GLyk5BfMv6bdAK2FHin5LnxPQ2SwVwWd4s+j4ihTJGbemIyBEwW7yk3NZGMdQHDALWZtGP1gtvQRrUtwUdSYqoq5VDcYrPLvu5mdAicuB9v0kYEyaGsfeCGFoeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097813; c=relaxed/simple;
	bh=NcG+Qg9OPmMi68JcGfhd1WHCRE05xNbPNhTgpu8zvLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftEFmeocGPGA0HiQey33kWlMMsIuluKmwm/kSa3EIDWt6P9Hks8p5QVIhCifdXL8ExTOcXxuwlMovuo2kYiBR/XD6HYN2Snb1h2iG7Bm5u5CjmnpbP5RiW0+o6jm9lkJ8pahElS5YVjCATIWUhaelju4Oo16pHc397ycg7NvvBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1v2dj+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1v2dj+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B113FC4CEC3;
	Mon, 28 Oct 2024 06:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097813;
	bh=NcG+Qg9OPmMi68JcGfhd1WHCRE05xNbPNhTgpu8zvLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1v2dj+fAD3pRdCjmCqz6QGQSAXGn5nWjLPL5qLOUhTlK92DGPJNZZJKHiHc3LmWO
	 dq1uBBHg3ZqK06e3Bl/GVLf6uceK0sNN4LilLnwRGzjRdFspgkWlj5AbevQy5fyMKN
	 +965dWEe3cQLBQFQJlNtP6g9lGvARI8pkOJv+FQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rashleigh <peter@rashleigh.ca>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/208] net: dsa: mv88e6xxx: Fix error when setting port policy on mv88e6393x
Date: Mon, 28 Oct 2024 07:25:21 +0100
Message-ID: <20241028062310.106695887@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Rashleigh <peter@rashleigh.ca>

[ Upstream commit 12bc14949c4a7272b509af0f1022a0deeb215fd8 ]

mv88e6393x_port_set_policy doesn't correctly shift the ptr value when
converting the policy format between the old and new styles, so the
target register ends up with the ptr being written over the data bits.

Shift the pointer to align with the format expected by
mv88e6393x_port_policy_write().

Fixes: 6584b26020fc ("net: dsa: mv88e6xxx: implement .port_set_policy for Amethyst")
Signed-off-by: Peter Rashleigh <peter@rashleigh.ca>
Reviewed-by: Simon Horman <horms@kernel.org>
Message-ID: <20241016040822.3917-1-peter@rashleigh.ca>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 5394a8cf7bf1d..04053fdc6489a 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1713,6 +1713,7 @@ int mv88e6393x_port_set_policy(struct mv88e6xxx_chip *chip, int port,
 	ptr = shift / 8;
 	shift %= 8;
 	mask >>= ptr * 8;
+	ptr <<= 8;
 
 	err = mv88e6393x_port_policy_read(chip, port, ptr, &reg);
 	if (err)
-- 
2.43.0



