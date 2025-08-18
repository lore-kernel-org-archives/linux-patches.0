Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB270335BAF;
	Mon, 18 Aug 2025 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525272; cv=none; b=u6BhizFxE0ohC/DXhmi9sz12CYIqpLv6gsobY9rzzZ5Ggi6GvJEoX9NXChixOK0HgfKRXK77mmo7JnCQBZlteIQfjWz00CF0YaBe5sAjQR05pww+u3qXYH3qpiWVY+GEg40KgA/MqywPmS+UWJ1ZtLA/oKuzwmV1Ny32hNq0WX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525272; c=relaxed/simple;
	bh=86gxCNv8SPtJ7dkT4f32M487pfB4Cj0XEc4TzzAFOIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3c0Rf1pCxnQ79dQVwBzCRgyb+B0ljtLFJgUjyNi4t0Sd0WjHMk2abSgPyugCmV4vgNHwSM3KXVx5V94mofulnXDt7onPwBDHHDEVNerhoOs01dUezKqk1wsNY5w5eY/uj9aTsOHGlFFhEXNa0+r7FEXlIdgL71yQPTKeC/9uRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBNcouMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBNcouMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597ACC4CEEB;
	Mon, 18 Aug 2025 13:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525271;
	bh=86gxCNv8SPtJ7dkT4f32M487pfB4Cj0XEc4TzzAFOIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBNcouMyYTuzbusG2BHnCo2bCdRUgskFzr3FbNCOscIAb/s/mjPjVwHy0whBSFtpB
	 PGn6xGzftysDon5tM5Tvmb/bpIIW4SHHyx8Pr0SEyEZgWTOA7v6M0RgUNQY0pepM9w
	 +Y0DMo8PYJhTk1VP5StA9WEfERnDMzbPDQV8Rq04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 212/570] Bluetooth: hci_sock: Reset cookie to zero in hci_sock_free_cookie()
Date: Mon, 18 Aug 2025 14:43:19 +0200
Message-ID: <20250818124513.967711786@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 428ee5c7de7e..fc866759910d 100644
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



