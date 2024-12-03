Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C04B1F75A0;
	Tue,  3 Dec 2024 15:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239408; cv=none; b=nxtuVrFpf5wFMQ42mcdCAVyVkLEronGOYZbmsbgwBUNo3DACNxYnT+20DAc2tuMgTlij69B1qJlAqfw5ASU9opACbNIUHSi5NJEeVfrC4E5ptWNFzmhZeohahxYNIyUn5h2UICJYgWVb642GGkfOl3Xu1CRe4Ord9HIJzzMNjOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239408; c=relaxed/simple;
	bh=cCOVEcsv38PTW7/rIZ6CRUi4xsPRRITfMyZBSSlaeLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQnBE/jtG2a+p5Ep90IsJlfsrui5iRAPx6jWg2wb3BeDIc4mUw6lMWkWnaQF8QKHcPLfM7fxsPQsz+IcLyRjRctEIFzZiwOH0cmG4Lmf2Bfp+dIQtf0ZtCoh1JgaJdthLlgfbCVqrxF1/zr7y548naWe/t4J0sqn9TOayxKcqcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e16o4aO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e16o4aO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97162C4CECF;
	Tue,  3 Dec 2024 15:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239408;
	bh=cCOVEcsv38PTW7/rIZ6CRUi4xsPRRITfMyZBSSlaeLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e16o4aO9YghvaCdgOL6z1qA98/2bLSdv5QKRZHtXI+N/FwnnMpOc94nPkSqvQwUhm
	 5oLppdkTd239q3YgPmcSV0RnEazqgftzi9MRKax66hE6EhgaxZAMvZVk4K5AT1WHs+
	 pSl8r7rqi4slQvRJ/BNitFt3HPuw5zX3Dd5K/M/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Keita Morisaki <keyz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 603/817] devres: Fix page faults when tracing devres from unloaded modules
Date: Tue,  3 Dec 2024 15:42:55 +0100
Message-ID: <20241203144019.465326147@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keita Morisaki <keyz@google.com>

[ Upstream commit 765399553714e934a219d698953d435f4f99caa7 ]

The devres ftrace event logs the name of the devres node, which is often a
function name (e.g., "devm_work_drop") stringified by macros like
devm_add_action. Currently, ftrace stores this name as a string literal
address, which can become invalid when the module containing the string is
unloaded. This results in page faults when ftrace tries to access the name.

This behavior is problematic because the devres ftrace event is designed to
trace resource management throughout a device driver's lifecycle, including
during module unload. The event should be available even after the module
is unloaded to properly diagnose resource issues.

Fix the issue by copying the devres node name into the ftrace ring buffer
using __assign_str(), instead of storing just the address. This ensures
that ftrace can always access the name, even if the module is unloaded.

This change increases the memory usage for each of the ftrace entry by
12-16 bytes assuming the average devres node name is 20 bytes long,
depending on the size of const char *.

Note that this change does not affect anything unless all of following
conditions are met.
- CONFIG_DEBUG_DEVRES is enabled
- ftrace tracing is enabled
- The devres event is enabled in ftrace tracing

Fixes: 09705dcb63d2 ("devres: Enable trace events")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Keita Morisaki <keyz@google.com>
Link: https://lore.kernel.org/r/20240928125005.714781-1-keyz@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/trace.h b/drivers/base/trace.h
index e52b6eae060dd..3b83b13a57ff1 100644
--- a/drivers/base/trace.h
+++ b/drivers/base/trace.h
@@ -24,18 +24,18 @@ DECLARE_EVENT_CLASS(devres,
 		__field(struct device *, dev)
 		__field(const char *, op)
 		__field(void *, node)
-		__field(const char *, name)
+		__string(name, name)
 		__field(size_t, size)
 	),
 	TP_fast_assign(
 		__assign_str(devname);
 		__entry->op = op;
 		__entry->node = node;
-		__entry->name = name;
+		__assign_str(name);
 		__entry->size = size;
 	),
 	TP_printk("%s %3s %p %s (%zu bytes)", __get_str(devname),
-		  __entry->op, __entry->node, __entry->name, __entry->size)
+		  __entry->op, __entry->node, __get_str(name), __entry->size)
 );
 
 DEFINE_EVENT(devres, devres_log,
-- 
2.43.0



