Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D8460252;
	Tue, 23 Jan 2024 00:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970882; cv=none; b=Ezyh4yPgAiHQS373ebZ/0Kseo/mz+qqF142oc9aBjNDNR1W4+SmC7GKSM4VjY5v8Lozoxowh06Wa9YajGqxWPefH+yQ899Hd334uafYsxAe8AjDOiRfGJ6JvbXOujETj7fxJptKz0jiRk9mRdja6nu0LaY7qXczAEh4tRz8Nevg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970882; c=relaxed/simple;
	bh=SElfri2iPavq4ZeMm96DSfWrveNz1ijSIY+D9hn77Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8mfkRILUS1ik9DSyWsUORd4J4wb6ttqlmhyAAKY2dzAyBi20JWwpq5o4pyxrLOb8xqVE6hohVf051vVDVjZzoMldgDAocSJzOeLJg9vzPiU1+iGAHj+DhdBNCtKQ2dcpxp7NHt3x3FO6GBk21mDotcDVo/oQQwbbYJ0enFwVEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nziC/fyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nziC/fyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51A5C433C7;
	Tue, 23 Jan 2024 00:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970881;
	bh=SElfri2iPavq4ZeMm96DSfWrveNz1ijSIY+D9hn77Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nziC/fyDH4dxJHdAxq9GMjJXNv9hiExvCg6F29YPD72ONM/DFNCpCQ9m1rfpZBDBK
	 47jtE43GJAzmxrO5AL7ahjb/JGL+LhCu0uKMtCI4ETk/s8Dqol5kFxNkKDveXAL7T9
	 c+Vq8ms//lF3FL+b4dpU2NLoc6CtlcvMOIHF5av8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarannya Sasikumar <quic_sarannya@quicinc.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/286] net: qrtr: ns: Return 0 if server port is not present
Date: Mon, 22 Jan 2024 15:55:43 -0800
Message-ID: <20240122235733.442062972@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarannya S <quic_sarannya@quicinc.com>

[ Upstream commit 9bf2e9165f90dc9f416af53c902be7e33930f728 ]

When a 'DEL_CLIENT' message is received from the remote, the corresponding
server port gets deleted. A DEL_SERVER message is then announced for this
server. As part of handling the subsequent DEL_SERVER message, the name-
server attempts to delete the server port which results in a '-ENOENT' error.
The return value from server_del() is then propagated back to qrtr_ns_worker,
causing excessive error prints.
To address this, return 0 from control_cmd_del_server() without checking the
return value of server_del(), since the above scenario is not an error case
and hence server_del() doesn't have any other error return value.

Signed-off-by: Sarannya Sasikumar <quic_sarannya@quicinc.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 713e9940d88b..c92dd960bfef 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -577,7 +577,9 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
 	if (!node)
 		return -ENOENT;
 
-	return server_del(node, port, true);
+	server_del(node, port, true);
+
+	return 0;
 }
 
 static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
-- 
2.43.0



