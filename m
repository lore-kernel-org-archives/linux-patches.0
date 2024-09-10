Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA42C18C912;
	Tue, 10 Sep 2024 10:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963617; cv=none; b=TTiSFN4iOLf1GPOA5QF0ky1XvJhcMqSCzToAQ4zzCQEt2BbUFYgFkdtSgt81Z91wofg8QbEy2m+LK28FTxHoA6BVZgfWILYRBGYTiO2ibVo9JSVQs8RzJ5TrSTTOq0M/YC9cM+UnXNdR6e2hJl2HTcjccM3zNt940Tj6KQfRxEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963617; c=relaxed/simple;
	bh=oADWI6QrmYvz/y3HROx12Bybrq47iVZGQ3uhNw2MPyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5LP1gyXlPEZs0wL+zsMJ+adgV5ZoKzygHyQ/4elPGo0Uh9uJNL+CwOOOCjyRaIPrGuMeGwlQT5Q7pylW/BWD9HRIX1a+kxE8y49OOuwa388fTjYs/KjcG66n9Y+GwoYGQ/X7OCiMW4jIJqMKNkngL7ZbErL9f/nuG3hFw32IV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtN6bEfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtN6bEfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EADC4CECD;
	Tue, 10 Sep 2024 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963617;
	bh=oADWI6QrmYvz/y3HROx12Bybrq47iVZGQ3uhNw2MPyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtN6bEfCHHjB/SQpoImXyRBkUI3xXIQ5LbqWzn00WXkpib+/0omIeURxLp7EIBqzd
	 eBcdxwv8YTb5zrOCfrlvbeLMzPGut4FWynEkU2BHEeXSI9xPs3F0cLja/GuO+RS992
	 1+lKu62aowDUwAXHVehxui10E3tBGKsVFGqzhKoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 092/214] mptcp: pm: check add_addr_accept_max before accepting new ADD_ADDR
Date: Tue, 10 Sep 2024 11:31:54 +0200
Message-ID: <20240910092602.535782669@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 0137a3c7c2ea3f9df8ebfc65d78b4ba712a187bb upstream.

The limits might have changed in between, it is best to check them
before accepting new ADD_ADDR.

Fixes: d0876b2284cf ("mptcp: add the incoming RM_ADDR support")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-10-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in pm_netlink.c, because the context is different, but the
  same lines can still be modified to fix the issue. This is due to
  commit 322ea3778965 ("mptcp: pm: only mark 'subflow' endp as
  available") not being backported to this version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -772,8 +772,8 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			/* Note: if the subflow has been closed before, this
 			 * add_addr_accepted counter will not be decremented.
 			 */
-			msk->pm.add_addr_accepted--;
-			WRITE_ONCE(msk->pm.accept_addr, true);
+			if (--msk->pm.add_addr_accepted < mptcp_pm_get_add_addr_accept_max(msk))
+				WRITE_ONCE(msk->pm.accept_addr, true);
 		} else if (rm_type == MPTCP_MIB_RMSUBFLOW) {
 			msk->pm.local_addr_used--;
 		}


