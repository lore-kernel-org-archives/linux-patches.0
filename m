Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2173969973;
	Wed, 21 Feb 2024 13:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521054; cv=none; b=bxuXnCrgqvUmaNJqZzEyOrQN6F5MYYPxpMtB0FVt5dnXZiO9B4f8U6qBI/3wRrR09z9BWdlZTaOqM3v6XH+kU00cAmylPxjUsyF0eptzczvyoOgvi0GeBvGZ0bgh0NTM0/EWjmVtuActp2fduuth74mOvO+MyaD/GoFQPF+hH1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521054; c=relaxed/simple;
	bh=b4gVXDDAfgpI5yNKSEUMPABTuz68NO5wR6ENnZCTNVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=in82JIu7O/39S20g9Y4pyQgAqTqkWRrl12xLVpvUkK/AW32t2q6cCLVsHTq9JjFaXs5KXGnAG6tR2bTZJBYYfbMELH6+tBhlAclezwo65keLv51h7Li+TmDvbgJmmZaH0C9wuOMBlmISBgzpBvE3Uj/Z7K/plPurewJMAylKfk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kt9hQ4n2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kt9hQ4n2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEA7C433C7;
	Wed, 21 Feb 2024 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521054;
	bh=b4gVXDDAfgpI5yNKSEUMPABTuz68NO5wR6ENnZCTNVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kt9hQ4n204QZSe7mfTcmm66E5nfbP3KqbhoxCFc4ywjh4Y2P0o2GEpNoe6nZUFZLn
	 iiF7D0U335IT+cnlnqMOZ5uJ3hNExYy2+LB6+tcuNpVsAizjPDkiGCW7N8GsD764yj
	 mmjg2aVJStcenqkErhOT1iJRzDCjP/GhoxpzyDao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Sujith Thomas <sujith.thomas@intel.com>,
	Darren Hart <dvhart@infradead.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Amit Kucheria <amit.kucheria@verdurent.com>,
	Jean Delvare <jdelvare@suse.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kalle Valo <kvalo@codeaurora.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
	Andy Shevchenko <andy@infradead.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 002/202] include/linux/units.h: add helpers for kelvin to/from Celsius conversion
Date: Wed, 21 Feb 2024 14:05:03 +0100
Message-ID: <20240221125931.820442631@linuxfoundation.org>
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

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit 23331e4893614deb555c65cdf115c8a28ed32471 ]

Patch series "add header file for kelvin to/from Celsius conversion
helpers", v4.

There are several helper macros to convert kelvin to/from Celsius in
<linux/thermal.h> for thermal drivers.  These are useful for any other
drivers or subsystems, but it's odd to include <linux/thermal.h> just
for the helpers.

This adds a new <linux/units.h> that provides the equivalent inline
functions for any drivers or subsystems, and switches all the users of
conversion helpers in <linux/thermal.h> to use <linux/units.h> helpers.

This patch (of 12):

There are several helper macros to convert kelvin to/from Celsius in
<linux/thermal.h> for thermal drivers.  These are useful for any other
drivers or subsystems, but it's odd to include <linux/thermal.h> just
for the helpers.

This adds a new <linux/units.h> that provides the equivalent inline
functions for any drivers or subsystems.  It is intended to replace the
helpers in <linux/thermal.h>.

Link: http://lkml.kernel.org/r/1576386975-7941-2-git-send-email-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Cc: Andy Shevchenko <andy@infradead.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 3ef79cd14122 ("serial: sc16is7xx: set safe default SPI clock frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/units.h | 84 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100644 include/linux/units.h

diff --git a/include/linux/units.h b/include/linux/units.h
new file mode 100644
index 000000000000..aaf716364ec3
--- /dev/null
+++ b/include/linux/units.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_UNITS_H
+#define _LINUX_UNITS_H
+
+#include <linux/kernel.h>
+
+#define ABSOLUTE_ZERO_MILLICELSIUS -273150
+
+static inline long milli_kelvin_to_millicelsius(long t)
+{
+	return t + ABSOLUTE_ZERO_MILLICELSIUS;
+}
+
+static inline long millicelsius_to_milli_kelvin(long t)
+{
+	return t - ABSOLUTE_ZERO_MILLICELSIUS;
+}
+
+#define MILLIDEGREE_PER_DEGREE 1000
+#define MILLIDEGREE_PER_DECIDEGREE 100
+
+static inline long kelvin_to_millicelsius(long t)
+{
+	return milli_kelvin_to_millicelsius(t * MILLIDEGREE_PER_DEGREE);
+}
+
+static inline long millicelsius_to_kelvin(long t)
+{
+	t = millicelsius_to_milli_kelvin(t);
+
+	return DIV_ROUND_CLOSEST(t, MILLIDEGREE_PER_DEGREE);
+}
+
+static inline long deci_kelvin_to_celsius(long t)
+{
+	t = milli_kelvin_to_millicelsius(t * MILLIDEGREE_PER_DECIDEGREE);
+
+	return DIV_ROUND_CLOSEST(t, MILLIDEGREE_PER_DEGREE);
+}
+
+static inline long celsius_to_deci_kelvin(long t)
+{
+	t = millicelsius_to_milli_kelvin(t * MILLIDEGREE_PER_DEGREE);
+
+	return DIV_ROUND_CLOSEST(t, MILLIDEGREE_PER_DECIDEGREE);
+}
+
+/**
+ * deci_kelvin_to_millicelsius_with_offset - convert Kelvin to Celsius
+ * @t: temperature value in decidegrees Kelvin
+ * @offset: difference between Kelvin and Celsius in millidegrees
+ *
+ * Return: temperature value in millidegrees Celsius
+ */
+static inline long deci_kelvin_to_millicelsius_with_offset(long t, long offset)
+{
+	return t * MILLIDEGREE_PER_DECIDEGREE - offset;
+}
+
+static inline long deci_kelvin_to_millicelsius(long t)
+{
+	return milli_kelvin_to_millicelsius(t * MILLIDEGREE_PER_DECIDEGREE);
+}
+
+static inline long millicelsius_to_deci_kelvin(long t)
+{
+	t = millicelsius_to_milli_kelvin(t);
+
+	return DIV_ROUND_CLOSEST(t, MILLIDEGREE_PER_DECIDEGREE);
+}
+
+static inline long kelvin_to_celsius(long t)
+{
+	return t + DIV_ROUND_CLOSEST(ABSOLUTE_ZERO_MILLICELSIUS,
+				     MILLIDEGREE_PER_DEGREE);
+}
+
+static inline long celsius_to_kelvin(long t)
+{
+	return t - DIV_ROUND_CLOSEST(ABSOLUTE_ZERO_MILLICELSIUS,
+				     MILLIDEGREE_PER_DEGREE);
+}
+
+#endif /* _LINUX_UNITS_H */
-- 
2.43.0



