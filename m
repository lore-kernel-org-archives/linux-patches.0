Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ABB344029;
	Mon, 20 Apr 2026 16:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701583; cv=none; b=NST+z3jEQ+8SdnVo4qm49uw0Vi2g4wa7spzZNwBrd24kN5InTI3L7ODe6lhCt9WNBGLK7+XDhHgW+IZE9o/3DUxsSifuTvBqP04ntsAJ7eYyRbSTQj59lpbBvmQ4bpHM5lIgFXIJ+4LLsVWS+1Ldn+IFaBqlti1pEYSwIjqtcVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701583; c=relaxed/simple;
	bh=WEvOCUI+NYG/Fzr6Lj9BOJs9HgB/83MpiTeomgu4uWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0NDohG6Jc1ZeM8htIBX0qektfHmHhEsdrRswc3JMEcYMfhJz39JsJ/3DwQXAzB5t8qIQJXfL5pUds04Aj704/CqKYvc3yCv5ir/Lz+8k6rSmcjGW7vtpAqAs93rS4BcwNoEKqZG3rIMu+r3bf/Vy4rf7Y5Gc00+Til3xfcxsJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqPyB+fT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqPyB+fT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF7FC19425;
	Mon, 20 Apr 2026 16:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701582;
	bh=WEvOCUI+NYG/Fzr6Lj9BOJs9HgB/83MpiTeomgu4uWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqPyB+fTjWgIpR9Yx3xfSUPkStuMXkD+aKsWcfzxj81ZfQKSASRl1Jcj/j5PZl+kR
	 VJrIhp8ekYEO/tYaZjry8LWJ2U1VfipD+FuD0kHU/yul1Wuvkx4wwpsy0UIB/lqfr5
	 CvbTqS2DvYLbALWsGJMOGbKnYH57HPB/zPk7mUOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.12 161/162] ipv6: add NULL checks for idev in SRv6 paths
Date: Mon, 20 Apr 2026 17:43:13 +0200
Message-ID: <20260420153932.888502369@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit 06413793526251870e20402c39930804f14d59c0 ]

__in6_dev_get() can return NULL when the device has no IPv6 configuration
(e.g. MTU < IPV6_MIN_MTU or after NETDEV_UNREGISTER).

Add NULL checks for idev returned by __in6_dev_get() in both
seg6_hmac_validate_skb() and ipv6_srh_rcv() to prevent potential NULL
pointer dereferences.

Fixes: 1ababeba4a21 ("ipv6: implement dataplane support for rthdr type 4 (Segment Routing Header)")
Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260316073301.106643-1-heminhong@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c   |    4 ++++
 net/ipv6/seg6_hmac.c |    2 ++
 2 files changed, 6 insertions(+)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -379,6 +379,10 @@ static int ipv6_srh_rcv(struct sk_buff *
 	hdr = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 
 	idev = __in6_dev_get(skb->dev);
+	if (!idev) {
+		kfree_skb(skb);
+		return -1;
+	}
 
 	accept_seg6 = min(READ_ONCE(net->ipv6.devconf_all->seg6_enabled),
 			  READ_ONCE(idev->cnf.seg6_enabled));
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -245,6 +245,8 @@ bool seg6_hmac_validate_skb(struct sk_bu
 	int require_hmac;
 
 	idev = __in6_dev_get(skb->dev);
+	if (!idev)
+		return false;
 
 	srh = (struct ipv6_sr_hdr *)skb_transport_header(skb);
 


