Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C37563C;
	Thu, 15 Aug 2024 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731325; cv=none; b=V0WAf6gbWkSXulkzrTTLBBQVwzJRACijIo2ddcu6sqFUiPpghRtOioPXmJ4f+o5WIha12W+Ri8v7tkTe6OJu1IcHOkQyP4KOk9MYA4s9qn3am3LPzzcxIDNOTK78xWwfPDE0BWN2RMOwRWNO3NhW1pupVeoNXlynvWISwRPMzFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731325; c=relaxed/simple;
	bh=4GRAvI6/lnKNOF5XHRxx0e9OM75zCRXxKjmBxOIemlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fy/Dg/x3bacwmJ6SqqFuxUUpRHm4oEKK7Hov0lF9TVEyChLLX5a+ORzFVIe0FaPnC4qPJp6jQSGnudQh4agpBZA92wAr52HG9Bc9k8CYutO8tfjne34SRnpBRQdj7UxdhxVNAe2xR9FZ8yek+cSSaFAONfL/jQYxXFI0OWY9b6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFaIQfio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFaIQfio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15D7C32786;
	Thu, 15 Aug 2024 14:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731325;
	bh=4GRAvI6/lnKNOF5XHRxx0e9OM75zCRXxKjmBxOIemlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFaIQfiootRWZdMJMpMbO0hiKfkwF1OjqWMsETyCp4FhQZDbIDIR4T494RmFsujmB
	 Mp0MbrpR/PkgsYuvzg9OoZFXvDLoo6QOhc51nxrz/QYbxKNWxufEIMek3G0njXWBZe
	 czMK2AnulEBfklGlKTiWY3YjWk6FQHe8al9qvHc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 092/259] ipv6: take care of scope when choosing the src addr
Date: Thu, 15 Aug 2024 15:23:45 +0200
Message-ID: <20240815131906.355516345@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit abb9a68d2c64dd9b128ae1f2e635e4d805e7ce64 upstream.

When the source address is selected, the scope must be checked. For
example, if a loopback address is assigned to the vrf device, it must not
be chosen for packets sent outside.

CC: stable@vger.kernel.org
Fixes: afbac6010aec ("net: ipv6: Address selection needs to consider L3 domains")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240710081521.3809742-4-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1829,7 +1829,8 @@ int ipv6_dev_get_saddr(struct net *net,
 							    master, &dst,
 							    scores, hiscore_idx);
 
-			if (scores[hiscore_idx].ifa)
+			if (scores[hiscore_idx].ifa &&
+			    scores[hiscore_idx].scopedist >= 0)
 				goto out;
 		}
 


