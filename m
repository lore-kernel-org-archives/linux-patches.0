Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456171A76A4;
	Tue, 30 Jul 2024 17:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359971; cv=none; b=MrN3atnLzLi+a8eoMrmCVuxTo8vj7jXNDnpVZanZBSgjMUKfK+wuLpQznk2jGLlt3TIgXbHgiwQgBN9o5ySL29EFIkzDhCjJdsqeH2EtRHQq8le27wmhna/Mve7/IkYuWkF4iYfM4HOghMmNJgFLKOkXXCZ5UxkIxSs4icxfVls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359971; c=relaxed/simple;
	bh=pETnkoX4dt2Na8UbJqlXRmF2I7btzxm8xfSHTnMb47c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6jn5sW/bRBLes3pRPoStNEI1y5Gglxb3zsZN5hjImNrhyz7dIm2nas5tLLe/NeoTUgZ1ccqJ2C1abCyIZ16TzukMp5Gtb9GHw7OLKnyn314NV+67hOcIlt3WN0jvKumVZuR1geShgk7yHOGnHcOlUPsUR5N1p0yW3Q6AlqTbHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWiL5dAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWiL5dAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D01C32782;
	Tue, 30 Jul 2024 17:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359970;
	bh=pETnkoX4dt2Na8UbJqlXRmF2I7btzxm8xfSHTnMb47c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWiL5dAqCNy1seIgXl0ElZ+ZqaewQ8khKffsoOstlU5/nsgnIVLbJcP3k9+h2aSt1
	 cIB6Lsu+i9vrhwB36zWrig4zIAru8iImFn4/b6OTjeMxqzyvMmSocpaWQaN+2VHOPH
	 wKrnk0xU7KEjx4pfPa7Kvtz1hGF0WeHHuvSDcUUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Tung Nguyen <tung.q.nguyen@endava.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 540/568] tipc: Return non-zero value from tipc_udp_addr2str() on error
Date: Tue, 30 Jul 2024 17:50:47 +0200
Message-ID: <20240730151701.263642716@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f892b0903dbaf..cdc8378261ec3 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -135,8 +135,11 @@ static int tipc_udp_addr2str(struct tipc_media_addr *a, char *buf, int size)
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



