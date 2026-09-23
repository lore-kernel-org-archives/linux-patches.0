Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AFC5372F2;
	Wed, 23 Sep 2026 14:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174541; cv=none; b=oBQpBnxdOAA15G97Qf4n7NCrEp3p1OM10t1e6NQI7NVC33nsSXtkFNYXh8574Af+VFLuYWXeNqvPdylXWCCpeOhgFwkbb12v/kIc12hlItAuvQ3KCuk8oJL76OZLDLEMoVfmiDzMdsEMjZHWt2T3rJYcab4RvxqGdWWK+hVvmlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174541; c=relaxed/simple;
	bh=ATJ9wJQunGUeGV9ITbOii7h5+edFWFzYp/vvMCBrXyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3hrFbDCc6lFuUvajxJpgCZM80oy03i9lr0qN546TXlfIni5bLxRblW0tSwwtTBLt2ZYVj3OzqSJzFnlsdI/5wGmEvC/qvp7OY+Rg1PhViq0n1oKFoCsyzZdLkgmHl44wOl4MqZm41GSBucoCFok0tXGJSQUjQaH/RXCh2RL1jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPT0Y5yY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPT0Y5yY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568681F000FF;
	Wed, 23 Sep 2026 14:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174539;
	bh=MQoyvtEWeLGmkO4OlVWyct5pn2s2JtnRS7kK9G2frvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPT0Y5yYB8sjYcOUvbQQQIkQpAkhKpWjVDtu2Dd9voVr3too/IL+y0mvynYvcNVYa
	 TXmkuQYdy/BWngmgFVfboScM8Scg+D4dFiVF1Ldp/W72T435xGE8AuF9UOOuoakAIs
	 7Ri7A9ch0dfDaEGZo3q75KSJPhjqnSh8VqTTX8E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/398] Bluetooth: ISO: Fix parent socket leak in iso_conn_ready()
Date: Wed, 23 Sep 2026 16:03:42 +0200
Message-ID: <20260923140647.269163197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit ca18ee413a7cb6f09885778039225e58bae0d607 ]

iso_get_sock() returns the parent socket with a reference held, which is
dropped by sock_put() once the child socket has been set up. The error
path taken when iso_sock_alloc() fails only calls release_sock() and
returns, leaking the reference and thus the parent socket itself.

Drop the reference on that path as well.

Fixes: fa224d0c094a ("Bluetooth: ISO: Reassociate a socket with an active BIS")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index c30bf48d3858a..83594bb52a14c 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2160,6 +2160,7 @@ static void iso_conn_ready(struct iso_conn *conn)
 				    BTPROTO_ISO, GFP_ATOMIC, 0);
 		if (!sk) {
 			release_sock(parent);
+			sock_put(parent);
 			return;
 		}
 
-- 
2.53.0



