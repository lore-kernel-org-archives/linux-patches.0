Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EC11C7B67;
	Tue, 27 Aug 2024 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769871; cv=none; b=FgbQlGOw/SHTTGZiva/sACWr+j1lIYDJX9XLydrIGN2BVLsFFnIKiTiDqJfYr6fXoiJteW6az/rE/yEwnXuQDYc393X/SVt+3d2ucI/LpIGtxjvJCcQm3qkavPmZQaND1FoRMhr8C+wGznmt+8VUYuYuINTL9obReyFA2GVJQLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769871; c=relaxed/simple;
	bh=djJ9nNwP1TQ/i77G0jzj7V369Nxw6LgC3ECHlMrJx5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qms3JtwI8cCY+bpfdjg/XR8WcDrn79xxP9VR2Ax+EtOQc7GolqP56hllPOsq5LlRBcTOWtEegevqBuqCTNElckNy59olvaUN4mBedYdVuHPe7AjMj5bAfOPJ9OWe1w1F5j9ubLyzMLW31QK4HpN3H2r9u676ZeRoNc+1cBKCMjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/Qn7t+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/Qn7t+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE752C61068;
	Tue, 27 Aug 2024 14:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769871;
	bh=djJ9nNwP1TQ/i77G0jzj7V369Nxw6LgC3ECHlMrJx5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/Qn7t+HuKOoaRaNLHfPQA8ziPvwb2JS+3J0DLKvbcHjfnarbIaqiOCNJhHoOhB7J
	 TGjRef5Lnh944j76xOCiOrvHThdLpGK25NHpAmz1QopQgi1zbkADPbELJyVeOZC4wk
	 fW+qwwqmBi5rcv+FskfZNO4hDYCrO/IBcvbk2fYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Syromiatnikov <esyr@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/341] mptcp: correct MPTCP_SUBFLOW_ATTR_SSN_OFFSET reserved size
Date: Tue, 27 Aug 2024 16:34:52 +0200
Message-ID: <20240827143845.736876724@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Syromiatnikov <esyr@redhat.com>

[ Upstream commit 655111b838cdabdb604f3625a9ff08c5eedb11da ]

ssn_offset field is u32 and is placed into the netlink response with
nla_put_u32(), but only 2 bytes are reserved for the attribute payload
in subflow_get_info_size() (even though it makes no difference
in the end, as it is aligned up to 4 bytes).  Supply the correct
argument to the relevant nla_total_size() call to make it less
confusing.

Fixes: 5147dfb50832 ("mptcp: allow dumping subflow context to userspace")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240812065024.GA19719@asgard.redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/diag.c b/net/mptcp/diag.c
index 7017dd60659dc..b2199cc282384 100644
--- a/net/mptcp/diag.c
+++ b/net/mptcp/diag.c
@@ -95,7 +95,7 @@ static size_t subflow_get_info_size(const struct sock *sk)
 		nla_total_size(4) +	/* MPTCP_SUBFLOW_ATTR_RELWRITE_SEQ */
 		nla_total_size_64bit(8) +	/* MPTCP_SUBFLOW_ATTR_MAP_SEQ */
 		nla_total_size(4) +	/* MPTCP_SUBFLOW_ATTR_MAP_SFSEQ */
-		nla_total_size(2) +	/* MPTCP_SUBFLOW_ATTR_SSN_OFFSET */
+		nla_total_size(4) +	/* MPTCP_SUBFLOW_ATTR_SSN_OFFSET */
 		nla_total_size(2) +	/* MPTCP_SUBFLOW_ATTR_MAP_DATALEN */
 		nla_total_size(4) +	/* MPTCP_SUBFLOW_ATTR_FLAGS */
 		nla_total_size(1) +	/* MPTCP_SUBFLOW_ATTR_ID_REM */
-- 
2.43.0



