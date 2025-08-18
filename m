Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE503218CF;
	Mon, 18 Aug 2025 12:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521936; cv=none; b=UnpYwMYFVl917I9GAjn0NAuve71TH6nYvNqppmEl3xBTzfiPnfbbO0fx+Lw7N0RfZ9GtZQApjt+64jOw61XMpWl49C3NdUg1IZ+6ZLGoJ+cqgf3RXr5wmbf5rcvj+wBdOqe+xRRaXZlWfpjxlk5JmdMolOet8fOWH+3RaFqYBU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521936; c=relaxed/simple;
	bh=VyNd+b8enbetXtH+Ptoud44JhXNJP8ZpjBkjDlUhPks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piMM4WA8DpJSRUL3/YoEkxr4Z4CXzhEBWSWLqhjlHNBZrP+41D5COb80p9kbx3XlWZDf1T+RoC7DYMoTZccTzGvqt13SfLoDA5Duzq9KzEu41fuRmAA1jfuE81oW1jGeyx7a2nE7yN2HykycrkK3hxb/bgxm68XIp7hyLJQRReU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0NJwkwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0NJwkwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5454C4CEEB;
	Mon, 18 Aug 2025 12:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521936;
	bh=VyNd+b8enbetXtH+Ptoud44JhXNJP8ZpjBkjDlUhPks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0NJwkwqREfxoh0dsxRHGpIvqWhjbfaIJzO6lyQWGXy+qtINeu9Dp6BV9CKdJHZPW
	 PGqPNpK+FCqQl+SNRm9ubcSU1L+haWJcZxm6pFo+2ywwiiqnUCWVC00mJ3kWlqqUZJ
	 Ze3EnrGkltPRPXvXlR2ATo7RAhFxWHtkXs+q+8Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/444] Bluetooth: hci_sock: Reset cookie to zero in hci_sock_free_cookie()
Date: Mon, 18 Aug 2025 14:43:12 +0200
Message-ID: <20250818124455.116007533@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 4d7936e8a5b1fa803f4a631d2da4a80fa4f0f37f ]

Reset cookie value to 0 instead of 0xffffffff in hci_sock_free_cookie()
since:
0         :  means cookie has not been assigned yet
0xffffffff:  means cookie assignment failure

Also fix generating cookie failure with usage shown below:
hci_sock_gen_cookie(sk)   // generate cookie
hci_sock_free_cookie(sk)  // free cookie
hci_sock_gen_cookie(sk)   // Can't generate cookie any more

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 022b86797acd..4ad5296d7934 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -118,7 +118,7 @@ static void hci_sock_free_cookie(struct sock *sk)
 	int id = hci_pi(sk)->cookie;
 
 	if (id) {
-		hci_pi(sk)->cookie = 0xffffffff;
+		hci_pi(sk)->cookie = 0;
 		ida_free(&sock_cookie_ida, id);
 	}
 }
-- 
2.39.5



