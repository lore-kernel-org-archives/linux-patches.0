Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523722F0C7F;
	Fri,  9 Jan 2026 12:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960774; cv=none; b=mjMC52vZYB9OkAxevWs1IOrCiL9vkzSyCLkh87G3PurkqT0nmvKmSL2RwNpr2uJ4PclKbFOdjb5d+ehdNcoa1Ia5faOS+s3E+JZHHg26K+JSZufjIRs4Hhlrpp6IbJjRy/7wDxTCbq3gnSxkeyPzM15FpuGbpwQ7Mvvh0WKAr9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960774; c=relaxed/simple;
	bh=bJfY/1pjgdq9jRyLvXcjPhL61O/6o/lnszWWkf4mCR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsvmbVJnmDNrpgWHZU36DeoIuaCV8HeGG6HCEcbUn5su0rQorHWJBekuSqg78fol9WFSozwCwo23EMIm6mOVavggN4NB3BeM2oSrY238IHd2tU2x1Efx1yiqBICRR/O5FbN8WnncCNRdeJomY47dgN0vtVhukh8c3XqYAECIo2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQF6igpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQF6igpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24EBC4CEF1;
	Fri,  9 Jan 2026 12:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960774;
	bh=bJfY/1pjgdq9jRyLvXcjPhL61O/6o/lnszWWkf4mCR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQF6igprSZeC2ocXhGdsTJ8knEPx6cm2e3O0iBVHUjlqgWyhsx7/waiI0qNNcTSdK
	 KZz8P8dnAb9osBg3lRSl5m0SOWfZKKYZb0G4rwlV0GWVoEaTIgwGNuVPuoWsOXVSaJ
	 0sTAwx1sx3sM+JrmB9Zkn82SInuvpI3zio7OUPuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 520/737] net: dsa: b53: skip multicast entries for fdb_dump()
Date: Fri,  9 Jan 2026 12:40:59 +0100
Message-ID: <20260109112153.560564116@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ffe8db7c2f1f..ee20f6487a02 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1846,6 +1846,9 @@ static int b53_fdb_copy(int port, const struct b53_arl_entry *ent,
 	if (!ent->is_valid)
 		return 0;
 
+	if (is_multicast_ether_addr(ent->mac))
+		return 0;
+
 	if (port != ent->port)
 		return 0;
 
-- 
2.51.0



