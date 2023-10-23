Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D54714A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzYDXgit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17A8C433C7;
	Mon, 23 Oct 2023 11:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059133;
	bh=k66DTW6hSguqB3Wt4F0fd1lo1ULV52As8TIq/jxoPgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzYDXgitaAblKoXYs3OW3FgDOu0DRAyRQhU3uzZpcIoPAaHEEx23f31+L61hXmsr4
	 4O0o3jeW+hdSCMKI3pUrojdSDzWitW7GQWvk36rBMVU483B0adJDQ2UMlTBqrIk0Xq
	 VFRQm2Fe0LkXYCsX7Z2D4CCWTWCzZcCMHuCkV2H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Wiesner <jwiesner@suse.de>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.5 075/241] bonding: Return pointer to data after pull on skb
Date: Mon, 23 Oct 2023 12:54:21 +0200
Message-ID: <20231023104835.720225079@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Wiesner <jwiesner@suse.de>

commit d93f3f992780af4a21e6c1ab86946b7c5602f1b9 upstream.

Since 429e3d123d9a ("bonding: Fix extraction of ports from the packet
headers"), header offsets used to compute a hash in bond_xmit_hash() are
relative to skb->data and not skb->head. If the tail of the header buffer
of an skb really needs to be advanced and the operation is successful, the
pointer to the data must be returned (and not a pointer to the head of the
buffer).

Fixes: 429e3d123d9a ("bonding: Fix extraction of ports from the packet headers")
Signed-off-by: Jiri Wiesner <jwiesner@suse.de>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4022,7 +4022,7 @@ static inline const void *bond_pull_data
 	if (likely(n <= hlen))
 		return data;
 	else if (skb && likely(pskb_may_pull(skb, n)))
-		return skb->head;
+		return skb->data;
 
 	return NULL;
 }


