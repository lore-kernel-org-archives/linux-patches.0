Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9E2BA3F;
	Mon,  1 Apr 2024 16:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990766; cv=none; b=purZRa4l7M/1HU7uhGl9Nkzy0me1MNwnT2tG5ITHhOm9OX1Z2WJQVZvte2yHBplWbVuAxPSFGW8Hj6E+UqukAaAuCdG7yxT+wktokr3zWB5xVXvEx5Kxee4IXStnYWG4CRCaww9j8oPjYgZWAfgimY0rBkzKn/hLTV9xS1u/GPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990766; c=relaxed/simple;
	bh=2PepVfTBtMNIXvfzaPndhaoZ3jMD+Di9D1l+IAWxaH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCjT/As2fknaTQRb98psJyCyv6fA/RSyRsT8GffatPWEvBUk5NrPlHk/GQPGSRbb7wCUX4BWBys1rxVIke6+dGq2wrgwriMd85AEvULSLjh4Mr6LvHMb/1Qbw8AYajZzXz6tnw12ZY6UCAc9cACVKIibiv2Fhz/UvWQGgwmTc70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GlTMFF9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GlTMFF9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A596CC433F1;
	Mon,  1 Apr 2024 16:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990766;
	bh=2PepVfTBtMNIXvfzaPndhaoZ3jMD+Di9D1l+IAWxaH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GlTMFF9TjWWRmrIEzA2CHdLaEOnKLqKi/3xU3aAwkcFN9bwHZX5l/avdog5Oxe0Kq
	 uj9683eYJktLPpzGrLmj4xTEN/X7CJ1eJBKow3AVoUdUPkfb3w7EirnFdpQag3wu2Q
	 qKU7k1JVLErgs+8z08VeqR7HhWApStG9GwPR4B+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <quic_mkshah@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/272] PM: suspend: Set mem_sleep_current during kernel command line setup
Date: Mon,  1 Apr 2024 17:44:02 +0200
Message-ID: <20240401152532.154098728@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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



