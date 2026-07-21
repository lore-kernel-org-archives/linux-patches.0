Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F8E2BEFF5;
	Tue, 21 Jul 2026 20:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667161; cv=none; b=Zc2SYnIMgJvPyVMDUl7c0YKuPJngJTdZKOsNj4FsOoIw/a3ZM6WKnNETK1KxbaXrbHbfdlLaHCJ6FZaDo4N1uimquE/UHx1oWi+GcDaorx26L9+Tcey/OPOdlYk+SGdETq1l+XEdzE7Pr1KgVqpJgvnOmPRb34LpZMTDPMNphO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667161; c=relaxed/simple;
	bh=sX43/vXy39dQp8K9KhyExVqXMi0bATD1tS6EbDtUbWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzZexoIjEnbw0wcuY06SwKOYLtpGjK7s9y+vs3XHM3J1hzYvh63HDOQrirIHSTzkFRMMmggOgWIKUmF831KeoTVxPODIuZ8QDm+SwupJtYi/lmNWmG39rvQu55Uw8Bw4++GqxUeNeeX5E/4jKvA1RiZuyPAjx6txeaYbIsG7wP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF5K7eX2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF5K7eX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7081F000E9;
	Tue, 21 Jul 2026 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667160;
	bh=oop7iGJ8kvkCGv1r4OKL7BZyxE5IuBYc3WPDPUkv9jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XF5K7eX2LCFzZIjDMcN6lanGa8kUsmOFcM3xM/4kTq+Tt9aL3gRl9twC2TTU6Pp+3
	 YzLvA7SqSMQWnZETtBjH0Sq+wSTZfggqfAxTu1rijP+FANQNgG6D7aaGPw8DIFL7Ou
	 BYlPYxf5NVLllHal9e8osBUpvVmNgc0wHXC7PFJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 0955/1266] batman-adv: tt: prevent TVLV OOB check overflow
Date: Tue, 21 Jul 2026 17:23:12 +0200
Message-ID: <20260721152503.198354189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 7a581d9aaba8c82bd6177fa36b2588eea77f6e2b upstream.

A TT unicast TVLV contains the number of VLANs stored in it. This number is
an u16 and gets multiplied by the size of the struct
batadv_tvlv_tt_vlan_data (8 bytes). The size can therefore overflow the u16
used to store the tt_vlan_len. All additional safety checks to prevent
out-of-bounds access of the TVLV buffer are invalid due to this overflow.

Using size_t prevents this overflow and ensures that the safety checks
compare against the actual buffer requirements.

Cc: stable@vger.kernel.org
Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -4101,7 +4101,8 @@ static int batadv_tt_tvlv_unicast_handle
 					     u16 tvlv_value_len)
 {
 	struct batadv_tvlv_tt_data *tt_data;
-	u16 tt_vlan_len, tt_num_entries;
+	u16 tt_num_entries;
+	size_t tt_vlan_len;
 	char tt_flag;
 	bool ret;
 


