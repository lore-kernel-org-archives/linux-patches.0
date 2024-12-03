Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B961E3DED;
	Tue,  3 Dec 2024 15:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239793; cv=none; b=nJ8rlF8B2K1ohB2cwaVGKAKjnl6mvTLxMUdOBife4rADqQUKe3v6NTR3GgTb9KmHOwYsC0rrHPDpPBQJ8db8sCHHlcvVPwZvAu8h+n28BRNi7HNP49vKgJONtPaZeTYANzwKf0u2uTPtNCcldLwuwC5CLHUd+7rqIT2dBLSq1EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239793; c=relaxed/simple;
	bh=8nD1CG4mUMSgEKF+OupgYDSRIekqji2empGHOIcr0rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9pniDL/tedwlN2B0FImHWNNl3kxf1y298njKNgojV4Fly560uVnjp3X2dzsd8IudSJe5QuHKxp2ANKDvUEgnzHpmbnLlIeXELwXXgve1wj07JJ+nHMgzUowVRH2yBIOjW6Aos94fCMmzBFDwm1nmeKKzknUeejSuwB/3SmixOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vm3vNYaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vm3vNYaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65931C4CECF;
	Tue,  3 Dec 2024 15:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239791;
	bh=8nD1CG4mUMSgEKF+OupgYDSRIekqji2empGHOIcr0rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vm3vNYaVgXbhwCow0tdLSUU7QcJak5Xx0V4cn8PcKv+mVUx/RyxHnmnDb0W1fjMTr
	 axbSUSW197eQqEaJah898EUleOyCirkhwBMsOcMGVVb74zuNJ9YixHMlKC+st7AdM9
	 pqxYpDoMWRLk4wbpa9hc7/isBBx6BBUhVDxs1Z+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 735/817] netdev-genl: Hold rcu_read_lock in napi_get
Date: Tue,  3 Dec 2024 15:45:07 +0100
Message-ID: <20241203144024.689708596@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

commit c53bf100f68619acf6cedcf4cf5249a1ca2db0b4 upstream.

Hold rcu_read_lock in netdev_nl_napi_get_doit, which calls napi_by_id
and is required to be called under rcu_read_lock.

Cc: stable@vger.kernel.org
Fixes: 27f91aaf49b3 ("netdev-genl: Add netlink framework functions for napi")
Signed-off-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20241114175157.16604-1-jdamato@fastly.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netdev-genl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -214,6 +214,7 @@ int netdev_nl_napi_get_doit(struct sk_bu
 		return -ENOMEM;
 
 	rtnl_lock();
+	rcu_read_lock();
 
 	napi = napi_by_id(napi_id);
 	if (napi) {
@@ -223,6 +224,7 @@ int netdev_nl_napi_get_doit(struct sk_bu
 		err = -ENOENT;
 	}
 
+	rcu_read_unlock();
 	rtnl_unlock();
 
 	if (err)


