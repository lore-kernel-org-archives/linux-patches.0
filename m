Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607781A76A0;
	Thu, 15 Aug 2024 14:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731478; cv=none; b=TDiK6DBzd/5pY90LHD70DvUiBGE/RbVSyDYVRhvzJfaMSqNztUig0i1X2qBd2/gwUMjy2EbjkR7FQq84pQvxFpUcVHY1ZZ/54aMEOgq99uElH53wqwhAOz1DeTcesvTlQ0JCTe4qoIuIPlhUFU4w1VNwcghbUkfCR9wWq1LvbJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731478; c=relaxed/simple;
	bh=lCwNNj8d0xpr8a7UYEo9kjV8Eg1WuX0cxjiJsMDYn3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9ipX0uP7sRvIdGmzkGiiLOG2E0NxZ8K4vNYdZ9KA3GMdHKFc/UaTPXdtRN3lg+4TFev72f+Vl7sMdlU7elP1HMbAkWHMdNK3zAsY26ncQ/Attx/YL9FAX220nZtVzSuT9SQ/kdWtOW70hr9cUy3/nCFlrBXh9y+aY6ftTX8fMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wfj01Mmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wfj01Mmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D477BC32786;
	Thu, 15 Aug 2024 14:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731478;
	bh=lCwNNj8d0xpr8a7UYEo9kjV8Eg1WuX0cxjiJsMDYn3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wfj01MmnglmRBIPAFT2KGEdLFQlwGZbWG3ov1ddTA4lkUWMy4vdnSbT8zl5pp1GrR
	 He0xEooCiibw8OAO/MJXsstQbCPw0wVVrlNwNLW0Whf8qwrjlopGGmWYfaFy1JdSI/
	 1DMj37TYKJju9q/3NmgEatCGMdmzULtB/M78o1b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Tung Nguyen <tung.q.nguyen@endava.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/259] tipc: Return non-zero value from tipc_udp_addr2str() on error
Date: Thu, 15 Aug 2024 15:24:36 +0200
Message-ID: <20240815131908.312525436@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit fa96c6baef1b5385e2f0c0677b32b3839e716076 ]

tipc_udp_addr2str() should return non-zero value if the UDP media
address is invalid. Otherwise, a buffer overflow access can occur in
tipc_media_addr_printf(). Fix this by returning 1 on an invalid UDP
media address.

Fixes: d0f91938bede ("tipc: add ip/udp media type")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Tung Nguyen <tung.q.nguyen@endava.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/udp_media.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 1fb0535e2eb47..4db2185a32aec 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -128,8 +128,11 @@ static int tipc_udp_addr2str(struct tipc_media_addr *a, char *buf, int size)
 		snprintf(buf, size, "%pI4:%u", &ua->ipv4, ntohs(ua->port));
 	else if (ntohs(ua->proto) == ETH_P_IPV6)
 		snprintf(buf, size, "%pI6:%u", &ua->ipv6, ntohs(ua->port));
-	else
+	else {
 		pr_err("Invalid UDP media address\n");
+		return 1;
+	}
+
 	return 0;
 }
 
-- 
2.43.0



