Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98141334C1E;
	Thu, 27 Nov 2025 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255986; cv=none; b=mWb06ATusn00lPy3iocA7zHv3ozh9C+5uRNduVun1BPhhEG+kFjlYzbdtq5pi7eSsuH+dGWYmUjGrJh6rzLhar9RPyokE0RDnUPG4Nim8CHPDtzmEO8d400vAx8ZvkeKa6RXL4kDf1MGa0KHfXZejfAkm5QAGTiDR9LhHXy4Oj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255986; c=relaxed/simple;
	bh=OIB/tNOlfDzmzKtYwVWArpaWy4yyI2Co3EcN32jyRrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSaHtJlUE9fnSw4Chfr8TiheXdwvLeQ/9FGd/0PsQg/acOCIWrLfgFlMqhN5Yg/+UGuuXp/MA1AgAMTGYj6lja8Xc4ZKo/9GwG+jxsI7zjVOQ5MJLwDGjU1gCIGHz0hKYdcFUrRz6tvSfG+iRX+lJCgCquMOTcM7rGOWiqv+bqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Htqj+pn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Htqj+pn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20794C113D0;
	Thu, 27 Nov 2025 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255986;
	bh=OIB/tNOlfDzmzKtYwVWArpaWy4yyI2Co3EcN32jyRrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Htqj+pn7+PCybs17FVbpFGkY77PJnBvVuyD4nhqLks8IwI087cfSRoS5WJCvJiDir
	 UZtxDiYjm7UH0it6LizlNC208RUxt0FN7kbSSUyTZDd5XMxu0ZWCRYZ/eqjQMnvPii
	 x0237ipmHMn3ALztnTDbzlgMzZrj6wu5gYCGZO6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 168/175] mptcp: fix address removal logic in mptcp_pm_nl_rm_addr
Date: Thu, 27 Nov 2025 15:47:01 +0100
Message-ID: <20251127144049.090690213@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gang Yan <yangang@kylinos.cn>

[ Upstream commit 92e239e36d600002559074994a545fcfac9afd2d ]

Fix inverted WARN_ON_ONCE condition that prevented normal address
removal counter updates. The current code only executes decrement
logic when the counter is already 0 (abnormal state), while
normal removals (counter > 0) are ignored.

Signed-off-by: Gang Yan <yangang@kylinos.cn>
Fixes: 636113918508 ("mptcp: pm: remove '_nl' from mptcp_pm_nl_rm_addr_received")
Cc: stable@vger.kernel.org
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-10-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_kernel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/pm_kernel.c
+++ b/net/mptcp/pm_kernel.c
@@ -548,7 +548,7 @@ static void mptcp_pm_nl_add_addr_receive
 
 void mptcp_pm_nl_rm_addr(struct mptcp_sock *msk, u8 rm_id)
 {
-	if (rm_id && WARN_ON_ONCE(msk->pm.add_addr_accepted == 0)) {
+	if (rm_id && !WARN_ON_ONCE(msk->pm.add_addr_accepted == 0)) {
 		/* Note: if the subflow has been closed before, this
 		 * add_addr_accepted counter will not be decremented.
 		 */


