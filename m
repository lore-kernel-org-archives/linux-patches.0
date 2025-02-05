Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFA216EB42;
	Wed,  5 Feb 2025 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767549; cv=none; b=evIxc4DS/3k/XiRCkSsSHUGcnAHayjboYcEUWQVGYMp2OU4xYPasGIKCXBQT7B/HVeMpdBJS1uP6SSfexzbzxnHmcJAHhPOM8ydQKqPM+1svullZJJkJRXMANgJ4rccH/hAt2nu1sAAj79U4Lk8mhUI7+mVr6zCw56ZftvGy26Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767549; c=relaxed/simple;
	bh=QTkx8lALeLQAoCV3EHwufF/J6rxTFmfdQtzLn5r54Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcrJWmxLD2Df64RIVyByrurrIE3rXipX6fD1dQQR2LywDFojEsJZdj3Grexpef6sGAw7bsJBSEgKkyWgxcOuLQ5CgiXODUO6chZgY8H48TUmsmAeJG1S86qcYAfEq5YI5vLy/azaoeooS4PwMHZ7nAfbLRmMrIgAKmIbY3gvU3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEj2fWBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEj2fWBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E412C4CED1;
	Wed,  5 Feb 2025 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767548;
	bh=QTkx8lALeLQAoCV3EHwufF/J6rxTFmfdQtzLn5r54Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEj2fWBrUKQ7BQpJ3E+P1xJvL98uNZfZab1LRuEj/U4a8wAb37cLpi/rJnsYe7gge
	 6DIQyNSh8BsTtWd0DaisYDFHvNpABtX5ok7tRLc7phQiSoAelDd9Tt77Oi9j0pGVt3
	 leRYwOjjbhwsRZsbsyo6f5HQFECU3s1v56xyAzSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 449/590] driver core: class: Fix wild pointer dereferences in API class_dev_iter_next()
Date: Wed,  5 Feb 2025 14:43:24 +0100
Message-ID: <20250205134512.445724071@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit e128f82f7006991c99a58114f70ef61e937b1ac1 ]

There are a potential wild pointer dereferences issue regarding APIs
class_dev_iter_(init|next|exit)(), as explained by below typical usage:

// All members of @iter are wild pointers.
struct class_dev_iter iter;

// class_dev_iter_init(@iter, @class, ...) checks parameter @class for
// potential class_to_subsys() error, and it returns void type and does
// not initialize its output parameter @iter, so caller can not detect
// the error and continues to invoke class_dev_iter_next(@iter) even if
// @iter still contains wild pointers.
class_dev_iter_init(&iter, ...);

// Dereference these wild pointers in @iter here once suffer the error.
while (dev = class_dev_iter_next(&iter)) { ... };

// Also dereference these wild pointers here.
class_dev_iter_exit(&iter);

Actually, all callers of these APIs have such usage pattern in kernel tree.
Fix by:
- Initialize output parameter @iter by memset() in class_dev_iter_init()
  and give callers prompt by pr_crit() for the error.
- Check if @iter is valid in class_dev_iter_next().

Fixes: 7b884b7f24b4 ("driver core: class.c: convert to only use class_to_subsys")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250105-class_fix-v6-1-3a2f1768d4d4@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/class.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index cb5359235c702..ce460e1ab1376 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -323,8 +323,12 @@ void class_dev_iter_init(struct class_dev_iter *iter, const struct class *class,
 	struct subsys_private *sp = class_to_subsys(class);
 	struct klist_node *start_knode = NULL;
 
-	if (!sp)
+	memset(iter, 0, sizeof(*iter));
+	if (!sp) {
+		pr_crit("%s: class %p was not registered yet\n",
+			__func__, class);
 		return;
+	}
 
 	if (start)
 		start_knode = &start->p->knode_class;
@@ -351,6 +355,9 @@ struct device *class_dev_iter_next(struct class_dev_iter *iter)
 	struct klist_node *knode;
 	struct device *dev;
 
+	if (!iter->sp)
+		return NULL;
+
 	while (1) {
 		knode = klist_next(&iter->ki);
 		if (!knode)
-- 
2.39.5



