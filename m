Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748C11AC8AE;
	Thu, 15 Aug 2024 13:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729677; cv=none; b=ocpfXsuOcrvjqKJiHW8V421aMxKSv2/s7IIuQTVd7v48rwtBYWndzwuE4vGcObYgOQlLNJbuy5rRUbk6sihY9LA6JKl3nfmjLj+kJPap9aS/T5XhpP8vkj7w6g1UrUXMcuAulDDfxzi/1P24o/tOGzwDk2zhhW38VZ7os1uvDFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729677; c=relaxed/simple;
	bh=ZPl9NhOnnezoCvWa6ILHprIYELDfM/0YmvI1J+15Oyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgdLvLOR5ZRS7joT+PoEUDh3mxB0UIQXInQh2D6PU1XYH9N1W9LXXzLnTAI8g8xnTu1rrYUK8TxM9gno7We31k7uJB1ddxIIaesZqjnV8UR9scgNsRjnNxtTSYcIiia4RQNo+7L2959sLRITA4NYVx/D2G29kPpSpZBmv9SeVz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnqRge8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnqRge8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A363AC32786;
	Thu, 15 Aug 2024 13:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729677;
	bh=ZPl9NhOnnezoCvWa6ILHprIYELDfM/0YmvI1J+15Oyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnqRge8KoDGvsPD1i7K6ptUq03gC+svUy1Ygk3ume6Fd3KU8O3ImIJ0CNEehHTkai
	 dgmtfm0FJM+zYIqkdMjT2dGpCfosZG/0G4i4ByjzX6876Qfb9IqC43WIh2sx7RUx8B
	 YsGPcTniqqtizFSlgPyFfwiJnih9dbpythQafaqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 174/484] ipv6: take care of scope when choosing the src addr
Date: Thu, 15 Aug 2024 15:20:32 +0200
Message-ID: <20240815131948.135902891@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


