Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E045F222590;
	Mon, 22 Sep 2025 19:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570156; cv=none; b=ebLPeVsbV/+qsQRXZoaD0vuz+zFGIMFdMpLE8V3bqzyfxThFCO9Rbp6SN76FeyS2Hq8eopcNrdrio1F4WG7O40iWRxx/ja03WXYNsuVeOJQQl7ToO4niP2jykzkThWitJxWv4yrIblIskS6E0GfHqXHFGeXe7CvGtvmayAeQlck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570156; c=relaxed/simple;
	bh=T4+P7H3ZkWZCtcb9sXwbcoto/fg0kf5wU8uMkSF8Y7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sutnUWRk59tOMYJuwq/+WHDGWZzuj1QZuJycE4JruT7OwYjhncHN3htc83JkuQamQDTmCh0NtfO+gJX4lUIw4SqjXrTpQBkOpfSUDS3mDMwAOZH3pjefXmGFR6T97o03pWgd/o5UEwuKt088hIMPu+zKZrlGwX5O1thF3gmu6zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsWti65n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsWti65n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A69C4CEF0;
	Mon, 22 Sep 2025 19:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570155;
	bh=T4+P7H3ZkWZCtcb9sXwbcoto/fg0kf5wU8uMkSF8Y7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsWti65njXfx8pSoPx3hfXsm7TdohCBXnI7HzOml6GcUkkndsZkPxAC+8jk7k4e2m
	 VVau0Pyt3s04a8lxtAI7jv3JKHnQsO/D4ELLk6zJ3XkWczL5311S1fJGBiocBo4ZkH
	 xaBTaLf2nF4kgZkEeQfyKJlLdJQoImZ5nZZh6RYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 027/149] mptcp: tfo: record deny join id0 info
Date: Mon, 22 Sep 2025 21:28:47 +0200
Message-ID: <20250922192413.552975538@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index c6983471dca55..bb4253aa675a6 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -984,13 +984,13 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
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



