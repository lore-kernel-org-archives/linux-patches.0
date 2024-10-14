Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F347A1AE850;
	Mon, 14 Oct 2024 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919051; cv=none; b=ZNJ+zuTOAoHTiUY6/lH5DePwisURmJwAQJd1jd3Hc2p2ex/7qv6ykOZiqqt8ETkHMZ61FZ/yMnYpUPWtAESYlHJJBjWW61WRkXlkdfs/aLANDIUylebeGMIftKOUngrhxI7auAfJGrGrwMPD6Ws+oDcEhy3mJm0h6oUtdHHlzgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919051; c=relaxed/simple;
	bh=KJZr3gp5HfNoeX819npzsm8qCejg5zEZXk7KH9p/UDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyMZ6Xi4q4c6ARlzCvxka1YlFo69ipJBiJOuX5qLcHVsLDHC8fP8loOuUFmgoMfYm6Y2NJj1w9id1nHbyjYlG+gGW2EThiUZRgqfnVBt8xhVJnHhknMdArFBfM0E+EFvPaVP96jvbJ1GxTKFFtBP6hs+gP4UzwQVDx8tgBc+qPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkz4uKtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkz4uKtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7240AC4CED0;
	Mon, 14 Oct 2024 15:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919050;
	bh=KJZr3gp5HfNoeX819npzsm8qCejg5zEZXk7KH9p/UDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkz4uKtXBXnkFW8FQJ+24snAahOnhsB8IyDsXO3VT9kraRZxTKaGoWWJiBTC2PNwY
	 TCUKCpv2k4uiF5TML4uV0zXp+JjnsaWWUcI9IVm7esdXI0UMCys3BVnbgQENXxOSyP
	 SOFASs9Jw0J7wt2pG4fZZS/ZNMhP5Kx0doOs7fBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 467/798] rcuscale: Provide clear error when async specified without primitives
Date: Mon, 14 Oct 2024 16:17:01 +0200
Message-ID: <20241014141236.322295130@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 11377947b5861fa59bf77c827e1dd7c081842cc9 ]

Currently, if the rcuscale module's async module parameter is specified
for RCU implementations that do not have async primitives such as RCU
Tasks Rude (which now lacks a call_rcu_tasks_rude() function), there
will be a series of splats due to calls to a NULL pointer.  This commit
therefore warns of this situation, but switches to non-async testing.

Signed-off-by: "Paul E. McKenney" <paulmck@kernel.org>
Signed-off-by: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcuscale.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/rcuscale.c b/kernel/rcu/rcuscale.c
index 0b88d96511adc..6595e166f6d59 100644
--- a/kernel/rcu/rcuscale.c
+++ b/kernel/rcu/rcuscale.c
@@ -449,7 +449,7 @@ rcu_scale_writer(void *arg)
 			udelay(writer_holdoff);
 		wdp = &wdpp[i];
 		*wdp = ktime_get_mono_fast_ns();
-		if (gp_async) {
+		if (gp_async && !WARN_ON_ONCE(!cur_ops->async)) {
 retry:
 			if (!rhp)
 				rhp = kmalloc(sizeof(*rhp), GFP_KERNEL);
@@ -505,7 +505,7 @@ rcu_scale_writer(void *arg)
 			i++;
 		rcu_scale_wait_shutdown();
 	} while (!torture_must_stop());
-	if (gp_async) {
+	if (gp_async && cur_ops->async) {
 		cur_ops->gp_barrier();
 	}
 	writer_n_durations[me] = i_max + 1;
-- 
2.43.0



