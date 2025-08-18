Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4E132277A;
	Mon, 18 Aug 2025 13:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523518; cv=none; b=sYPf/B9TPnocksvWqU9ST6YmjAdWq6u/N7685utsKUiLrJJcaHxdwzB0knonlok8R1yjJ05/h9al3ihTqmo6+ihHPXtHeNOCv6D3TofBLx+dqYzoToy439hfJmv7YuMFdK6H0XMm92yoAWoGh/iP0qXnBHFb2JDvps3dTbOP97E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523518; c=relaxed/simple;
	bh=z7MuMhBOjbRQ2ggUE3CtE1PMbMqxaqjV9biErAMkXCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPVGtbQ62FAoTqivbie1Nq3HoFtXzJ3MKHhIQYKZ1JEPesTsnliouczt+LNjTfjKby3zbQqvvmHpt2AolWBJ9xiL+h6Dsnn7xrBCo/DSIfqVkLvzrb5CAcH9cRng3OzV7vvpvF0uq9WsblcHr6LfoMoy9b36iu+UGy+SOnvn6po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TantPckm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TantPckm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E026DC4CEEB;
	Mon, 18 Aug 2025 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523518;
	bh=z7MuMhBOjbRQ2ggUE3CtE1PMbMqxaqjV9biErAMkXCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TantPckmPR1oTp5ONa/NopS0194tEAIr3M6u6h1q8QZzECAVV/WRLD1U2+t6L8C52
	 +xqQSz0XSg/cM/GSKRYUSKbhlGj6t78dPtYL8wJ7+5r6r8V2PvTu5qIZXY6JljlCFK
	 QOKRTo6Nn63lbg50QgG1AHXcl9XgHbeL0p/XS6TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 196/515] Bluetooth: hci_sock: Reset cookie to zero in hci_sock_free_cookie()
Date: Mon, 18 Aug 2025 14:43:02 +0200
Message-ID: <20250818124505.916446700@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



