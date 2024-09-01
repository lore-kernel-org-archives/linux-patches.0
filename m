Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88558186E33;
	Sun,  1 Sep 2024 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209184; cv=none; b=RqQCIV6ZBmC65GI6kDdq7nsxVTK1d9cDlmeVqZjoHI59pCafM7KdOKJCx1h7mMu5Ui39Lv530Sy1QXdSj3yCea9IDo6RUtZAuWCEmrX9GjaTVijI0tsIRGvK87IZz2NFhsqAZ6q+Q42uGYDkF3NgZdcMkxaEJj98CUsHJVzwRRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209184; c=relaxed/simple;
	bh=IOfidqnWUEikfE0RvVPwLVAW8Ybr7sFfCGWjvwRw/N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtSkaklm736q/8RS5yrzKaXEgeqeGspn2JTWL2tlHapPGMSMBLeZotvHfzAv1gKJER9A5Mbkxb06asj8VUKZfAM/qIgLqqvfTCJxlgN5pPqw5anfoVgQRcuzOm4ILZVkInKzfksy4ZeMzanu8UdubQswkgQxlw3mmARXLXN5dCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtLJ4bTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtLJ4bTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E07C4CEC3;
	Sun,  1 Sep 2024 16:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209184;
	bh=IOfidqnWUEikfE0RvVPwLVAW8Ybr7sFfCGWjvwRw/N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtLJ4bTTGG8R/waLDMaUp6FcqKnaf64t2YgaQYktDn8e06C8bLrq/dg3UIl+f+xZ0
	 6cbarU0LeIND17MYRIG4Qlp8FYTHEh7/OTkOcIxFbgx3wlOowl3te+S60Bc3Ykt2QO
	 MbUeUQ+pSnUpAAeewp/b2M6y7JAZ+oF0b4GcCmgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/71] mptcp: pm: check add_addr_accept_max before accepting new ADD_ADDR
Date: Sun,  1 Sep 2024 18:17:32 +0200
Message-ID: <20240901160802.914894334@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 0137a3c7c2ea3f9df8ebfc65d78b4ba712a187bb ]

The limits might have changed in between, it is best to check them
before accepting new ADD_ADDR.

Fixes: d0876b2284cf ("mptcp: add the incoming RM_ADDR support")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-10-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index d546e17063f75..9e16ae1b23fc7 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -870,8 +870,8 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 			/* Note: if the subflow has been closed before, this
 			 * add_addr_accepted counter will not be decremented.
 			 */
-			msk->pm.add_addr_accepted--;
-			WRITE_ONCE(msk->pm.accept_addr, true);
+			if (--msk->pm.add_addr_accepted < mptcp_pm_get_add_addr_accept_max(msk))
+				WRITE_ONCE(msk->pm.accept_addr, true);
 		}
 	}
 }
-- 
2.43.0



