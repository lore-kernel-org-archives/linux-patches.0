Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AD11A2564;
	Thu, 15 Aug 2024 13:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728772; cv=none; b=o6fjukDbt25lxiXq7EKOV1wd1iQCcUKCmPQjfD2Zvrnaa34R9bNDLEQXO+AGTgPPWV8pavAaWw3oUspyVG9uQagOWso/kwFQi/awotx5LQqK6Pi1v0c109/LCBUcSEMR3zpG1u7ll/wlARC35rg5L7tbMEJmqRFUZE+16giwnOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728772; c=relaxed/simple;
	bh=DANKfrVSBRDYs7LpruvSwhbW00j75qypBKgOuT8oHiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSFXDvJU62A4z1lkzy8AFrcxYz6e5mw9BB4MNZWBenlESdq74+d0Ci1S61/ubCpPnlgwoIM3389BFz2OxPEhNcs4r27NsOosi9XKDxE2lUyPMNYDCHhEXx5T08jnDmeKyxNPe0E20D+XsQ3yShlJr357U3osbY6y1EubLJ/e+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWf0O8gD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWf0O8gD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5EEC32786;
	Thu, 15 Aug 2024 13:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728771;
	bh=DANKfrVSBRDYs7LpruvSwhbW00j75qypBKgOuT8oHiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWf0O8gDbkMCtWaVbhTXefukXX1Y7LhicIDPHIQCWQdYleWhFGBjnVL4l75w+o7T4
	 74u0o6L5VLBaV4FSw5mbpPtPN149aoo41Cn/QEUnMz9K7DswcUvPOBn38GQOJFmiD8
	 ykfEyGcAXuWg9AXLZNl8WPNFFSD7ynM4NpvsBecg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Tung Nguyen <tung.q.nguyen@endava.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/196] tipc: Return non-zero value from tipc_udp_addr2str() on error
Date: Thu, 15 Aug 2024 15:23:41 +0200
Message-ID: <20240815131856.061620881@linuxfoundation.org>
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
index 1d62354797061..796309b50bb6a 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -127,8 +127,11 @@ static int tipc_udp_addr2str(struct tipc_media_addr *a, char *buf, int size)
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



