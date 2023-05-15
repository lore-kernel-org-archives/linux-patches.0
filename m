Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCFEFC12
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641B1C433EF;
	Mon, 15 May 2023 17:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172073;
	bh=I3liXfzhcubWUArSIqYShYhEWxsWBCNHe+zM7ilHZK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBjlil14FqtgXxfjN+jh8QAutmgMb8GKpNgc49smbfjgB96Cb08dlu6bi7/OeFqM8
	 B1LlRRU8F0ZoGZ4l4ESVmT4GMAUueomZxsL5HDTtgBN/0cL8PAvKfveGk0Rq7cZ31z
	 TF1WSVfvY0l4wqoOS0tFqbOCxbLYTyRDzhslYhdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruihan Li <lrh2000@pku.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 006/381] bluetooth: Perform careful capability checks in hci_sock_ioctl()
Date: Mon, 15 May 2023 18:24:17 +0200
Message-Id: <20230515161737.059788627@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ruihan Li <lrh2000@pku.edu.cn>

commit 25c150ac103a4ebeed0319994c742a90634ddf18 upstream.

Previously, capability was checked using capable(), which verified that the
caller of the ioctl system call had the required capability. In addition,
the result of the check would be stored in the HCI_SOCK_TRUSTED flag,
making it persistent for the socket.

However, malicious programs can abuse this approach by deliberately sharing
an HCI socket with a privileged task. The HCI socket will be marked as
trusted when the privileged task occasionally makes an ioctl call.

This problem can be solved by using sk_capable() to check capability, which
ensures that not only the current task but also the socket opener has the
specified capability, thus reducing the risk of privilege escalation
through the previously identified vulnerability.

Cc: stable@vger.kernel.org
Fixes: f81f5b2db869 ("Bluetooth: Send control open and close messages for HCI raw sockets")
Signed-off-by: Ruihan Li <lrh2000@pku.edu.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -996,7 +996,14 @@ static int hci_sock_ioctl(struct socket
 	if (hci_sock_gen_cookie(sk)) {
 		struct sk_buff *skb;
 
-		if (capable(CAP_NET_ADMIN))
+		/* Perform careful checks before setting the HCI_SOCK_TRUSTED
+		 * flag. Make sure that not only the current task but also
+		 * the socket opener has the required capability, since
+		 * privileged programs can be tricked into making ioctl calls
+		 * on HCI sockets, and the socket should not be marked as
+		 * trusted simply because the ioctl caller is privileged.
+		 */
+		if (sk_capable(sk, CAP_NET_ADMIN))
 			hci_sock_set_flag(sk, HCI_SOCK_TRUSTED);
 
 		/* Send event to monitor */


