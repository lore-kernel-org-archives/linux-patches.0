Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5C93D1CAA;
	Thu, 15 Jan 2026 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498309; cv=none; b=bsPQ5+XNE5XBZE1BmbJoGATNOjJhnwZJlRwf8+9RAfpanKNwon5Z+PT69OyrY5SqSnr7FTfqlmBuzUGElLLGIiU9RidzFERVAxjBsjQcnzGXbzaz/kW1ja9TwU4Ytt84m4+d6OTaREL4Yp9p4MpTO2K2lKPOmOq/YBWIwq4zWzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498309; c=relaxed/simple;
	bh=2VzlfXVILUj97CxC5/VSQg6gP/cCd+7y8F3DMsbUkm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNhVVDNcYGdpho0lDIQnZJjAe9e92jV/I3O/HnnBggLhTQuyrX0UDqKhPrQTKTZu7xxxEBich5lC3qL8ol0pBsBlNSGUQxSTRYQO32CiWtC6MlTQX0nHb0pg2VOD7Wtgg+3NX91E6by05j0XiB97wHtOUkyvxHZAnRtNOGfWR5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwoS60p+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwoS60p+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE58BC116D0;
	Thu, 15 Jan 2026 17:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498309;
	bh=2VzlfXVILUj97CxC5/VSQg6gP/cCd+7y8F3DMsbUkm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwoS60p+H0SyJLyGGF1G9blAlOI9AtiNPbcSWk+Eqd7EcfMXY2XYQXgoaSH2JlwqS
	 /JRyVMxF9B0EfqlQRFUi0IFYNtsCXOzXwPZEv3izTUywMdAJBcr00ZrtZFY6zp9umg
	 bpHzX8BZnBtyrNdB8rUk/rOt0rUKeJt10+zXAp48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 353/554] net: dsa: b53: skip multicast entries for fdb_dump()
Date: Thu, 15 Jan 2026 17:46:59 +0100
Message-ID: <20260115164259.005944880@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit d42bce414d1c5c0b536758466a1f63ac358e613c ]

port_fdb_dump() is supposed to only add fdb entries, but we iterate over
the full ARL table, which also includes multicast entries.

So check if the entry is a multicast entry before passing it on to the
callback().

Additionally, the port of those entries is a bitmask, not a port number,
so any included entries would have even be for the wrong port.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251217205756.172123-1-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index d5ed733c0c97..a43cbb481529 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1832,6 +1832,9 @@ static int b53_fdb_copy(int port, const struct b53_arl_entry *ent,
 	if (!ent->is_valid)
 		return 0;
 
+	if (is_multicast_ether_addr(ent->mac))
+		return 0;
+
 	if (port != ent->port)
 		return 0;
 
-- 
2.51.0



