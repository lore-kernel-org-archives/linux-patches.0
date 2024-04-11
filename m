Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB5614601B;
	Thu, 11 Apr 2024 10:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830534; cv=none; b=R4eNc8xyA64ip+SLJj9Vu5gScavG3M1T2lMcwT+sy1DDBf/SttNRwF4uib3Q0kEsncmknWcByMQ+6cTAXCjrlaPgjXZcvzdGo+VhbS38mlBOjIMgj8ueW/VWvjmYQYr8wzkgvp1GlB+IwHpQKU0mLJ+hvtBYl44Y8b6PpHMAtZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830534; c=relaxed/simple;
	bh=vxwdqHjXHNE8bXcGL2WH0lYJvn08HgwkNKv7T56l7No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfifcKobNhq4HEe27aGtdY14MbxeL7kAY2tOhyZRJQsJO4M2gu3NG1aVdfYxPe30qwgBnVnnqkCtHUwEYdgxdCkNEU8aiwBp9K1kY3pB5CuKkPeqOTnD5QT2aLWPKW6sHshMml08o4XFgpa1DZ6Pv/PF9Yq275/ntnx2hvTO6x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSPbaZQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSPbaZQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C31C433F1;
	Thu, 11 Apr 2024 10:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830533;
	bh=vxwdqHjXHNE8bXcGL2WH0lYJvn08HgwkNKv7T56l7No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSPbaZQ7ReCaxkZQp2OHswq5Ehl0WUWd7IU6I4uSzEFxQKUrzQbH4E2t1FqGuedp1
	 /MTgeVchi2dt8UiQQGzQsf+IuFkdUEebZTX+RuBu+jEQKmpuDB1pJn2Mq2O0AVQV5f
	 K5Sea983CksR6ySmn9M7l7ER1UuwegELIyOQhIuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <quic_mkshah@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/215] PM: suspend: Set mem_sleep_current during kernel command line setup
Date: Thu, 11 Apr 2024 11:54:02 +0200
Message-ID: <20240411095425.893215509@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5dea2778a3dbb..c6433d3c04a0e 100644
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



