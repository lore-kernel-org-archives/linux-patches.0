Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27234377A9A;
	Sat, 12 Sep 2026 09:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203670; cv=none; b=si5IgwGufnI3PQDS9kquDCTdXmPGO+IhVcXTy2Q1+jMi5YCUHR+CBNSnvBW/ApV3EW+E9ScQXG1wQsmpyQiKrtbrrTq6Pi3tScxoaMGfxoTIopO47nakwqhokJDefrTtDjaGxVWbF5bhgWmx9iN+O/yglOArs+qv2ilgAhtAcTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203670; c=relaxed/simple;
	bh=wyPjnl/+4yFSXkAe2Xfdnray+KKuQI6b++x8dDq2tJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlGri1AiwXPxrp6TXk9+LQNWFlcOFGO9HaIIwgqXpq+ZlnldYu79YgHxuZcQOqX8uX4wRUPDOMxxGE+SUajEbLHdHAw2Er/2zgthWdtUBkYX2GvMc/aHxn6XEh9azKjgT+D8pgAMMatmWFrCcuncOZk6EdzwtccEb6kBLx/stok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMXJ52Xq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMXJ52Xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0F81F000FF;
	Sat, 12 Sep 2026 09:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203669;
	bh=f+nufE29MUfd0FB1eLK/rvLQhvZl3Y0YP2+5SpnsB8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMXJ52XqbzqKkCz7q8VImnrByzI6MBqqc20AYKUSn537KaIQ0gYEXY9xXHqCCNtpp
	 SEtE6k2QBJki4gLntBVK4r3R95UhdQWAlgF27kOMItfveofAq3FO9JnRlj4jQe+ncM
	 8rBG+xH6NZcDR8T4BWsT3Nd2LxEZSC/lbPOX08BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1454/1815] HID: tmff: Use 64-bit arithmetic for force feedback scaling
Date: Sat, 12 Sep 2026 08:53:24 +0200
Message-ID: <20260912065723.146621803@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 463f7cc26ce3ccc8fb76d6194f83214be7105e2f ]

The logical minimum and maximum values come from the HID report
descriptor and cover the full signed 32-bit range.  Subtracting them in
an int can overflow before the force feedback value is scaled.  The
subsequent multiplication can overflow as well, producing an incorrect
value despite the final range checks.

Use 64-bit intermediates for both scaling helpers, as done by commit
48d1677779ad ("HID: pidff: Fix integer overflow in pidff_rescale") for
the same arithmetic in the PID driver.  This keeps the arithmetic
defined for the complete descriptor range before the result is clamped.

Fixes: dc76c912145f ("Input: use new FF interface in the HID force feedback drivers")
Fixes: b27c9590ca0f ("HID: add support for Thrustmaster FGT Force Feedback wheel")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-tmff.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-tmff.c b/drivers/hid/hid-tmff.c
index 423f395d01ac5..319e7b6703846 100644
--- a/drivers/hid/hid-tmff.c
+++ b/drivers/hid/hid-tmff.c
@@ -17,6 +17,7 @@
 
 #include <linux/hid.h>
 #include <linux/input.h>
+#include <linux/math64.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 
@@ -47,9 +48,9 @@ struct tmff_device {
 /* Changes values from 0 to 0xffff into values from minimum to maximum */
 static inline int tmff_scale_u16(unsigned int in, int minimum, int maximum)
 {
-	int ret;
+	s64 ret;
 
-	ret = (in * (maximum - minimum) / 0xffff) + minimum;
+	ret = div_s64((s64)in * ((s64)maximum - minimum), 0xffff) + minimum;
 	if (ret < minimum)
 		return minimum;
 	if (ret > maximum)
@@ -60,9 +61,9 @@ static inline int tmff_scale_u16(unsigned int in, int minimum, int maximum)
 /* Changes values from -0x80 to 0x7f into values from minimum to maximum */
 static inline int tmff_scale_s8(int in, int minimum, int maximum)
 {
-	int ret;
+	s64 ret;
 
-	ret = (((in + 0x80) * (maximum - minimum)) / 0xff) + minimum;
+	ret = div_s64((s64)(in + 0x80) * ((s64)maximum - minimum), 0xff) + minimum;
 	if (ret < minimum)
 		return minimum;
 	if (ret > maximum)
-- 
2.53.0



