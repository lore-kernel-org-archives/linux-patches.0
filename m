Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39E3376EC;
	Sun,  1 Sep 2024 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210020; cv=none; b=DeqL0jncokTheJGH4e2B8qez3NhZfcwbLNddDCwHPm/YbXBqCN/3pDI+yzy/qEikQfc9B4UbkfLsyq/UQzF00FX3hFMOmprfk+48gThPQb7safsIN0EldMjEDVynCPSo6Th/gaTFJP16/uJneh0WH8/YcRgBWocFbQFU5dBedqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210020; c=relaxed/simple;
	bh=PXQ378gtcXV7rMMOJ6772iLeNxeAWVIOFZPYrVgT/8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAq2NRm7SfzJXud9UMWdHnylc7i4kkuq5yGjeMa9ghVqg9BSQbD8SCHvB1N8GXh0W3Jy37JyVBkUXE5c1LI/2CY64o46fT3g9PBymVvFir1PvHava3EZJqdMf2HfMSSgxIQ2zTntQCd9vF9goKAEHypaIKpob7iLTb8gYdBarJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o09glSa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o09glSa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B91C4CEC3;
	Sun,  1 Sep 2024 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210020;
	bh=PXQ378gtcXV7rMMOJ6772iLeNxeAWVIOFZPYrVgT/8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o09glSa45Cr6Ya3kRWdiXTlPkjMLsLweffFiEs77unZ95r4+JYQ/h7thMfIf7ErBs
	 /mAOb3yYvz0Wa5frV6RCTJ18QMCFm7Qge2mFBUs2a3VC6fbhqh13FGYAlrSyu56xf/
	 qYTl5TXfqGmMsosvHUH7gHIbAH3uIbawKH7CBDPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Syromiatnikov <esyr@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/215] mptcp: correct MPTCP_SUBFLOW_ATTR_SSN_OFFSET reserved size
Date: Sun,  1 Sep 2024 18:15:48 +0200
Message-ID: <20240901160824.710618166@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index d7ca71c597545..23bd18084c8a2 100644
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



