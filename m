Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BCF30146A;
	Tue, 26 Aug 2025 13:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214518; cv=none; b=GwJe92h78frTaZFZGY9nEru/Uj9cU9NBrfmmGsHyFkltEJH93Kvi7mLTAtdnwzpchasbOw3cO062iyB0EmLwHdRaAvxxsk2w5oLNv3d8uIx4q9rHLoiRae8FaS+BU4XOc9Hqw6b7nhX+0E5A8aSgjRpemO81zh/EBDEz9L7kYSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214518; c=relaxed/simple;
	bh=4Mg8NTypv0cnLDszsJFSpiuI+5ihfx6eJ6V13whcM5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A8FFdkBzPCVi7gvKKPtKJPK+3srKC+0Kxn423JHNSpNkNvxzY2NLk2mArWu1LBNQCJNHe9NEMZ/lAOhbcwkNjMGbB8aUHiyFGFLY3xSfXhE8z5Yh1ew1OG5I0s3Jh2DUbCaxuygw6yt2MlVIaAY4x+Svv+bQaPa5z6d3AGdsV5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QI1NLd4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QI1NLd4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80A3C4CEF1;
	Tue, 26 Aug 2025 13:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214517;
	bh=4Mg8NTypv0cnLDszsJFSpiuI+5ihfx6eJ6V13whcM5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QI1NLd4E0hbqWbEnZRL+T97T8i+d5zME8Tc9PEu0fXlI3iZqsXqWzzDFWEuTOLBJ9
	 fiOXY4J0PCT7+WrWC26D2+MHQNf3epyhPXu4gSoQBsllvN4cYvKEniMPPb0GgaLENt
	 idMe7n6oiUllSQ5OS5afoEP1hZAIUUFjpbUlsgsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/482] uapi: in6: restore visibility of most IPv6 socket options
Date: Tue, 26 Aug 2025 13:07:00 +0200
Message-ID: <20250826110934.937471506@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 31557b3487b349464daf42bc4366153743c1e727 ]

A decade ago commit 6d08acd2d32e ("in6: fix conflict with glibc")
hid the definitions of IPV6 options, because GCC was complaining
about duplicates. The commit did not list the warnings seen, but
trying to recreate them now I think they are (building iproute2):

In file included from ./include/uapi/rdma/rdma_user_cm.h:39,
                 from rdma.h:16,
                 from res.h:9,
                 from res-ctx.c:7:
../include/uapi/linux/in6.h:171:9: warning: ‘IPV6_ADD_MEMBERSHIP’ redefined
  171 | #define IPV6_ADD_MEMBERSHIP     20
      |         ^~~~~~~~~~~~~~~~~~~
In file included from /usr/include/netinet/in.h:37,
                 from rdma.h:13:
/usr/include/bits/in.h:233:10: note: this is the location of the previous definition
  233 | # define IPV6_ADD_MEMBERSHIP    IPV6_JOIN_GROUP
      |          ^~~~~~~~~~~~~~~~~~~
../include/uapi/linux/in6.h:172:9: warning: ‘IPV6_DROP_MEMBERSHIP’ redefined
  172 | #define IPV6_DROP_MEMBERSHIP    21
      |         ^~~~~~~~~~~~~~~~~~~~
/usr/include/bits/in.h:234:10: note: this is the location of the previous definition
  234 | # define IPV6_DROP_MEMBERSHIP   IPV6_LEAVE_GROUP
      |          ^~~~~~~~~~~~~~~~~~~~

Compilers don't complain about redefinition if the defines
are identical, but here we have the kernel using the literal
value, and glibc using an indirection (defining to a name
of another define, with the same numerical value).

Problem is, the commit in question hid all the IPV6 socket
options, and glibc has a pretty sparse list. For instance
it lacks Flow Label related options. Willem called this out
in commit 3fb321fde22d ("selftests/net: ipv6 flowlabel"):

  /* uapi/glibc weirdness may leave this undefined */
  #ifndef IPV6_FLOWINFO
  #define IPV6_FLOWINFO 11
  #endif

More interestingly some applications (socat) use
a #ifdef IPV6_FLOWINFO to gate compilation of thier
rudimentary flow label support. (For added confusion
socat misspells it as IPV4_FLOWINFO in some places.)

Hide only the two defines we know glibc has a problem
with. If we discover more warnings we can hide more
but we should avoid covering the entire block of
defines for "IPV6 socket options".

Link: https://patch.msgid.link/20250609143933.1654417-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/in6.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index ff8d21f9e95b..5a47339ef7d7 100644
--- a/include/uapi/linux/in6.h
+++ b/include/uapi/linux/in6.h
@@ -152,7 +152,6 @@ struct in6_flowlabel_req {
 /*
  *	IPV6 socket options
  */
-#if __UAPI_DEF_IPV6_OPTIONS
 #define IPV6_ADDRFORM		1
 #define IPV6_2292PKTINFO	2
 #define IPV6_2292HOPOPTS	3
@@ -169,8 +168,10 @@ struct in6_flowlabel_req {
 #define IPV6_MULTICAST_IF	17
 #define IPV6_MULTICAST_HOPS	18
 #define IPV6_MULTICAST_LOOP	19
+#if __UAPI_DEF_IPV6_OPTIONS
 #define IPV6_ADD_MEMBERSHIP	20
 #define IPV6_DROP_MEMBERSHIP	21
+#endif
 #define IPV6_ROUTER_ALERT	22
 #define IPV6_MTU_DISCOVER	23
 #define IPV6_MTU		24
@@ -203,7 +204,6 @@ struct in6_flowlabel_req {
 #define IPV6_IPSEC_POLICY	34
 #define IPV6_XFRM_POLICY	35
 #define IPV6_HDRINCL		36
-#endif
 
 /*
  * Multicast:
-- 
2.39.5



