Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738A64D37A2;
	Fri,  9 Oct 2026 14:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555806; cv=none; b=biaMzl/aiTENW+Hqlo2PaFpiH5GZ/C6AXI00uDWYwJffKBIb1frLCe3m6wElq+qwycULORIAFMPAoDJ8zdzmeDzMHI3ZnE785mWmRfp841WJ02IFKk7KM6uOLtzls2xUSsD7qH/aAvqjMC99a3siuEdHLjYQjhuRah+uJ2HIG+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555806; c=relaxed/simple;
	bh=DjPaHy0upUDEAkAfRe9WPtHRxwvNW1WKfhG6dtbneZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlU1owd6gjUIPphRnRE50n1DRjTGlXenn+EGyaO2xEvou/NOmUa0enTRX9ykZE2LqQFhy1N8/boKqDb2Z9z0zjlHEo+8VQOq4Bu2drhw4J31FdtFlh3u/MUJKZzqSanX0g7nlYIDyK0NFVUUgXOtHVqnCR1uv2JM58EaccZ1cm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFkGl9N5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFkGl9N5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D102D1F000FF;
	Fri,  9 Oct 2026 14:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555805;
	bh=eoirqrQZ4lRR4/watMBtQL1AcfDvjw/H6v00LjlRnUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFkGl9N5uDPds4Ygel337Gn3yqAu9fN0TH/4ftLND+jc7Q+hCXNYqBLmzWosc/P4B
	 r/jyWAaGJqtRMHAv/jO7hqUEVVcHUTDEOqMm0DxIviGpRpUWkWtdNScylJwntCzScQ
	 OyIqazjINBXxCYyalOZb5pGOcRwm4v5+LqV4iSZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/403] ipvs: do not create invisible templates
Date: Fri,  9 Oct 2026 16:08:02 +0200
Message-ID: <20261009140954.908727105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 616cf5c06934364ab1002b420ebe975850b4b208 ]

The IP_VS_CONN_F_ONE_PACKET flag was implemented for normal
connections. When conn template inherits this flag from
dest->conn_flags it will not be hashed. As result, we will
create new template for every new normal connection.

Fix it to allow one template to be used by many normal
connections.

Fixes: 26ec037f9841 ("IPVS: one-packet scheduling")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260916231652.127456-1-pablo%40netfilter.org
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 7da11628073b9..6bedad1f48fce 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -591,6 +591,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 	if (cp->protocol != IPPROTO_UDP)
 		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	flags = cp->flags;
+	/* Only visible templates can control multiple connections */
+	if (flags & IP_VS_CONN_F_TEMPLATE)
+		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
 		/* Synced conns are hashed, so they can not get this flag */
-- 
2.53.0



