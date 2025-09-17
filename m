Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EDF337EB9;
	Wed, 17 Sep 2025 12:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112986; cv=none; b=OAfNKq9ZdehuZKesIZq9M371kU8dvi3CXhgjGdjlxH25afw0jH1f5V7ndbJP2CWPNHv9UJ+unjzPkdwkFRDsBn0sWly+GhcltcmxBc3qNagJHmPPS6DIMu838lAvv3RtUiBVZGOg+FO3Y6mUxwFmmIi25C/xF0jeK8XwG20Xw1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112986; c=relaxed/simple;
	bh=t+o5DmSH//lhFndqnBKUTy9kGl1cI/79pBUwk3HSPaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p06fJUCsEu3/BPDyHKxlPZcaRw2Jm4mzW/99owXo5zDxR6CM9KltFB6xDaacBVKaLpom9zy8I4WVIfAAigHxmvfaceinfTxNVm40AqlCIcU07dvTGzgkCjUeFCe/qtX8/ama4YmNyKGGheULi7VCngJpy9yvs7PZZJfaS/GIEEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ogu8AlNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ogu8AlNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F707C4CEF0;
	Wed, 17 Sep 2025 12:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112985;
	bh=t+o5DmSH//lhFndqnBKUTy9kGl1cI/79pBUwk3HSPaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ogu8AlNCFZn2/JLtvb7DC/NENnuXMiHBkvNHzU0BBVBiev9Yca0KIz4w+Elnr1ma/
	 n9NG/Wi5UMujGw7eOSW/58PSZR47eeq0hvVbGrm5C0W10gB88UszQsTp+tlJ9neFWS
	 dQ8161LxvRPiAkxoVXVurX9a02f6sGNHq8kvtHjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 135/189] genetlink: fix genl_bind() invoking bind() after -EPERM
Date: Wed, 17 Sep 2025 14:34:05 +0200
Message-ID: <20250917123355.158949429@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 1dbfb0363224f6da56f6655d596dc5097308d6f5 ]

Per family bind/unbind callbacks were introduced to allow families
to track multicast group consumer presence, e.g. to start or stop
producing events depending on listeners.

However, in genl_bind() the bind() callback was invoked even if
capability checks failed and ret was set to -EPERM. This means that
callbacks could run on behalf of unauthorized callers while the
syscall still returned failure to user space.

Fix this by only invoking bind() after "if (ret) break;" check
i.e. after permission checks have succeeded.

Fixes: 3de21a8990d3 ("genetlink: Add per family bind/unbind callbacks")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250905135731.3026965-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/genetlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 104732d345434..978c129c60950 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1836,6 +1836,9 @@ static int genl_bind(struct net *net, int group)
 		    !ns_capable(net->user_ns, CAP_SYS_ADMIN))
 			ret = -EPERM;
 
+		if (ret)
+			break;
+
 		if (family->bind)
 			family->bind(i);
 
-- 
2.51.0



