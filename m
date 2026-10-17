Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8DE3A1D01;
	Sat, 17 Oct 2026 16:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255928; cv=none; b=ifbdVv/DQcMB2NSZBp1410up6X/fnLFoS9BFRXw+tQSMbdUa6OxgYoggS/mckpWdaDSV4DNXHIgFNYj9grU+7O8PhOaRcVpwEVGjV1AlfkWznYDxz+L62crmvg72hfo/3GxsHP1Z9IxWy/rr7Y1mbBDMJ9zqnm5QQXKs1zanetM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255928; c=relaxed/simple;
	bh=ZNalj5FQV6+1XBlzVZ+MLLi/T6Ylqzbrl+80a9x+dwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcnzfTizT4JmgXYK5fM0+q4Jt4fei758TILP/4OqcfeoHYF/vixcX17DLWQZFNnFGz8DJFOjYwZNyiqbsmySXSEQxya2TYHsnoE+/3wQ7B3LEG6NQUagllm+/RiuFTzabQG7ztP1gsDTRsuMgiwQIRUgkY89OYsgrNXzXERnxbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+9qbmr3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+9qbmr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301BE1F000C5;
	Sat, 17 Oct 2026 16:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255926;
	bh=WF1akRZ7BAcxyBsoKCDFOxxGN3imabz4ocJQW7Gosv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+9qbmr3esSwjjh6WAi7Pz2fb3/l7xMohlZbcURNpM74p2yAhN0VI1H/E6R7kWepD
	 igTgrQ7vmCmhRLsA/Wmrxw9W8KCJEMAQmG8FPnN6opkqDacAVff7VUTmqg21V96sVE
	 +nbSUJGtqxrJhiRNx0ZqmYsbsZdGzS9H+c0gvRuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0065/1674] params: Use size_add() for kmalloc()
Date: Sat, 17 Oct 2026 17:38:57 +0200
Message-ID: <20261017160432.806300520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0fc79cbc937f2a754a302a710a94b68c61d0a89a ]

Prevent allocations from integer overflow by using size_add().

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231120151419.1661807-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 3dfaae04243c ("params: fix charp corruption on allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/params.c b/kernel/params.c
index 8992899996984..1efc083b651c9 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -11,6 +11,7 @@
 #include <linux/moduleparam.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/security.h>
@@ -48,7 +49,7 @@ static void *kmalloc_parameter(unsigned int size)
 {
 	struct kmalloced_param *p;
 
-	p = kmalloc(sizeof(*p) + size, GFP_KERNEL);
+	p = kmalloc(size_add(sizeof(*p), size), GFP_KERNEL);
 	if (!p)
 		return NULL;
 
-- 
2.53.0



