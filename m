Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979F8446AC;
	Mon,  1 Apr 2024 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988043; cv=none; b=oGqIwduJK33YXj/UXi+can8sG8s7NGzURbw4lQAlqOtZ7laAh7dp39vk7jAkeE14uMFR0kCEQzL5GzxAT4wTCemHmqd1vESzU0/iLGiGYusut7eTOBIRQG977nSS+O0l73Cesph58m0iKhPNkGd1DnqHTCq8Gj3+G/niYboZO6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988043; c=relaxed/simple;
	bh=dKmTSCg2JSztD6gWFejpymu0Q9uxXk44i+AXG1TBm10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBMiTDpLiqYuRNirNYFM/BAV9JhLGwR5IS6aNxc/IN+XaonDbMYrtjD2C4SvtMctqxlKWZ+9ZBvkJOm2Rx8dJPfRYM69FEQHrKmS+T1pE36u5dLgknepUVzu8FJz0R2r24WZb/TbsJhDrlx4ipEMqY2b7Jo1PZiz45CrM+aJEvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpYOy7Nt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpYOy7Nt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C18AC433F1;
	Mon,  1 Apr 2024 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988043;
	bh=dKmTSCg2JSztD6gWFejpymu0Q9uxXk44i+AXG1TBm10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpYOy7NteO+47jUczsn+s92SBkxjzBRsHudVh8FhFw4sfZNuZNW6hK/rRWfGpCJaa
	 MNhi3tf+cp7J1QBDxP39dAeco/OvWG/QMm7K/tFeOvYgqtfdlmByYhkrNoKxIfSGh8
	 eOGkh62iyPl334K1XH/Xpl0lHhGkFdi+ESYt1w7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <quic_mkshah@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 067/432] PM: suspend: Set mem_sleep_current during kernel command line setup
Date: Mon,  1 Apr 2024 17:40:54 +0200
Message-ID: <20240401152555.123127230@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



