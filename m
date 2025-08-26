Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F801EB5D6;
	Tue, 26 Aug 2025 12:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212886; cv=none; b=PjHpTtO/e8m/LPQBEQeOnssFUrHvPy0r0MS7ytfEH029tTXtBMCEnzz4OTWsAiOpZ/yhT84c/Q38+ErM3/d6mWBDgG2oqpEi00qW+vLF1ZZA+XeD0qIUy8Cs5is+kYaj/Y2nIyd4xQFWWxEHv5o2hMwwHpx6+O/ict8/bXEVTHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212886; c=relaxed/simple;
	bh=x0pm+AlQQoFfLzmdcmUOKFoauDlgyELzSODPp6EVCQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpkNv3XmbulXkDGYtTYtaHRMInTKU2wQ4cYikzxT42MnqkQzHiljiLziXRp3bYeL2r5MhR7nCWFcDhiBa3a01AamgaAZWVexpmtTiIrqtyPb0MQwh4BuU4h3yNa1D8KfrzgnTEnThSOfq2iPA5y8odZwMaf5f43yjTPrNiQFlXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGYfMatp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGYfMatp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D832C4CEF1;
	Tue, 26 Aug 2025 12:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212885;
	bh=x0pm+AlQQoFfLzmdcmUOKFoauDlgyELzSODPp6EVCQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGYfMatpoH2XQorqZikfE0PP3fqOAVtTel6cLdUibgzzu2nncHKPG1DWxHkITotwv
	 yYDh7mw4FuXFtwIJHnOa8CMMIjmktbsgQsUHLAnv5mWwoR9FXbt0xOw3pvfZn8PdLY
	 YWPvoRMMsSr/Nz/Ysfz9+oLZ7bGfg0YefkR+PyTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/587] Bluetooth: hci_sock: Reset cookie to zero in hci_sock_free_cookie()
Date: Tue, 26 Aug 2025 13:04:49 +0200
Message-ID: <20250826110956.513824881@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 69c2ba1e843e..d2613bd3e6db 100644
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



