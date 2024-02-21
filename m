Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D561569954;
	Wed, 21 Feb 2024 13:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521060; cv=none; b=co8zuWAoq98WYovD+2ozZDHcVXWIJ/SAKwup/714F4pUQAkhVySV/QTURUrbCft+uWfqX6URpucf3711sW6RBnBwoDZdip6RlKuBspnJXp6ZrllQETAQ6cqUgeotSiyYHXvKZJi7D4HOmu8ue5rTmLlnofcwX7zK/z3nAEfTtjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521060; c=relaxed/simple;
	bh=asPHZnKKMrQdY/GFYH45W2U5tOQjZLoyaRARoM5R1n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e220rsfHJN7YetNgjdzT1ZkBbssOG6ucajl8/qPGk+Hz7K90C6e/cdX9ShMPgwT7JB7nHD8DehyX7AKDXYJXYcCOS/yETSWDeBHAFtPHTfsAA8Wh07o+EdV7JBFUDHahdU2SkCwjnpBBexk/NUV/7QGPcj+vFmuEK1VEiR+87O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7HQsGEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7HQsGEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF948C433C7;
	Wed, 21 Feb 2024 13:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521060;
	bh=asPHZnKKMrQdY/GFYH45W2U5tOQjZLoyaRARoM5R1n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7HQsGEERzdp0LCFgAQ0zLEx+JV8GPfI1EoT8uIY+0bDJxp51x90w4eLOzNq1MFCH
	 nESYDqHLNmjk6ss97ELM6SymHeSXy7N7Jwfj5LgEbbP20rKpsFpBsYm8yBgTvF+Bk9
	 51WXL69sSlmLtOepq1MZBymgM6oz2GPcLIAOGeyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Christian Eggers <ceggers@arri.de>,
	Lukasz Luba <lukasz.luba@arm.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Zhang Rui <rui.zhang@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/202] units: change from L to UL
Date: Wed, 21 Feb 2024 14:05:05 +0100
Message-ID: <20240221125931.881594647@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit c9221919a2d2df5741ab074dfec5bdfc6f1e043b ]

Patch series "Add Hz macros", v3.

There are multiple definitions of the HZ_PER_MHZ or HZ_PER_KHZ in the
different drivers.  Instead of duplicating this definition again and
again, add one in the units.h header to be reused in all the place the
redefiniton occurs.

At the same time, change the type of the Watts, as they can not be
negative.

This patch (of 10):

The users of the macros are safe to be assigned with an unsigned instead
of signed as the variables using them are themselves unsigned.

Link: https://lkml.kernel.org/r/20210816114732.1834145-1-daniel.lezcano@linaro.org
Link: https://lkml.kernel.org/r/20210816114732.1834145-2-daniel.lezcano@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Christian Eggers <ceggers@arri.de>
Cc: Lukasz Luba <lukasz.luba@arm.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 3ef79cd14122 ("serial: sc16is7xx: set safe default SPI clock frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/units.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/units.h b/include/linux/units.h
index 92c234e71cab..4a23e39acc7b 100644
--- a/include/linux/units.h
+++ b/include/linux/units.h
@@ -4,9 +4,9 @@
 
 #include <linux/kernel.h>
 
-#define MILLIWATT_PER_WATT	1000L
-#define MICROWATT_PER_MILLIWATT	1000L
-#define MICROWATT_PER_WATT	1000000L
+#define MILLIWATT_PER_WATT	1000UL
+#define MICROWATT_PER_MILLIWATT	1000UL
+#define MICROWATT_PER_WATT	1000000UL
 
 #define ABSOLUTE_ZERO_MILLICELSIUS -273150
 
-- 
2.43.0



