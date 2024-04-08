Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DA77D3F6;
	Mon,  8 Apr 2024 13:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581373; cv=none; b=j8kAvFaWk7GvQMVeLAOZ4iuqa70KMzHHk6mJXT65gw1pNbIObb9KgrU8BqG5WmsmID9gJfsztIQ04NIncTzGfK2+jEFVuAJuyWpTOFQopqA5oNGuIUxa8DvFzZozEP+9KLBImdf31fJ7THrC8GLw/O1xGPuL2DIIh0WVyzXoHJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581373; c=relaxed/simple;
	bh=9UCLUQPIqMj0ueXuxrChPOUK/pG0/2emyOp0XbulPcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qenDiHhKlwvjvrzsCJ6vrjGA/fA+0fDQ1m3eKBOiH8VIdgJd/YqXbH1hClLTIUepRXttJu/QLTSWj/6ETLWyS5+zI5uJrdypDHVrTMsMQ33fjzFE9+e1/AZbr4/5hWjrckidWyr3I+pS2bRA7O8A7jfotch7iCF4yG2MIHWG+9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBgSegS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBgSegS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD1DC433C7;
	Mon,  8 Apr 2024 13:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581373;
	bh=9UCLUQPIqMj0ueXuxrChPOUK/pG0/2emyOp0XbulPcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBgSegS8sk37wCWhlLJDwfFlSgjWGC+SuQLMP8HXbElhcM3PIEzsR1543BQsBKYEI
	 yV+6s7UFdR4A3SGWLjAHTI68xngaSRrFVKhTZqb3xd+AHcRqSASUnNREcBt1RBbGqr
	 h4ezvgZrKjzpbTkysfHY9L94nDaYGyGWjuQZ/ZWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <quic_mkshah@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/690] PM: suspend: Set mem_sleep_current during kernel command line setup
Date: Mon,  8 Apr 2024 14:48:26 +0200
Message-ID: <20240408125400.989429907@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 13d905dd32675..5d617639e81ed 100644
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



