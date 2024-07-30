Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DDF189502;
	Tue, 30 Jul 2024 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357524; cv=none; b=tF3CGlDhSQQkszWvplhoPtiTressH0KAdl6gKFNkdG/kAe9dfV1BHlMiwyluzEaUD3iioVSmwcXBwYs1D6YD1pYuX+iJTbE2gLtPD41noDWD26stMoPebs0sl095yExd1tvASOT8U7XE2f905kMGW5gCwhW1EYt3HChGszNpPKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357524; c=relaxed/simple;
	bh=H22xwe7zEgFDaX+NX8UKpZkgZpbvBBLkW7egQxSRrOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rm2I8cqWRcvuTmazIDiPNmTyW81cYQMkxileFGcQ/VMouhwDr2oXdAKTdCLQ0Gk7/yj2IlRGhFEmv30iTnoeJMW4g+6isa1V8dgyzGWwSiioYjbFlHLKlKvx/d8v3vhym3saML67KR7WDwg7VH9SxkDekJuz6CflHO4Xuy4kEFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbEqe2gQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbEqe2gQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF75C4AF0E;
	Tue, 30 Jul 2024 16:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357524;
	bh=H22xwe7zEgFDaX+NX8UKpZkgZpbvBBLkW7egQxSRrOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbEqe2gQNkpXJsVPJFdVPjsRekmquRNx+dvLaw1NjjUL6L2FfZIALXDrwJ4KIpz1F
	 cW9b+CC4874rSa8I6eDJbY0nLdY7tuCiRU1ZUHHtuWnC+BGqbzE6Cc1vl9OMVdQxjW
	 vfKIHIqbbQZg3rZAUimfU2iQ2Udu7KBV3Xww4ewM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 282/440] ipv6: take care of scope when choosing the src addr
Date: Tue, 30 Jul 2024 17:48:35 +0200
Message-ID: <20240730151626.844245111@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1831,7 +1831,8 @@ int ipv6_dev_get_saddr(struct net *net,
 							    master, &dst,
 							    scores, hiscore_idx);
 
-			if (scores[hiscore_idx].ifa)
+			if (scores[hiscore_idx].ifa &&
+			    scores[hiscore_idx].scopedist >= 0)
 				goto out;
 		}
 


