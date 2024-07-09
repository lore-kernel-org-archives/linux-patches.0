Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC41E27713;
	Tue,  9 Jul 2024 11:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524600; cv=none; b=Y6C/Vbocd8Vaf5T2JOgW0ZgQTRvXC/Ml29kK8IHKWzm5YC766q7YvWiTk3xMH0wI/2svSYCZ55+rxNIorgFUhf1LHmS+NtA7adicgoy3IOt82qvW+Uv8TIkLFjyolZWCZybTMTu7trnrejBIwKaGXNZaPw5pSfQHbYMgC7OF2M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524600; c=relaxed/simple;
	bh=Jfjd11geDnq97iEs6Mrtf3jspV1zpVbO//Cy4Zul2GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbUwFVskW+8QX9mXztzeNuftlbG2xYivSwEOAuPk9eHYz8rs8PXsHAaWWpCStovNLTpbVxfgCFz2IwaUENOHL2q98ZagKS2IWhBXJY1JqCN7LsC7SY3dFwKBWpCXDrJ1Zm+AuYW7cq08UizEshVa3VYcacs6jqguyKzO/q56dhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPezPdaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPezPdaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C23C3277B;
	Tue,  9 Jul 2024 11:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524600;
	bh=Jfjd11geDnq97iEs6Mrtf3jspV1zpVbO//Cy4Zul2GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPezPdaKgR92ifMc+DnIkOwFVlqFU4nMIkS9vC0VXY8oKOU0GFbCNM0eVswU6QpJx
	 UUvek/hsWMsbiQhn1mfVZUmxutQiBFtwznp9uMhySrGorMfH9+5PCHrnhdxMbweUM9
	 UuQpktpx0L8bNuzZhDuIUQD4OoWaafp/SrYEY/Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Archer <erick.archer@outlook.com>,
	Kees Cook <keescook@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/102] Input: ff-core - prefer struct_size over open coded arithmetic
Date: Tue,  9 Jul 2024 13:09:43 +0200
Message-ID: <20240709110652.156186018@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



