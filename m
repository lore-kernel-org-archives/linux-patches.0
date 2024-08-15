Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5967DA78;
	Thu, 15 Aug 2024 13:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728646; cv=none; b=SpYqe3SnXEtroMxxhIorkv9GT9jXVyUPBjXRDvJrgyZfS0mYHpLLWZxN9SfgJmglXqYFTRWVViu9asmnj7wsJO+zN9d5H1au0pFLeD0hUDvbX+8AWyHJvJiHnHvZ6IFCYFV93TFCz+o0q2jvageolZbEwdrI1+B4O4BD71rg4BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728646; c=relaxed/simple;
	bh=pYEhA7FpRxuY+CFu4614OC5U6icrp0vYAzitdZkkJ5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfD9RqG61JsMeiLHenZ7VRKsc5c8+ACkuvBRwVwT5xB/6XZ+2MFrC7Ze8rtK4lFJyG+3fGvYSV7v7GPoOuBzEB4wkLkMwFwy9FhPpRmibjHrPvOfHu3U8BYCmtMsTYwB4vwfUS3x6kMIP7hht+6wd0q5x6tq49b6IRIWIJlXICE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGIfSy+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGIfSy+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3342DC32786;
	Thu, 15 Aug 2024 13:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728646;
	bh=pYEhA7FpRxuY+CFu4614OC5U6icrp0vYAzitdZkkJ5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGIfSy+RsPQwEizV/5fQA9SX9XcYnZoW4wqK94NfREtDk6stMELX7fWQm3FGqfQrQ
	 Ord1UvNiI7sRFj6D9TH43zzNMNeHBYenRkHIpg4jkpE9AWPIA1WXa4o+5ou222m+D1
	 u0kX2177kgfinB6k7U0sQASgBc4DrosJhJvXY/R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 065/196] ipv6: take care of scope when choosing the src addr
Date: Thu, 15 Aug 2024 15:23:02 +0200
Message-ID: <20240815131854.560832630@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1768,7 +1768,8 @@ int ipv6_dev_get_saddr(struct net *net,
 							    master, &dst,
 							    scores, hiscore_idx);
 
-			if (scores[hiscore_idx].ifa)
+			if (scores[hiscore_idx].ifa &&
+			    scores[hiscore_idx].scopedist >= 0)
 				goto out;
 		}
 


