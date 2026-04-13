Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124AB32D43C;
	Mon, 13 Apr 2026 16:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099414; cv=none; b=KQPuyOkucKTClXCcSs1MowGKYG8sunQmjjUok3C6l4TT6ez3R0Qoq1vEAS1//aB3Ln5NcCdD7sNyzjncKdWQsQCU3B/VkdmUavz4FXAmsV96qK6MYg1m/qBAz2U3OmxWSttCzUwjuTbjIEaJvfxlcerBMn854wiG/1grHe0CTlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099414; c=relaxed/simple;
	bh=lOjitpMLpprUy3S17tI22wAWo2OgEkF1RiVJO5eD26Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCwp7FEJE6f/2gig5GKgPnw3offntLU1nkY2wRfjgQfeqxKWiN+x/OvKIRE5wF7M1c32Dz2aYCc6f3Mvw/4/kkmp2Z8GhOBa3YPnw5fx1scr0mcLguNfb7nNTBoOfpFnYZi0CPI2IQow3VJVRjBkuaG81YJAfavyCLvspQiHPlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ml8zQBJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ml8zQBJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830DEC2BCAF;
	Mon, 13 Apr 2026 16:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099413;
	bh=lOjitpMLpprUy3S17tI22wAWo2OgEkF1RiVJO5eD26Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ml8zQBJUTrnhYCFCcSRaOxunzrbM5dWGMIk92hLMROOG1W37z996cxaJ7JqhYqbIJ
	 SUtUBORDSq13EcgiAwQ6H/mJ468cLCYA67hqK+oFIIdX7uhCWebUqWe8IITLMciM77
	 IFFLUPxh8eorO/njSJk1WPKv3wzGULWOJkuoC45k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/491] ipv6: prevent possible UaF in addrconf_permanent_addr()
Date: Mon, 13 Apr 2026 17:59:36 +0200
Message-ID: <20260413155831.433400910@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit fd63f185979b047fb22a0dfc6bd94d0cab6a6a70 ]

The mentioned helper try to warn the user about an exceptional
condition, but the message is delivered too late, accessing the ipv6
after its possible deletion.

Reorder the statement to avoid the possible UaF; while at it, place the
warning outside the idev->lock as it needs no protection.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://sashiko.dev/#/patchset/8c8bfe2e1a324e501f0e15fef404a77443fd8caf.1774365668.git.pabeni%40redhat.com
Fixes: f1705ec197e7 ("net: ipv6: Make address flushing on ifdown optional")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/ef973c3a8cb4f8f1787ed469f3e5391b9fe95aa0.1774601542.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index ced20abf4ef8e..758cea239e618 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3509,12 +3509,12 @@ static void addrconf_permanent_addr(struct net *net, struct net_device *dev)
 		if ((ifp->flags & IFA_F_PERMANENT) &&
 		    fixup_permanent_addr(net, idev, ifp) < 0) {
 			write_unlock_bh(&idev->lock);
-			in6_ifa_hold(ifp);
-			ipv6_del_addr(ifp);
-			write_lock_bh(&idev->lock);
 
 			net_info_ratelimited("%s: Failed to add prefix route for address %pI6c; dropping\n",
 					     idev->dev->name, &ifp->addr);
+			in6_ifa_hold(ifp);
+			ipv6_del_addr(ifp);
+			write_lock_bh(&idev->lock);
 		}
 	}
 
-- 
2.53.0



