Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6B451C46;
	Mon,  1 Apr 2024 15:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986820; cv=none; b=dFWtV/jokJyJw4amGgpzzAQpshuwg2vkKEiBQ+lFL4rZqOSOUdgp+Tu7uTwvjtPZ7+OZINtMslWEnE8bOuD9M0bFFrsxod9RZ0rlP9HjFxw6ymsVMqKXsYuNSzPwDIPAjD9zCzV++Z/qw0MlWiF0uUrvaHxBIfzXRpcl5BZ/BGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986820; c=relaxed/simple;
	bh=LOhxDj4QOS0xfxnVFNCBEYTbQrbjpYEWMYxBCSBltts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyBCLypPWflDjcpNzjK/zsBc8fjfluhiBPG0Z3aaV9EOPZguBcC7HfZuLTb68Bt3yl453IfAPKHJxXAVnMX2ax9gIayzp3HoguJkOPvRX3KzwaNF8Mnb0LzUjWYt/iJPwM08NpJgMYp9R4WExztOR5ERMfC8bz2nbdOFWEESDZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTWpA8Ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTWpA8Ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E3DC433C7;
	Mon,  1 Apr 2024 15:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986819;
	bh=LOhxDj4QOS0xfxnVFNCBEYTbQrbjpYEWMYxBCSBltts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTWpA8IpFo/EK4yj4VXAVeYlPRUJ/4tMLCD8stBUmMNvu/q3iKgDYhe0TppMxPhUL
	 3BwFWr3BNahZ7uquwUXKq14rZZdeGP1XgKV9fP79I+Vod5uHolEFaHkuBCqUeZrzBx
	 k7mojpdjjPkCX48kuUMIDYNtquZ+GVFVw/m9VEno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <quic_mkshah@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 068/399] PM: suspend: Set mem_sleep_current during kernel command line setup
Date: Mon,  1 Apr 2024 17:40:34 +0200
Message-ID: <20240401152551.216026719@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



