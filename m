Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D87813D28F;
	Thu,  5 Sep 2024 10:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530407; cv=none; b=B2HV7mwEcqLtEe8Fnl8/6X443yXonNs59lMpYFB5u50CdJE5VPvZitoY86X/rQfW0Q4d62PcFquMnZX/tVxJ748xp/6OcYoVrT6VFeSMXzc/Gdq9LLaO91ojaweMTxWLMd7KntC5bsnl51N3Eg5Q8WPRmMe643md5tRNneVOPXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530407; c=relaxed/simple;
	bh=Y0L8DoOll6yYiw67GWVc8APDuN9XHpbTdOVU5AVVYP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEkZ0YQ1KKaR5SxHcLJ6cQg+Yf36+C2xHXHfAz//HFK4K59r7aocEe4afe/7dqpz66kPdnivu7Ov+kQGpt42MsDQQXqW/duJDljMD83NbJQXDhN0kxmLv1x44d5nrvm4NjjAHVqgaQFjhOEdFsa5F2Q0MfS/Jww1Foh41mUd+u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMtneEwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMtneEwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE822C4CEC3;
	Thu,  5 Sep 2024 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530407;
	bh=Y0L8DoOll6yYiw67GWVc8APDuN9XHpbTdOVU5AVVYP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMtneEwYSM2ErJEQbWr5Jcy+ZJaqyfUz+rgGUsEsyPLtIZJlviRkgJPzQ7CDavgtv
	 FCIODQ3OJqRA7IVYQwiFcPFCzalT1kTbFUaXhI+bu49z+LvjS2k0+S1MHLaKBKRpoc
	 UImaQqI7WhC/WuQrXF5SAHAcL0BEdnvKPBkbSFBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 015/101] mptcp: pm: reuse ID 0 after delete and re-add
Date: Thu,  5 Sep 2024 11:40:47 +0200
Message-ID: <20240905093716.692635725@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

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
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -600,6 +600,11 @@ static void mptcp_pm_create_subflow_or_s
 
 		__clear_bit(local.addr.id, msk->pm.id_avail_bitmap);
 		msk->pm.add_addr_signaled++;
+
+		/* Special case for ID0: set the correct ID */
+		if (local.addr.id == msk->mpc_endpoint_id)
+			local.addr.id = 0;
+
 		mptcp_pm_announce_addr(msk, &local.addr, false);
 		mptcp_pm_nl_addr_send_ack(msk);
 
@@ -624,6 +629,11 @@ subflow:
 
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


