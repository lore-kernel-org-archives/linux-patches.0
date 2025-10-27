Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386AD32A3D7;
	Mon, 27 Oct 2025 19:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593443; cv=none; b=DawCbdzUENFukrzcxM6t/nBFJ7Vb1xjoTftks0S43uPqJ0RFCfkfnyufYIrbEFP08jnaeM1IRiz/oJjzk3cc35yXfWT1sxuV4yD55tTpxwWx+m1LOHBfeG3Cqk923K9jX8hXo0DZoHkItRJMbvgH429Ka1aNqJr62VqJqdMTZog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593443; c=relaxed/simple;
	bh=QPGFrIvuj+WlZN8A1i0ODoWlczDJ8hBmxowwqPAChL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsVEoD4EHZswxWmR42cJJK34cCjT6Xrpwrikml+WBl8P0IDQ7jHnYPpLmF9AdTxIVTJyIND29zF51OcuPMJRS7s7p03OcuijDwmqzZziOOBoinb7AeqwOtlIiSa/lpqRaBqrYD3bOL3uUj1o1wXWs3oyrleqo6QuAv1S6Ji2lNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEue1QG+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEue1QG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC3CC113D0;
	Mon, 27 Oct 2025 19:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593443;
	bh=QPGFrIvuj+WlZN8A1i0ODoWlczDJ8hBmxowwqPAChL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEue1QG+OAe5RUOY2ojfJ5FiiATy566bRe0yO+rNOKV4OGrWLMMtrZaJ7iYpix6SH
	 dGSj/7DTdUJ+C/FLQZDNZl42nko1mVGCU5JLQm1nkIKQzdrrn0vyapihaH8mHIM/o/
	 0ND1UU1nquWlQaA+GaWaoFl5y1xQwAmTv22jyDSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Karanja <karanja99erick@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 135/184] hwmon: (pmbus/isl68137) Fix child node reference leak on early return
Date: Mon, 27 Oct 2025 19:36:57 +0100
Message-ID: <20251027183518.581183953@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erick Karanja <karanja99erick@gmail.com>

[ Upstream commit 57f6f47920ef2f598c46d0a04bd9c8984c98e6df ]

In the case of an early return, the reference to the child node needs
to be released.

Use for_each_child_of_node_scoped to fix the issue.

Fixes: 3996187f80a0e ("hwmon: (pmbus/isl68137) add support for voltage divider on Vout")
Signed-off-by: Erick Karanja <karanja99erick@gmail.com>
Link: https://lore.kernel.org/r/20251012181249.359401-1-karanja99erick@gmail.com
[groeck: Updated subject/description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/isl68137.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/hwmon/pmbus/isl68137.c b/drivers/hwmon/pmbus/isl68137.c
index c52c55d2e7f48..0c6b31ee755b9 100644
--- a/drivers/hwmon/pmbus/isl68137.c
+++ b/drivers/hwmon/pmbus/isl68137.c
@@ -334,10 +334,9 @@ static int isl68137_probe_from_dt(struct device *dev,
 				  struct isl68137_data *data)
 {
 	const struct device_node *np = dev->of_node;
-	struct device_node *child;
 	int err;
 
-	for_each_child_of_node(np, child) {
+	for_each_child_of_node_scoped(np, child) {
 		if (strcmp(child->name, "channel"))
 			continue;
 
-- 
2.51.0



