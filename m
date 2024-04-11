Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1188714A619;
	Thu, 11 Apr 2024 10:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831533; cv=none; b=RoRhTluw/9kPRCM7SdcJMIb7IZ+Ichh7HUd+MnnaJLSO2YP2yiK8WkeIeMnTNRoSiG2ZGWz4iYnE+y5X+Wzmgl5Cxbs9cuYTtpyNyZrR2ZTLeH1gNOQmRoI5UiYuUKYVIeIwx6BpacDHaHTSkgwN7xdFfCWBeYG3L4G63pjVMTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831533; c=relaxed/simple;
	bh=/emSC9dUy5Hy2EEBEjVGKnV7NhYG6MDJhYTW4wg380c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2t/fmzxpe2dcJZYHANzctawNxOUc++CS6ZnbErvwIUc24HjizszpsgYK2rwHq+3wS6Ml4kmusR8ljb6IhXZNwExvtPWCC3PVWKSeRAtiug9ErnOYao/OWB0NiKBIkpVRLIeMA2wzmJMakFRDQYtlQlilijmUPBamIplw2cin9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDAaJ8ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDAaJ8ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6DCC433F1;
	Thu, 11 Apr 2024 10:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831532;
	bh=/emSC9dUy5Hy2EEBEjVGKnV7NhYG6MDJhYTW4wg380c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDAaJ8ewJ0XAclXgSIJjMKGs1kjYXcTKi7W+ShbNXy77w+W0/HnrdIk5NqMaH04xb
	 M+eIHbSAgedQBSSFZ4mYvcEu+hDYnlnjnoGWm4XhjITFxyH/f3DC1eLv6PLlo+gZ9i
	 ibPoOTwBHHb5NpM1YrGlw4T+tPd0EilYF4kjYktI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <quic_mkshah@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/294] PM: suspend: Set mem_sleep_current during kernel command line setup
Date: Thu, 11 Apr 2024 11:53:23 +0200
Message-ID: <20240411095436.845437055@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4aa4d5d3947f1..14e981c0588ad 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -187,6 +187,7 @@ static int __init mem_sleep_default_setup(char *str)
 		if (mem_sleep_labels[state] &&
 		    !strcmp(str, mem_sleep_labels[state])) {
 			mem_sleep_default = state;
+			mem_sleep_current = state;
 			break;
 		}
 
-- 
2.43.0



