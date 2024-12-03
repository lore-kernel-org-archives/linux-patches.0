Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F061223CE;
	Tue,  3 Dec 2024 16:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242060; cv=none; b=SZ0NDzlZDib3eROX8oNnRWDqqk+Jc8GgHty5pMBiFFC5/BCz3EJne4+wSsENQjSkpF1rYiM+uB9gVUwTfwHXBEzcL56+SGoEMoZVbmb2PpwB7z7jmixLIkWRcE9mrb838zVqcDdoCQYUZdEpR3AiCkggp5IWdR/TwuWjuUuLFcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242060; c=relaxed/simple;
	bh=orxU6+enaatr/yFKZysiPWIkS4vmaSr3qGHUIX/Opts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSGMonDhBk96sapchh72414cHPeE5REUhO5ajn7q5pruU8+RkYJw/QDrbcQ9lz4HB2KaqZ06tUZfwIizyBSwtyrx+R5bjjg4o89H7m6h+RnJnRfh4JjcVzrEdyxmeqbH6mOMpVWKE4cYvm8+NN/VGVkAutpNPVScDrIZ6LN7lgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLy4nGUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLy4nGUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B2DC4CECF;
	Tue,  3 Dec 2024 16:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242059;
	bh=orxU6+enaatr/yFKZysiPWIkS4vmaSr3qGHUIX/Opts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLy4nGUKIl9qmm/YitdPkl/Gt5vl09Wn5EOzpdWaXgHoiiOoY93olj9ZmAtfKJVF/
	 BXEM5lkywL6owmxGY3eYFExmFvBVYn+drxtUgS7lhPMaowOkNwNh8UUPRBLwvzKTyI
	 efmapGTQSd6skcfWp1v2/bLzqUkH8d6qJY/DhOzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Keita Morisaki <keyz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 596/826] devres: Fix page faults when tracing devres from unloaded modules
Date: Tue,  3 Dec 2024 15:45:23 +0100
Message-ID: <20241203144807.006878887@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



