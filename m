Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C41A14290C;
	Sun,  1 Sep 2024 16:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207905; cv=none; b=m6h3968klWFXKW3RyYB7/5icNoBSDkZ0sLGi/VWnYZ1d0jBzLHDNaQerbCRvkOTxwOYkRwGNM9Q/ry4/F1Da8UiRH3+2RUHq1/b2B1hjtlzTDiKYJ2MHCMMF3o+DyQFcs5GN2wPaPAf8QXcz4hnxO/oslaxmcieRs+zeldzPsJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207905; c=relaxed/simple;
	bh=a8VWYZerN+wAUKI8xaIntN+QXrh1YXcmQQKeIbBnwM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdhElisDQTDe7iu8Whc25W7IaAfJHyUVJfMjteJYhmhLIcngfm+75lCo8hIn9xcKkKgPJowmW6tvGzLcOrFD1tfArMo+IrJgZpvTqVdmVMeZc3QKzpdrjkJ92lY28GM4SSdA36zDpnrDRdrCoZuSq+qBQXOnimJRhNXAEDdvqaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQQS9tPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQQS9tPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0483C4CEC3;
	Sun,  1 Sep 2024 16:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207905;
	bh=a8VWYZerN+wAUKI8xaIntN+QXrh1YXcmQQKeIbBnwM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQQS9tPe2sRsjiAAaZDJB+bK/fYjvMRakxaa0FgpSkJdP7zb7A+0Qk54Po32pcFX9
	 3gy/QOq2XmI4zU/+p1sCylWQxNJvp2lJ8RJ9d7VinMuhEjQZwqo6kylHVXnTtLdo/4
	 tnitNuH4rlF4PNUI6tDAYdRdY3kJPvjnm8YPUdCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 14/93] mptcp: pm: reuse ID 0 after delete and re-add
Date: Sun,  1 Sep 2024 18:16:01 +0200
Message-ID: <20240901160807.895470744@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 8b8ed1b429f8fa7ebd5632555e7b047bc0620075 upstream.

When the endpoint used by the initial subflow is removed and re-added
later, the PM has to force the ID 0, it is a special case imposed by the
MPTCP specs.

Note that the endpoint should then need to be re-added reusing the same
ID.

Fixes: 3ad14f54bd74 ("mptcp: more accurate MPC endpoint tracking")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -593,6 +593,11 @@ static void mptcp_pm_create_subflow_or_s
 
 		__clear_bit(local.addr.id, msk->pm.id_avail_bitmap);
 		msk->pm.add_addr_signaled++;
+
+		/* Special case for ID0: set the correct ID */
+		if (local.addr.id == msk->mpc_endpoint_id)
+			local.addr.id = 0;
+
 		mptcp_pm_announce_addr(msk, &local.addr, false);
 		mptcp_pm_nl_addr_send_ack(msk);
 
@@ -617,6 +622,11 @@ subflow:
 
 		msk->pm.local_addr_used++;
 		__clear_bit(local.addr.id, msk->pm.id_avail_bitmap);
+
+		/* Special case for ID0: set the correct ID */
+		if (local.addr.id == msk->mpc_endpoint_id)
+			local.addr.id = 0;
+
 		nr = fill_remote_addresses_vec(msk, &local.addr, fullmesh, addrs);
 		if (nr == 0)
 			continue;


