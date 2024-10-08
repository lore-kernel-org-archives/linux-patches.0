Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3521DE2CF;
	Tue,  8 Oct 2024 12:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391545; cv=none; b=baJAszseaj2gSXR5cd0FoDcFkxjxDcVhW34W8eXMUnJ93RT7OcSCba0TYHO0JuLowVgbhu4mBq6NpfP5N1D2TW/DdiG0zKlSNNy6T0D2iUDXNRBl4TQuDVSxUA0LkKVfnKtGIwz2r33/LVI7SQiksHUDqycCeeVypfCOvQkh9iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391545; c=relaxed/simple;
	bh=kiBOE/AoCOkRLAzatov0bW1udVEHc+b5fx8KadhtrsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgj8sVrtCdcqKBl+EuhtWt4WGU28T5+q2cPsPPN416pcLJAwMegzTr+tFfdzgyWp0BrI3oM5tmspMCP1whnw4cXO8AgH4J98Z5m2QS5ugGGzI2rzJG625XsKC80rL0n6O0JvhI0AfNFKYQlLrEsEkGdYuuSoEtKqCkWcbdigSKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdCHdeq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdCHdeq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E8FC4CEC7;
	Tue,  8 Oct 2024 12:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391545;
	bh=kiBOE/AoCOkRLAzatov0bW1udVEHc+b5fx8KadhtrsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdCHdeq2Ku5MvlsNTcnjs+XClRiRug5dNKdzcvo5aOmiLJT+CoP0zty6uOnHERDMc
	 ltnbNpK2JQIXAFnVMD4wkNrx8BdeX4vbK4wAGz3kb99hC5ozoK9hM0WaNaRFqXYBl/
	 31dzj7v814TSOwRMqlmyl2UmabDfa1KHVB/uSsu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 148/558] netdev-genl: Set extack and fix error on napi-get
Date: Tue,  8 Oct 2024 14:02:58 +0200
Message-ID: <20241008115708.187842782@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit 4e3a024b437ec0aee82550cc66a0f4e1a7a88a67 ]

In commit 27f91aaf49b3 ("netdev-genl: Add netlink framework functions
for napi"), when an invalid NAPI ID is specified the return value
-EINVAL is used and no extack is set.

Change the return value to -ENOENT and set the extack.

Before this commit:

$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/netdev.yaml \
                          --do napi-get --json='{"id": 451}'
Netlink error: Invalid argument
nl_len = 36 (20) nl_flags = 0x100 nl_type = 2
	error: -22

After this commit:

$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/netdev.yaml \
                         --do napi-get --json='{"id": 451}'
Netlink error: No such file or directory
nl_len = 44 (28) nl_flags = 0x300 nl_type = 2
	error: -2
	extack: {'bad-attr': '.id'}

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20240831121707.17562-1-jdamato@fastly.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 05f9515d2c05c..a17d7eaeb0019 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -216,10 +216,12 @@ int netdev_nl_napi_get_doit(struct sk_buff *skb, struct genl_info *info)
 	rtnl_lock();
 
 	napi = napi_by_id(napi_id);
-	if (napi)
+	if (napi) {
 		err = netdev_nl_napi_fill_one(rsp, napi, info);
-	else
-		err = -EINVAL;
+	} else {
+		NL_SET_BAD_ATTR(info->extack, info->attrs[NETDEV_A_NAPI_ID]);
+		err = -ENOENT;
+	}
 
 	rtnl_unlock();
 
-- 
2.43.0



