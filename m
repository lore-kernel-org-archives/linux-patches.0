Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5192930676E;
	Sat, 30 May 2026 17:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162306; cv=none; b=AVJWrLVetoMzR7FZ335cKgWJXrc+HsT4sObnGOVufPTuEyZKDzza5zTVP7I3rNmRjXmHyRVnp9P/YkzG6oFjBsxQ+kr7vDaOZN9Rw0Z71LrgJ08W/4uIaig1/k1bAJHRHMCC4aSt2guqzkfCQ9Uz8zXXLp+jK1xoZTfoYbGqUmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162306; c=relaxed/simple;
	bh=9qKGrs4aLCN4pz3SojgFe1waPb+e3D5irGta45Kn63w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uf6g8YRT+qvNlI4h+NwT8nzXn913JuiS5EjWY/1KnpKv3iYyx/gkNcr80E1ZEeq5bsn6VHZfC0wEsDyiw8tMNdSBOwXF2N2lLU2SUwh6ym7t7pyEKQc8IDiHJEGr9ZRhN4eUBahSbvAfvxlzRqWd+8vOQxqVtMX5mjWuCuuqH94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+fd5v81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+fd5v81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D0D1F00893;
	Sat, 30 May 2026 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162305;
	bh=LcrFtK1HBqZUt0p+vIHhKw2jW5y2lgWhYd5LHifl+nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+fd5v81auHP5GButp0TY8iiWr3wckdrL7aE+hLZBWeHkEfalKp2iA5oDIZtAQvVU
	 pQv8zRbGJtWbhENOruzU1JFE02+czpuvM9wx5DcwEK+jKmc03mmTreSwrNB70tU+jJ
	 hoJX8PCy51mFw413aennClf9T297YGFn+CHMLCQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 882/969] batman-adv: dat: handle forward allocation error
Date: Sat, 30 May 2026 18:06:46 +0200
Message-ID: <20260530160325.046134893@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

commit 2d8826a2d3657cea66fb0370f9e521575a673871 upstream.

batadv_dat_forward_data() calls pskb_copy_for_clone() to duplicate an skb
for each DHT candidate, but does not check the return value before passing
it to batadv_send_skb_prepare_unicast_4addr(). That function dereferences
the skb unconditionally, so a failed allocation triggers a NULL pointer
dereference.

Skip forwarding to the current DHT candidate on allocation failure.

Cc: stable@kernel.org
Fixes: 785ea1144182 ("batman-adv: Distributed ARP Table - create DHT helper functions")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reviewed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/distributed-arp-table.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -698,6 +698,9 @@ static bool batadv_dat_forward_data(stru
 			goto free_orig;
 
 		tmp_skb = pskb_copy_for_clone(skb, GFP_ATOMIC);
+		if (!tmp_skb)
+			goto free_neigh;
+
 		if (!batadv_send_skb_prepare_unicast_4addr(bat_priv, tmp_skb,
 							   cand[i].orig_node,
 							   packet_subtype)) {


