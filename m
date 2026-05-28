Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA763403E7;
	Thu, 28 May 2026 19:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998173; cv=none; b=UzJBQgA/QfiNsvL/9wqJp3Qf9le0aOYpQm1lVahjCnDYxxMiBWg30Z8FonBm8qrVouqmXMnV9JNek67GFz7gKI+vptcOebK9Ti52xqWytqPhqGVDYfOJxhRIAOaNJw4hFKA8WRyFqrGNBIyLQMc+4AUnQ0fi2SxWqbOAdtqWJRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998173; c=relaxed/simple;
	bh=pxUOrSMUoNPT3P03fvjNLFivvM6yH34fDMOKj3h1apM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/lqlSBL4wevicbSlkhPAx3J39rY7JWrhceDxj0/C1+DJf8LQAxgYfsp4Og8EhtYuqKUt9gkDVwv6LHmCFAdV+D9xgHUjZ3avr15CjJqbMGmWTpuYGoRC5LT1drIA5TD0Lq8zTeWtm9cO8G+wimQBFR+iy0bFQQnvaZZUQChzFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbEC5q8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbEC5q8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896B61F000E9;
	Thu, 28 May 2026 19:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998172;
	bh=rXhi9yTpNtWazJ2c0XEV+7jqd97ipdL/6xIRda5/sLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbEC5q8jVG8Zuc+AMga5mbvosIq78wXhAz6x6QY9wIA+WXQL/drx3pAkP91vvhSj+
	 GY4qXMjflihoMRMqw1fa6s5cIl0BggPbXcJHGVZA3dcQUf+9JlYr+8EPr7PKjQ6tRw
	 WgWgXcO2+BFH5Q91v3UD4nMnqAOXrNtWX2C0dp9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 043/461] Bluetooth: bnep: Fix UAF read of dev->name
Date: Thu, 28 May 2026 21:42:52 +0200
Message-ID: <20260528194648.148312735@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 59e932ded949fa6f0340bf7c6d7818f962fa4fd2 upstream.

bnep_add_connection() needs to keep holding the bnep_session_sem while
reading dev->name (just like bnep_get_connlist() does); otherwise the
bnep_session() thread can concurrently free the net_device, which can for
example be triggered by a concurrent bnep_del_connection().

(This UAF is fairly uninteresting from a security perspective;
calling bnep_add_connection() requires passing a capable(CAP_NET_ADMIN)
check. It also requires completely tearing down a netdev during a fairly
tight race window.)

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/bnep/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -638,8 +638,8 @@ int bnep_add_connection(struct bnep_conn
 		goto failed;
 	}
 
-	up_write(&bnep_session_sem);
 	strcpy(req->device, dev->name);
+	up_write(&bnep_session_sem);
 	return 0;
 
 failed:


