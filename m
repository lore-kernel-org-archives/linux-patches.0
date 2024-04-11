Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAD213DDDD;
	Thu, 11 Apr 2024 09:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829569; cv=none; b=iSAjrh6INMos8Po6z0R6wHjmFjQgpHMWjIrn84bqgYiBC7iV6QLiUyKGL+8JBB4Afj6qcittGmy6Sd0nMRGZxI/f9TbRrPtR4XbpCVKqzJvmWjDXwx4LC1e/2422rWjmxpusP4XDbhYqI6REhrMZOAoMaNCwt+F41zjIh2O1XZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829569; c=relaxed/simple;
	bh=uMScbvoJ2FEVlyiEZtkL433vmrUd6cbGefwg4aeCw/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7oOWxp0AE86I/5c9W0LizD97kdaAahu978/uePSwcqTCqQy3JCKAXvOD0tNfBHflbHnvP4IXRm0qhQfbze3WR2mS/6y2UamhpxSzAAPAFszkqo0PFoBne5b1nOacv/F/kajcdJjrh8uK1HCk6RrhLI4rWv15rpBZWxYMKzQfTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgWx+vTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgWx+vTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00ABAC43390;
	Thu, 11 Apr 2024 09:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829569;
	bh=uMScbvoJ2FEVlyiEZtkL433vmrUd6cbGefwg4aeCw/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgWx+vTopd4nMx9aNKYUR9ctCM6jZeuX5/F8ffHNrJWwMKzGrSBfOfxRZUyO749qf
	 nIbm8/c4Ymbt3W/UhsorP8/ytHVv2vUS0eLQB1arkPTYWusQ3WSDOybYhaPBEl/GUQ
	 1pUvoQ/5J+EicPB0KRPzXkCGU8wCmiCc4xrDtIE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <quic_mkshah@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/175] PM: suspend: Set mem_sleep_current during kernel command line setup
Date: Thu, 11 Apr 2024 11:54:13 +0200
Message-ID: <20240411095420.464077841@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0bd595a0b6103..7a080015a1b3c 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -202,6 +202,7 @@ static int __init mem_sleep_default_setup(char *str)
 		if (mem_sleep_labels[state] &&
 		    !strcmp(str, mem_sleep_labels[state])) {
 			mem_sleep_default = state;
+			mem_sleep_current = state;
 			break;
 		}
 
-- 
2.43.0



