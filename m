Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C544EB37;
	Tue, 23 Jan 2024 00:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970118; cv=none; b=EftJPCoAw7xL4DIsWdt9IZuP5iMB6qnjXhAUn2sm0vAsgbTEqRVyzfW3L1WjFLLJ0VK7N0FKsLJZiEKZBkrXmvboeMUlOiTzKEjPw1y2kAJmqp9samTO2YDUVNXUe7oAG2AmjbR86DA0+tSnVuzNpUfbWS+HGWi+dJYTM8eT6b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970118; c=relaxed/simple;
	bh=cMtuHeYhGDM8rrvuiiMNl+9vKVgm2AfDnr1NU3QPdlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2FE1GtXvI9zvVWt5tS58OMg+u1t3XOc0usmf37VnNr3+UDrkKB5x8dKWMbVEkjBm2ld5tGb5w1+QwNrbznH+TjAo0k6Kt6eA4mIQzq0Td13UZ2FTJUZUI9+oSA0InpGNMkiun82RgLcWZjdrxeeXygvJeggjgaqmj/3IZLHK94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfCJVZ9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfCJVZ9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6807DC433C7;
	Tue, 23 Jan 2024 00:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970118;
	bh=cMtuHeYhGDM8rrvuiiMNl+9vKVgm2AfDnr1NU3QPdlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfCJVZ9fYa7v0uv3rR6YmrY3Rbprgy8FltHoXPLLskr1HEOiOk2xL2NaebM5PDBDU
	 G84xED4UxMB4DZ4v8A+HwWruVqOphYqMhyeHDGjMQSbuoL/YZ4ATMMn3bE32MQjA4A
	 8DWZGHqnDffqSkpiSEW+hP+Ab5XauhgzAoK/OGIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>,
	Peter Krystad <peter.krystad@linux.intel.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang.tang@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 592/641] mptcp: strict validation before using mp_opt->hmac
Date: Mon, 22 Jan 2024 15:58:16 -0800
Message-ID: <20240122235836.740965291@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c1665273bdc7c201766c65e561c06711f2e050dc ]

mp_opt->hmac contains uninitialized data unless OPTION_MPTCP_MPJ_ACK
was set in mptcp_parse_option().

We must refine the condition before we call subflow_hmac_valid().

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Peter Krystad <peter.krystad@linux.intel.com>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Mat Martineau <martineau@kernel.org>
Cc: Geliang Tang <geliang.tang@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20240111194917.4044654-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 852b3f4af000..613bf6f1f3a0 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -788,7 +788,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 	} else if (subflow_req->mp_join) {
 		mptcp_get_options(skb, &mp_opt);
-		if (!(mp_opt.suboptions & OPTIONS_MPTCP_MPJ) ||
+		if (!(mp_opt.suboptions & OPTION_MPTCP_MPJ_ACK) ||
 		    !subflow_hmac_valid(req, &mp_opt) ||
 		    !mptcp_can_accept_new_subflow(subflow_req->msk)) {
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
-- 
2.43.0



