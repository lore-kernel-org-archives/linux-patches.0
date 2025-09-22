Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4752191F66;
	Mon, 22 Sep 2025 19:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569703; cv=none; b=YzGDWB46ZrqfuBixpJ+dXNi2js01CV/VAzVGcyp4kFYlNyGHziYhnf3rayvFJC4IK0HTKzDyEkxnM/aD+ezIlsH4RfZ0ePmMnwKs6It5rd0iLV/1l6YaFx+xeQPwYEGyS93PjpQbBnXmxRqg4IBzfS4CmxsMJ2/0b8DE5XZJzwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569703; c=relaxed/simple;
	bh=8fV8eqKqtfjGuqKVdumJvrnq9Z2a6s5EiZaZbAA0ecw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqlGH4bdRaUdCqVeqPYt8d3beUBBeGQGHPArR9qgh+dPKD6XHJp4MvbJH3zK/bhHVr8/x2/sSImw3dzquxXVW8cruMB6c2egcYrkW+A339cBkGS9quCFUkrMgVsF1ybTG1JgIoyc9iKw9kJTnzVzQR1RY/cBdjvewPW8wyM7QZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdHgkEMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdHgkEMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E07C4CEF0;
	Mon, 22 Sep 2025 19:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569703;
	bh=8fV8eqKqtfjGuqKVdumJvrnq9Z2a6s5EiZaZbAA0ecw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdHgkEMSqGyNoxN04ODZ/1MsRhe+l3Qnj72+BhALbnbbVOFVsiqtGLPac23Vmyfbx
	 kns1c3y8gz72bKg3GPtSAH8dPjtZxoloH4Zblv/SM4MtBUsKDj7NAICt/QwcuxN1YW
	 H/cKZKxw6aMx3Fl2ZrudZCjGPwpecW6XDMGcrK4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 13/70] mptcp: tfo: record deny join id0 info
Date: Mon, 22 Sep 2025 21:29:13 +0200
Message-ID: <20250922192404.869973822@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 92da495cb65719583aa06bc946aeb18a10e1e6e2 ]

When TFO is used, the check to see if the 'C' flag (deny join id0) was
set was bypassed.

This flag can be set when TFO is used, so the check should also be done
when TFO is used.

Note that the set_fully_established label is also used when a 4th ACK is
received. In this case, deny_join_id0 will not be set.

Fixes: dfc8d0603033 ("mptcp: implement delayed seq generation for passive fastopen")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250912-net-mptcp-pm-uspace-deny_join_id0-v1-4-40171884ade8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 9406d2d555e74..b245abd08c824 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -985,13 +985,13 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 		return false;
 	}
 
-	if (mp_opt->deny_join_id0)
-		WRITE_ONCE(msk->pm.remote_deny_join_id0, true);
-
 	if (unlikely(!READ_ONCE(msk->pm.server_side)))
 		pr_warn_once("bogus mpc option on established client sk");
 
 set_fully_established:
+	if (mp_opt->deny_join_id0)
+		WRITE_ONCE(msk->pm.remote_deny_join_id0, true);
+
 	mptcp_data_lock((struct sock *)msk);
 	__mptcp_subflow_fully_established(msk, subflow, mp_opt);
 	mptcp_data_unlock((struct sock *)msk);
-- 
2.51.0



