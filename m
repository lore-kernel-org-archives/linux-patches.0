Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBB435F1D;
	Fri, 24 Nov 2023 18:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EefN3Egc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF860C433C8;
	Fri, 24 Nov 2023 18:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851259;
	bh=yLblB/YDXiwGMfw3e/fLBBkKVWOJOvx1oQs6CEQ8+GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EefN3EgcoW1xcLAdWMwZ26DOdwW51NkBq63xGXT59cCdzr+5/xBXYQAWSTpIFTWIv
	 ubqVAtKojRBQq4E4HiCRsZoHKNomlpXqtumExWjxso/AC4cdPTLnO59x8OeiQoxF84
	 dMBULlknd/dU1RRc9soJ+6yISqCzZWjYLpwazrr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 376/491] torture: Move stutter_wait() timeouts to hrtimers
Date: Fri, 24 Nov 2023 17:50:12 +0000
Message-ID: <20231124172035.890108520@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 10af43671e8bf4ac153c4991a17cdf57bc6d2cfe ]

In order to gain better race coverage, move the test start/stop
waits in stutter_wait() to torture_hrtimeout_jiffies().

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: cca42bd8eb1b ("rcutorture: Fix stuttering races and other issues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/torture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index 4a2e0512f9197..a55cb70b192fc 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -734,7 +734,7 @@ bool stutter_wait(const char *title)
 			ret = true;
 		}
 		if (spt == 1) {
-			schedule_timeout_interruptible(1);
+			torture_hrtimeout_jiffies(1, NULL);
 		} else if (spt == 2) {
 			while (READ_ONCE(stutter_pause_test)) {
 				if (!(i++ & 0xffff))
@@ -742,7 +742,7 @@ bool stutter_wait(const char *title)
 				cond_resched();
 			}
 		} else {
-			schedule_timeout_interruptible(round_jiffies_relative(HZ));
+			torture_hrtimeout_jiffies(round_jiffies_relative(HZ), NULL);
 		}
 		torture_shutdown_absorb(title);
 	}
-- 
2.42.0



