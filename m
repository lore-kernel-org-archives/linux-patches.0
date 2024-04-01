Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B311E525;
	Mon,  1 Apr 2024 16:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989487; cv=none; b=n41PhCpCUJrtXy8C5DsYdsa16JEWig3f9VrZx/jSvXO3nymY1E+4vHIfG0IEX+x+ZoTI5XDXTCbS1cgDYpcvb6lymyJ8bbZ90z9Hm5cbOnDYYsK8kqKmi2uCD1RODkuOhgXeKd5wEDQ0le3CMSFeS/pHTp19iwcPAz/Hx6xPcYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989487; c=relaxed/simple;
	bh=lhWiMJxk2nB1ITEjMP36num0a8fWLGEgEAMy2UZMnZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tB4xVQjR7b8FmpSuaKvrEtjBZGpFN/locb6YYfVEkLIRN4WwJWN1RTS5x6sC+6kIy/9oya8//5XmZZvchrx93jBJGcge8YPuww2I5XMVHdJ25sBYt9ZMb/Dq6EsFelFg4HtzKr6WfZvwEemR6d4whNJiwKZvQqhLOXNxJXXdHaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aivPsMvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aivPsMvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623D7C433F1;
	Mon,  1 Apr 2024 16:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989487;
	bh=lhWiMJxk2nB1ITEjMP36num0a8fWLGEgEAMy2UZMnZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aivPsMvfE9ToC12KDy0kxzQk3rQbHJJlGCeJEM/Lc8+THOmd5hKe1WMNPqtSMG6u+
	 bXQq+SO98r7aZZr1TIgT8Uc4u7EYVcmRFewS+OkPMoH+Z2UJC2VT/rHrQ+N4Q7396T
	 fzNq+i/VoggqzMQ+jcd1sagEOSLzaKwAfgO7tshM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <quic_mkshah@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/396] PM: suspend: Set mem_sleep_current during kernel command line setup
Date: Mon,  1 Apr 2024 17:41:53 +0200
Message-ID: <20240401152549.831688261@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Maulik Shah <quic_mkshah@quicinc.com>

[ Upstream commit 9bc4ffd32ef8943f5c5a42c9637cfd04771d021b ]

psci_init_system_suspend() invokes suspend_set_ops() very early during
bootup even before kernel command line for mem_sleep_default is setup.
This leads to kernel command line mem_sleep_default=s2idle not working
as mem_sleep_current gets changed to deep via suspend_set_ops() and never
changes back to s2idle.

Set mem_sleep_current along with mem_sleep_default during kernel command
line setup as default suspend mode.

Fixes: faf7ec4a92c0 ("drivers: firmware: psci: add system suspend support")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Maulik Shah <quic_mkshah@quicinc.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/suspend.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index fa3bf161d13f7..a718067deecee 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -192,6 +192,7 @@ static int __init mem_sleep_default_setup(char *str)
 		if (mem_sleep_labels[state] &&
 		    !strcmp(str, mem_sleep_labels[state])) {
 			mem_sleep_default = state;
+			mem_sleep_current = state;
 			break;
 		}
 
-- 
2.43.0



