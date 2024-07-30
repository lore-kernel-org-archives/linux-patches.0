Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7EA17D8BB;
	Tue, 30 Jul 2024 16:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358696; cv=none; b=g7M0qbaZbKPY8iwWwEsf/jCcRCjkKlUAdKjogqYOV1E/912My6qv4e12ZMuSh25MA3y+faCUbNQO7O0zIDpLLz++LcvYXux5htzYx3j0BUuAXez9gLifASx/e6Jl7rdChpNx0IN3jHwLNm/hptyngrGf5M/jkXUmOXLDcc7Zy+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358696; c=relaxed/simple;
	bh=FyD7X8hBX0ceG1wPfYbyr8QYkqJ1oujULrbDyhRXnhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibvuua94hKaechJk/L5n6UTWxCMDyycfR8SHMmrzJoyhOFtzaKMULPqphEUayyUl/H8FpBevTGwaSfoOcCDmPINq3mhXWhMm20WlrTe7Sh61KV0KDYeTa9P7qdAMkzYsvKXL4479PQAr0qgiAdcPWr038L6ClUcVTuTuwvcoHCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHzrcMbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHzrcMbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B17C32782;
	Tue, 30 Jul 2024 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358695;
	bh=FyD7X8hBX0ceG1wPfYbyr8QYkqJ1oujULrbDyhRXnhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHzrcMbromsXwM8WSPOSylYT1qC9ib1Xhp6b0WBtVpzgmz3JvbmA4Pp++YCJjLbV1
	 LSM9Vb+CpKRVA6gorFnNPxjz3lU0Z85DY54Kz2apvszi5fDYubjoMOQMsZDvs9YfiA
	 VagS/ByJBAy5F8KEwQ77ajhicub8Qh6/eWMfNqxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Tung Nguyen <tung.q.nguyen@endava.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 414/440] tipc: Return non-zero value from tipc_udp_addr2str() on error
Date: Tue, 30 Jul 2024 17:50:47 +0200
Message-ID: <20240730151631.960892526@linuxfoundation.org>
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
index 0a85244fd6188..73e461dc12d7b 100644
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



