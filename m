Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1F919DF58;
	Thu, 15 Aug 2024 13:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730001; cv=none; b=o8Lw+uw0xHrPCL2h/CtQEWahD7JckMyghEJTvkyTmX3i28osgwqa7gKs7CMC/+Oj6UO6T5szclvHCpdxL+lAOpXqfJImt3I8U1B9OwQK6h3/020Y4zeFl1OyqLuxK8InYYmx10zmWdG5nXsjeS+s5vurfp0n1PayMC9sGva3AcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730001; c=relaxed/simple;
	bh=+rxsnZp6/KWp98j03MtWAGf1hDGpagfvnV9saVPDjXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c98RzyiHM5QeNhNyHW5ywXP6EvEHm6ia0PHHkL5hYGJabUN2+hJEGga9CVLjgadZmi+8bDkY9NnvAQramUEusMejgD3E2NmxNMMZbqQEKESKBKGUMW3ewn+atT8X3Lvx57qH1TD3I4ys6GO7Ma4NV+hgyISxr2lzZmu2JQYkvNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nn+rNk3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nn+rNk3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14F1C32786;
	Thu, 15 Aug 2024 13:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730001;
	bh=+rxsnZp6/KWp98j03MtWAGf1hDGpagfvnV9saVPDjXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nn+rNk3KEwdl78ACmfdGHLhZQo6S5O/Y2wzAgfPBAbcU0DHgGNcR/I4MzDZfLr5RT
	 3iqyBqiQfo+A9J5s3b5rpCe8NVGCQY9bpDkKB6wVynFcmC9/BsQnwO+il7sRrFNuqw
	 1lL9JNAmcDt7Xj9EsrSVLxoPguDnvAV3QIVhW+aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Tung Nguyen <tung.q.nguyen@endava.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/484] tipc: Return non-zero value from tipc_udp_addr2str() on error
Date: Thu, 15 Aug 2024 15:22:12 +0200
Message-ID: <20240815131951.989863904@linuxfoundation.org>
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



