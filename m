Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74FC4BEE20;
	Sat, 12 Sep 2026 15:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228404; cv=none; b=WZrJFZ5y3K3vcA8WhGADpkYuGfXgAew2Yg+AUakz0N2HzjJQ74EQOdusMTabqPIAjpAFEkEd3dCf0ZqR2dO5waIFkF6kBkwgpW2SjAv/gJq/liKN3jKdc3lKzvLaQ8lniaM2KCDYmZyd5TwHt9JbpGOZ9YeTQY8UBW8PdRBlLBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228404; c=relaxed/simple;
	bh=2mR95g3RIvOfzP+dpSDi9HZ2Fq+MXFwx5Ep9plVdZSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONQ8kykKoKX70jRw+2XtzD319gm6d8YKx27Ls0+HlMCLfZSwZtfkYUxiQJ2H7hukKDGL5Zy48kCo6mP9ula0I6D5ZP0Jd0Pci03YyZITbjph5Dm4CqxnTH3MIgzssv9or7UrWlsuy7JXvXQeaij/a/BPNyLKH+fCKLj+pNe1DNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yrs6AzI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yrs6AzI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945F11F000FF;
	Sat, 12 Sep 2026 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228402;
	bh=svBM7NmLhP3cSGDFqxyjNvtQpBYFxE4pJ0bjaXGYWuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yrs6AzI4p1E0501K7AfdYRH82BgiasN42kjS43qQi3n9WYd0o4Zm1WtYlBFq98GdF
	 aIFm/yNhxnkQrbO/TvGAxuWV3ajMsfjG4Yk8Vlsjq3R2g1I5V1hhRXPhRjbmZqHOar
	 KhmPAMEBtiP5DH+N4ft4hgx39mb+I27Sy7Py2vsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0326/1191] batman-adv: dat: avoid unaligned fault in IP extraction
Date: Sat, 12 Sep 2026 08:50:54 +0200
Message-ID: <20260912065555.549935516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 0121afa52cdb88cfb4d5d7bd126a23a9100121d8 upstream.

Independent of the alignment of the ARP packet in the SKB, either the
batadv_arp_ip_src or the batadv_arp_ip_dst will have an unaligned access
(on HW without native unaligned read support).

Use get_unaligned() to handle this properly on all architectures.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 5c3a0e553593 ("batman-adv: Distributed ARP Table - add ARP parsing functions")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/distributed-arp-table.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -250,7 +250,10 @@ static u8 *batadv_arp_hw_src(struct sk_b
  */
 static __be32 batadv_arp_ip_src(struct sk_buff *skb, int hdr_size)
 {
-	return *(__force __be32 *)(batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN);
+	u8 *src = batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN;
+	__be32 *ip = (__force __be32 *)src;
+
+	return get_unaligned(ip);
 }
 
 /**
@@ -275,8 +278,9 @@ static u8 *batadv_arp_hw_dst(struct sk_b
 static __be32 batadv_arp_ip_dst(struct sk_buff *skb, int hdr_size)
 {
 	u8 *dst = batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN * 2 + 4;
+	__be32 *ip = (__force __be32 *)dst;
 
-	return *(__force __be32 *)dst;
+	return get_unaligned(ip);
 }
 
 /**


