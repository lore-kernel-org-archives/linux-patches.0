Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DE218BBAE;
	Wed, 17 Sep 2025 12:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112603; cv=none; b=gkYPwU6GDl4f8ctCD06q1q8i8EDp0kPRpFiWRfZanIAAxVrxYXbShu2NTUZn2WrxWWNgPjMTyMyhqETz+EQDQHpCQJ/aUeeHnSDVMXYErcG8Rtl9azJCphb1jRVrfTMSJC/9eXWWP9b8uVIpGfCATKA/X0ZCVnvbQxTVuJ2Ongk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112603; c=relaxed/simple;
	bh=Loy2bsHiwcRuENZua7URsmTXZacPEgSGzjBAb9N9zuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8x1kr+Le+wVFZdNoOB2ZgMw6Lh/HiC7xQNQCPDnEi00kVGJTTyTbo/vzhnVhvqfJdJcLDBaQJDxZaWKhes1I4dv96dHNOhoYyWtmcvfbiJK5Y5cMAIYApZr88SIqyWKJONDWN/wuVepOYTsDoo8x7xKz68cEc9z3MbS5CVtRhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tets+A3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tets+A3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44BFC4CEF5;
	Wed, 17 Sep 2025 12:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112603;
	bh=Loy2bsHiwcRuENZua7URsmTXZacPEgSGzjBAb9N9zuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tets+A3SzfZ6dnUV3wnGgoRdpJocps/CkaxHLVdiaQdUzKTRz+kcBrMEirEQdZRw9
	 pNNIEb//FH2p9/+pVpB+iMQFfk0hUkT2E3NHNLDSdm6CsZ2ouyGY0toZR1mMSWfeqT
	 hAeKtpkS3FKkGq9/6aTOL5Wo1GusCHif4qKJNtMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Weihua <yeweihua4@huawei.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Guenter Roeck <linux@roeck-us.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 021/189] trace/fgraph: Fix error handling
Date: Wed, 17 Sep 2025 14:32:11 +0200
Message-ID: <20250917123352.371349576@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit ab1396af7595e7d49a3850481b24d7fe7cbdfd31 ]

Commit edede7a6dcd7 ("trace/fgraph: Fix the warning caused by missing
unregister notifier") added a call to unregister the PM notifier if
register_ftrace_graph() failed. It does so unconditionally. However,
the PM notifier is only registered with the first call to
register_ftrace_graph(). If the first registration was successful and
a subsequent registration failed, the notifier is now unregistered even
if ftrace graphs are still registered.

Fix the problem by only unregistering the PM notifier during error handling
if there are no active fgraph registrations.

Fixes: edede7a6dcd7 ("trace/fgraph: Fix the warning caused by missing unregister notifier")
Closes: https://lore.kernel.org/all/63b0ba5a-a928-438e-84f9-93028dd72e54@roeck-us.net/
Cc: Ye Weihua <yeweihua4@huawei.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250906050618.2634078-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fgraph.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index dac2d58f39490..db40ec5cc9d73 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1393,7 +1393,8 @@ int register_ftrace_graph(struct fgraph_ops *gops)
 		ftrace_graph_active--;
 		gops->saved_func = NULL;
 		fgraph_lru_release_index(i);
-		unregister_pm_notifier(&ftrace_suspend_notifier);
+		if (!ftrace_graph_active)
+			unregister_pm_notifier(&ftrace_suspend_notifier);
 	}
 	return ret;
 }
-- 
2.51.0



