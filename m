Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07910BE7F;
	Thu, 18 Jan 2024 11:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575713; cv=none; b=Bf73SRSK9byjZCk/+ldX1tRbV6+ZJ0ugpop8OYBDZVEZ9Q5p/auRuFgwjQstVffzhefQCW/8BgVMNZJl6xyF/27BAjn/ZI64G4zvBRymq8hCa/LYCdzHCfGtA4YcMSngtfrtzMTq3tTF5FG/Q9LmghnO9pMz/fNeDWh8eR+jb+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575713; c=relaxed/simple;
	bh=921yFkaS1u+DikEfL1yop4eZeFhS502uVLwAJ62US7U=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=eacTpzO5HtsXtDon3eutcPJttpYOJVfIWZXYRXaspWS+ZB3ldmkssipCsYg31ndl1hO7mNgDohML302q8QwM9IVuT6EQ9XFj61MCjrcbydkKC6gQW2A18Tk3SqtgXbJv93LhN89givQH64MJ0L9a0hx7PHiNUSquIdc/6lj6J2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ihs89KNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ihs89KNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B15C433F1;
	Thu, 18 Jan 2024 11:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575712;
	bh=921yFkaS1u+DikEfL1yop4eZeFhS502uVLwAJ62US7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ihs89KNpIxLBpN+7TOWcSTQKKSBkeEWMWfbn+keAsNdT3PM9Aeauyws+Et1zgZUHD
	 BAlRfFbjMP5EZk21ldiAMJjYTzPyDe97az/EDaCm6RyXz/orjJe6zRnw8TBm9uMqrw
	 /7/UFVbJWh5hFSRc+juYEhMgMpbmQLRkQHNwu+vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarannya Sasikumar <quic_sarannya@quicinc.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/100] net: qrtr: ns: Return 0 if server port is not present
Date: Thu, 18 Jan 2024 11:49:27 +0100
Message-ID: <20240118104314.335717027@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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



