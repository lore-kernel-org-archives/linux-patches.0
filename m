Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207401BFE07;
	Tue, 27 Aug 2024 15:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771677; cv=none; b=XxL/cbkVeO/wk9grVqz28zaQo7896rfRSPNBtuJ53L6wREaFkV1rl9ichY2CsNHWa8AVKQ8mJtX36N5G/A9Pg0xytcNlmjqFU1KwIgq6b/Qy7OaT4RKdXvusoo3X03Lu6GFR0HOOMldkt+nfw3Y9AW8qKTAYQ1dyvsl/+Vi2o4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771677; c=relaxed/simple;
	bh=IDvCGFpXLrrgYIjl4CZJsP8w1Q3uGWyvPSlGxg44LSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSQn5dzxJEhdi5hXJkZRqGsyO4AM5XfmsFtRilsLX0vkmoto3wREJ0pTMF3ij6gw4+/3uXaqxVCRfjkpvpBeC6ER+pRDVB8kWtYKoG61G52dEn8AUapRUPoRI90G9JiiGFKStM+VuSkyr2O5h7WS0L+BbzsJ2HzkAnBFs/QeLbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWg+GTvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWg+GTvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96657C61064;
	Tue, 27 Aug 2024 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771677;
	bh=IDvCGFpXLrrgYIjl4CZJsP8w1Q3uGWyvPSlGxg44LSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWg+GTvU7dcJaC8nqCL1aH5xLUD4nON1q0/X11ovCzYopmin/jb0dDS4vQJ0n4PgU
	 6Kdq/jI4wiU4NCG6XXsjVhiCuSD6OB784gMMtZ6wnq4vaAcNWNKKu5FfKkNalCWyyo
	 E1LimGtgvNDu0bnD0CvJMtiroIGIGGohnQBOn5MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 260/273] mptcp: pm: only decrement add_addr_accepted for MPJ req
Date: Tue, 27 Aug 2024 16:39:44 +0200
Message-ID: <20240827143843.293425543@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 1c1f721375989579e46741f59523e39ec9b2a9bd upstream.

Adding the following warning ...

  WARN_ON_ONCE(msk->pm.add_addr_accepted == 0)

... before decrementing the add_addr_accepted counter helped to find a
bug when running the "remove single subflow" subtest from the
mptcp_join.sh selftest.

Removing a 'subflow' endpoint will first trigger a RM_ADDR, then the
subflow closure. Before this patch, and upon the reception of the
RM_ADDR, the other peer will then try to decrement this
add_addr_accepted. That's not correct because the attached subflows have
not been created upon the reception of an ADD_ADDR.

A way to solve that is to decrement the counter only if the attached
subflow was an MP_JOIN to a remote id that was not 0, and initiated by
the host receiving the RM_ADDR.

Fixes: d0876b2284cf ("mptcp: add the incoming RM_ADDR support")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-9-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -829,7 +829,7 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			mptcp_close_ssk(sk, ssk, subflow);
 			spin_lock_bh(&msk->pm.lock);
 
-			removed = true;
+			removed |= subflow->request_join;
 			if (rm_type == MPTCP_MIB_RMSUBFLOW)
 				__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
@@ -843,7 +843,11 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 		if (!mptcp_pm_is_kernel(msk))
 			continue;
 
-		if (rm_type == MPTCP_MIB_RMADDR) {
+		if (rm_type == MPTCP_MIB_RMADDR && rm_id &&
+		    !WARN_ON_ONCE(msk->pm.add_addr_accepted == 0)) {
+			/* Note: if the subflow has been closed before, this
+			 * add_addr_accepted counter will not be decremented.
+			 */
 			msk->pm.add_addr_accepted--;
 			WRITE_ONCE(msk->pm.accept_addr, true);
 		}


