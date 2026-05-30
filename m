Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8586175A6B;
	Sat, 30 May 2026 18:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164894; cv=none; b=fRE+wFiWpna8CD7gzfXyyuoLeXzRsptoqpKQ+BOUKnNs3SpyRirg1OxSW64elHfxfZkMES37fRSvXCeNB6+zSkQY8ILvXkcVVc0yHFgyxw+uXGV8YLP8142IGDqBK4FuhJpccRipCvq9zRxdoqAkfzPg7omK+GtCbzd012RQeig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164894; c=relaxed/simple;
	bh=ZGQiB1utHaXO8kslZu+Dc86tnlsfZ2OvgRCPGPUBrDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K94CcIP+1gKwKjFrpRUeVK/IIRtIj9KAG/H3IMgQZ5NEJ2qfCsEKz6u9lrqJ1ld8C+wA4PPDRZQ6reJk6cD82qI8HcHyCIi3gQ11xrnol8WZwemHNj/Y4Ytdmzw4vIjs6H/Xzq3n+/M87SCkx8QLUY8BC/EwWSJ+w6+2hwZL9tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYI+tgwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYI+tgwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9261F00893;
	Sat, 30 May 2026 18:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164893;
	bh=SczVxek6z88+MACiWIrNQGluRSA4/O1jVTwyVGCEhvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYI+tgwNc0zIdwY5CbhZt2qEwJqSrTqNJ9JW4BDNuSWpeggb7s5X22GAqTMMc8S7O
	 3OPg2qwSCWtA9ePwXuNa7y0mUfpZJ1MDNf4F1JWnPBaXyfmjDjd/Mt7lk8B7zCZIZD
	 XUDEmqeqNb9IeNaKKz5coqwgj/10iUzyEGE8gKNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 683/776] Bluetooth: bnep: Fix UAF read of dev->name
Date: Sat, 30 May 2026 18:06:37 +0200
Message-ID: <20260530160257.516145371@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


