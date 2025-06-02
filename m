Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712E8221F39;
	Mon,  2 Jun 2025 15:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877373; cv=none; b=K7HqvLWeX98hH7I0NCGMkD9P6ih8ZehvWvH/HodsnXwDoPmsM7LD3CTY24f6FMW85dka2Ig/5rb0H3q7/ijEjD+oK/BgQZnLEdyW3cJV+Jqqk2qLkH//OYX0DIHmrxchJ7ISsl27zIX8dmAi0jjOJcarsx8NRcxZtXjSHoEhCbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877373; c=relaxed/simple;
	bh=jev/ACduupEdrRm0mK/DwHJt9/yFhiVwRQ+9fw/zRu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqknuxZGBvVJ151AxL3YuqtwLkbSSiF677Hph8Dg9dZ4/c/u4jEwkAvQpfd0H+LRiU63eoqPmSHpXwyyosJLXoNlxuTLRBFY8llGBFH6lH2kGpQ4amzIdfHpZJTcxz65rv1UJzje4AZ89LJY++m5PVeioNIGj9x4sxPKM4pGkWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWzoAROn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWzoAROn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3CFC4CEEB;
	Mon,  2 Jun 2025 15:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877373;
	bh=jev/ACduupEdrRm0mK/DwHJt9/yFhiVwRQ+9fw/zRu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWzoAROncl1fxpZVlwVasyUsr/dEaoirrP7oqZWbKEao0KROF5QZNWcg62KnY8LEY
	 rtPCsuX7zQ1JRHfs/TtRLeXopiws5bxgITnFhA7PApQrVp3yz5aBHJsT35FaSr7nhY
	 36kwmad3NqLMPAP8JujYg/jqFul1SCSKCljmGpkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 257/325] llc: fix data loss when reading from a socket in llc_ui_recvmsg()
Date: Mon,  2 Jun 2025 15:48:53 +0200
Message-ID: <20250602134330.214626445@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>

commit 239af1970bcb039a1551d2c438d113df0010c149 upstream.

For SOCK_STREAM sockets, if user buffer size (len) is less
than skb size (skb->len), the remaining data from skb
will be lost after calling kfree_skb().

To fix this, move the statement for partial reading
above skb deletion.

Found by InfoTeCS on behalf of Linux Verification Center (linuxtesting.org)

Fixes: 30a584d944fb ("[LLX]: SOCK_DGRAM interface fixes")
Cc: stable@vger.kernel.org
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/af_llc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -888,15 +888,15 @@ static int llc_ui_recvmsg(struct socket
 		if (sk->sk_type != SOCK_STREAM)
 			goto copy_uaddr;
 
+		/* Partial read */
+		if (used + offset < skb_len)
+			continue;
+
 		if (!(flags & MSG_PEEK)) {
 			skb_unlink(skb, &sk->sk_receive_queue);
 			kfree_skb(skb);
 			*seq = 0;
 		}
-
-		/* Partial read */
-		if (used + offset < skb_len)
-			continue;
 	} while (len > 0);
 
 out:


