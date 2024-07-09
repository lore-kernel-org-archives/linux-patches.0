Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B6B15884A;
	Tue,  9 Jul 2024 11:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524020; cv=none; b=XwxcYY2I1+AuR0TP1gJXVa62c+KkscVBv+j720oeodMIO0c7tj0QN6HHFhJ9RW3xVOLpEzUdcHP29saGzYeF5PSPV/or0yX+tr1xP+hxYASlLkFlxlOVQBrLqepBe6aJ2vbD5D4B9/ylO/sZHsCyUhckQJeTnMFj8T9LsuVmExU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524020; c=relaxed/simple;
	bh=xMwjzX5rIT6pNEwIpKgdBxsaZFYX89oza+qDF84HE+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOBd0/qKIhlZotAXdxQDLRJhakLae32G475b9oNTgsHiPL9yg4YlAQeNhxsPnniKdVmJ0rLTxhcJLaEwBtIoThwy0bGfGPixjxlcd0xWaQDGXGp/TMNjex4VJhj4cJLXwHzz72mS/hwRwFrUOMoKu1ODXJA4pcBw4fmhUWevwyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdIunlm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdIunlm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3728C3277B;
	Tue,  9 Jul 2024 11:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524020;
	bh=xMwjzX5rIT6pNEwIpKgdBxsaZFYX89oza+qDF84HE+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdIunlm/qP7vDp5C+S1FbA9TY0pErYMs9qMCrw01Uj3ZmF78GC9WkW0G3Gq6c2VZQ
	 yj9pxEFat8segRnEKj2xAGfe2lwaAD87+jzJti7ZoshNeJfzjtC2+RupNrrWRvfqFV
	 l0gBPiTdIditIuQUSHR0sElhtQsWiIJD0kf3dDGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Archer <erick.archer@outlook.com>,
	Kees Cook <keescook@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 045/197] Input: ff-core - prefer struct_size over open coded arithmetic
Date: Tue,  9 Jul 2024 13:08:19 +0200
Message-ID: <20240709110710.708003734@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



