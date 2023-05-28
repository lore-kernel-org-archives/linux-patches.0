Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11404569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9292AC433D2;
	Sun, 28 May 2023 19:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302069;
	bh=zq1Os+D/7yy/NJzFj2J8bClDSlPMi/oDDTlDd37Pa0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pk8t3UdGd1ULnPdzCih87LL4SiJD91E/xyh3CycKdVQkDa3D3o1WaIesd+o/4j+xy
	 LHImw08pMxsEPMLeY7BTvovxqkxtVSBHiCaIJTfMRkPMe60Yr+Qesjl5bkCGYURZBQ
	 T6qhpJdVkjQVXVnx/0bN+bAL0DTZWZ+1ggp3Moso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
	Jiri Pirko <jiri@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 148/161] ipv6: Fix out-of-bounds access in ipv6_find_tlv()
Date: Sun, 28 May 2023 20:11:12 +0100
Message-Id: <20230528190841.599664847@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

commit 878ecb0897f4737a4c9401f3523fd49589025671 upstream.

optlen is fetched without checking whether there is more than one byte to parse.
It can lead to out-of-bounds access.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: c61a40432509 ("[IPV6]: Find option offset by type.")
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -143,6 +143,8 @@ int ipv6_find_tlv(const struct sk_buff *
 			optlen = 1;
 			break;
 		default:
+			if (len < 2)
+				goto bad;
 			optlen = nh[offset + 1] + 2;
 			if (optlen > len)
 				goto bad;


