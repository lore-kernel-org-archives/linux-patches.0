Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A74832340B;
	Wed, 17 Sep 2025 12:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113478; cv=none; b=REy3xqs/29AO2lYdcAwc6Lrv0S9hgqIGpL5m67EE3UyG0bJVar00+YJIWq0DX5nY8W+Ka2laZg//6V4t5Y4AxoJseiQomJ+hg/+h/voxhJ8fuor9GAoG+vir6v1dz4M3KZuiDU9BJyAgAqo23t5sYUd2og/zQ4DGvCOO+aw6sWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113478; c=relaxed/simple;
	bh=j7nP8tIrHTAT3NbfIyww5ZWPS4wE8g3ET0DNNaHVeZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ib7L4fFlOAtdc2md2OVfro2gcD8SSSKlEITtJhDamCe7vhCrn3MH9KmFT0PBJEbG5Ztw+wG6mmdlsQBrWYHTk+MR/tiTA0GOLDc6KwGOa4QUKjsN7H4uCICHAfziJxuafJcldpyFIs4/WwSMpczIrckUni+I2YoeASFwUxZGwIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTA7GI50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTA7GI50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87757C4CEF5;
	Wed, 17 Sep 2025 12:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113478;
	bh=j7nP8tIrHTAT3NbfIyww5ZWPS4wE8g3ET0DNNaHVeZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTA7GI50vmZydxzusdJrJx3f1BakE2SKJmmjGNEtrXdtFhaywN3SZ4LqHFvb/vxPp
	 cm0uqs1E4sWMQTavGAXbUiaCPD4UuPPqiO+UMLCfNWGfHy5V89NTtAjodlNkRsoBJ8
	 jb5i8rHWjgbY14Seetd7TYpTy7+pa5cm8SGujtrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/140] net: bridge: Bounce invalid boolopts
Date: Wed, 17 Sep 2025 14:34:30 +0200
Message-ID: <20250917123346.698879825@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 8625f5748fea960d2af4f3c3e9891ee8f6f80906 ]

The bridge driver currently tolerates options that it does not recognize.
Instead, it should bounce them.

Fixes: a428afe82f98 ("net: bridge: add support for user-controlled bool options")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/e6fdca3b5a8d54183fbda075daffef38bdd7ddce.1757070067.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 2cab878e0a39c..ed08717541fe7 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -312,6 +312,13 @@ int br_boolopt_multi_toggle(struct net_bridge *br,
 	int err = 0;
 	int opt_id;
 
+	opt_id = find_next_bit(&bitmap, BITS_PER_LONG, BR_BOOLOPT_MAX);
+	if (opt_id != BITS_PER_LONG) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Unknown boolean option %d",
+				       opt_id);
+		return -EINVAL;
+	}
+
 	for_each_set_bit(opt_id, &bitmap, BR_BOOLOPT_MAX) {
 		bool on = !!(bm->optval & BIT(opt_id));
 
-- 
2.51.0



