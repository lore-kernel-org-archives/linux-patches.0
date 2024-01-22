Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABBA1339A7;
	Tue, 23 Jan 2024 01:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972121; cv=none; b=sRX+4AkIdB9lCJBj8qEcdraRiU80+51WkZ1oZ8Y9iCPAVD4vFVMIHpQ7ZcvHU8IHK3jFCTcgXRUXo3Z6AEUg+M0WmpZdFl43rLHn4IDGrCiZOqFLGH8C4uTtoFB9iU2d5jh1MBjZXdMX7TRvp1hAW+68Xez5/b11alNHE9N30dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972121; c=relaxed/simple;
	bh=gUPOWLOZe+rrlWCruekLxC+yYxAmeBx7dd/mWw9XnLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPKh7Ci5y/khRYXbaVVlNDOvzXUwdbwDlJjuRT6pT0e2Jwwe9D9p770WdNL25xDwaGg+c55h2yofO2h5vQZJG1JHWbXjdSYNow/rGZypHNon7aW7e+8DddjX0H55C0d7erCiFQwm9jfXn5MzNiEGc+F2l2aJr0nTMmIC0MIzbeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyuJwBNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyuJwBNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB981C433C7;
	Tue, 23 Jan 2024 01:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972120;
	bh=gUPOWLOZe+rrlWCruekLxC+yYxAmeBx7dd/mWw9XnLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyuJwBNwOuhCisB+/O3KjLZt44Xw0DYkh0VAbuL5A9Mr5p/QytJdCdxVQXraCQVO4
	 PCT3KrlekNvdbmF6z12yDEH2r7RjE0ctkXoBoWfF5ZVd4mO+88KMZ4mvVGCN99PdMR
	 ZU9jjHAQ6X09mF4HNaRvcLWlhhWvwSToE2Gxga7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarannya Sasikumar <quic_sarannya@quicinc.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/374] net: qrtr: ns: Return 0 if server port is not present
Date: Mon, 22 Jan 2024 15:55:03 -0800
Message-ID: <20240122235746.247167906@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index 3e40a1ba48f7..4a13b9f7abb4 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -569,7 +569,9 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
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



