Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F811F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C687C433C7;
	Fri, 21 Jul 2023 16:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955984;
	bh=ADwtXdWigSKTz4p8FBIE3IB2ugR86Bi9UXrC+ArSIHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufx6A/z61WfKIUWFknntSEb0zbQxaDTEB65XcSaWwbw6tmRsfxHalfrXGxZIifx7a
	 cuKehH2ahGZlFN1I+Jn4PHoL3aH0VQkughySycdaYuP6f91MhqRzwx+1iLCN2nQRaL
	 0W6rUqe0HHcygs5VXsWz4ZLaxEnJP607nest4yXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Kauer <florian.kauer@linutronix.de>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 076/292] igc: Fix launchtime before start of cycle
Date: Fri, 21 Jul 2023 18:03:05 +0200
Message-ID: <20230721160532.067072275@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Kauer <florian.kauer@linutronix.de>

[ Upstream commit c1bca9ac0bcb355be11354c2e68bc7bf31f5ac5a ]

It is possible (verified on a running system) that frames are processed
by igc_tx_launchtime with a txtime before the start of the cycle
(baset_est).

However, the result of txtime - baset_est is written into a u32,
leading to a wrap around to a positive number. The following
launchtime > 0 check will only branch to executing launchtime = 0
if launchtime is already 0.

Fix it by using a s32 before checking launchtime > 0.

Fixes: db0b124f02ba ("igc: Enhance Qbv scheduling by using first flag bit")
Signed-off-by: Florian Kauer <florian.kauer@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 97eb3c390de9a..96a2f6e6f6b8a 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1016,7 +1016,7 @@ static __le32 igc_tx_launchtime(struct igc_ring *ring, ktime_t txtime,
 	ktime_t base_time = adapter->base_time;
 	ktime_t now = ktime_get_clocktai();
 	ktime_t baset_est, end_of_cycle;
-	u32 launchtime;
+	s32 launchtime;
 	s64 n;
 
 	n = div64_s64(ktime_sub_ns(now, base_time), cycle_time);
-- 
2.39.2



