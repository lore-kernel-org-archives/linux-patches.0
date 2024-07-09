Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8853C1581E4;
	Tue,  9 Jul 2024 11:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523549; cv=none; b=HNTLrUbj/rwnPWn/bPgrpEm4dIgYFu1K+doV+mcu1jsYbe/1qVIHJqM+P9CKiqh6Hh3ARvG1Dv53A+rHfCgJgTf1hj/XgSRUmUfasbygcaGEAKhG0v4QiPXGo4Z8E6SJIvQVtb+dDyaLgpYDaXjFVHlJr118srGK1wa5V9SjNqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523549; c=relaxed/simple;
	bh=ioOGVCxnVksbPmjvFPH0xh9DSjQpXB6w1Tq8F1VSG+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyOCzXxg+/TgD6CLqrfVmWKlrObIWQi9kTktrQEV7IXmfp9luCC7pf+OEFELYemS6+2qE4MKNCdHnZzN7SL+yF0vO9fyQgARcJgCfEBX7eieigA0k5LOZTkckJQQSSjiOdw3djUVUbWlfHY86kXXsxWYMymUaRabNS674b+rZNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbPmonqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbPmonqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEB1C3277B;
	Tue,  9 Jul 2024 11:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523549;
	bh=ioOGVCxnVksbPmjvFPH0xh9DSjQpXB6w1Tq8F1VSG+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbPmonquMxR/XNXId9xzfMc07yx0MJgtl9yLlfdu9QqnR/a1PoY31PlrvjlpZ9Cxx
	 32T9mmAqMz/DkSMTjsFHwrFaxCCGKn2yTSEGgcgbNwIzDnW89mhp31+PQAEYTKI9h4
	 7bH9VDpRlTVDiRZ/VPXeZJF6OyUj2ULfXdG1SxZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Archer <erick.archer@outlook.com>,
	Kees Cook <keescook@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/139] Input: ff-core - prefer struct_size over open coded arithmetic
Date: Tue,  9 Jul 2024 13:08:50 +0200
Message-ID: <20240709110659.329223207@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Erick Archer <erick.archer@outlook.com>

[ Upstream commit a08b8f8557ad88ffdff8905e5da972afe52e3307 ]

This is an effort to get rid of all multiplications from allocation
functions in order to prevent integer overflows [1][2].

As the "ff" variable is a pointer to "struct ff_device" and this
structure ends in a flexible array:

struct ff_device {
	[...]
	struct file *effect_owners[] __counted_by(max_effects);
};

the preferred way in the kernel is to use the struct_size() helper to
do the arithmetic instead of the calculation "size + count * size" in
the kzalloc() function.

The struct_size() helper returns SIZE_MAX on overflow. So, refactor
the comparison to take advantage of this.

This way, the code is more readable and safer.

This code was detected with the help of Coccinelle, and audited and
modified manually.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments [1]
Link: https://github.com/KSPP/linux/issues/160 [2]
Signed-off-by: Erick Archer <erick.archer@outlook.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/AS8PR02MB72371E646714BAE2E51A6A378B152@AS8PR02MB7237.eurprd02.prod.outlook.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/ff-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index 16231fe080b00..609a5f01761bd 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -9,8 +9,10 @@
 /* #define DEBUG */
 
 #include <linux/input.h>
+#include <linux/limits.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/overflow.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 
@@ -315,9 +317,8 @@ int input_ff_create(struct input_dev *dev, unsigned int max_effects)
 		return -EINVAL;
 	}
 
-	ff_dev_size = sizeof(struct ff_device) +
-				max_effects * sizeof(struct file *);
-	if (ff_dev_size < max_effects) /* overflow */
+	ff_dev_size = struct_size(ff, effect_owners, max_effects);
+	if (ff_dev_size == SIZE_MAX) /* overflow */
 		return -EINVAL;
 
 	ff = kzalloc(ff_dev_size, GFP_KERNEL);
-- 
2.43.0



