Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B09438399A;
	Tue, 21 Jul 2026 17:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654306; cv=none; b=EJQlSUIVnpWS8hD9wD6yxxcT1ghcsUmvUtTt4L4tvffWOM3pa16jWVltaNkdNwo2y4miqf7WSeJjaQZ1vwRgVa/LKCbZmCLQpy2Sx+NSCg67hoGPoR8j0GjWBnDbbxDQWBzK/kQGnOakl1x54vLCJcayQaaj4pdOptZjuWIQn6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654306; c=relaxed/simple;
	bh=QXSqCTr+qIBcZRhcgU+H4qm7yHfKDjiQu/UiUOqR7zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5tlGz6jsNeIRh+LXxHNiZUHBM6kI5zE2XAyFP4qYgop26unAxzU1+ubpS/Vgke8AUXodD8VCkYlzejcd6cZmPRJC7fP1hOaJfARjvbkFtIdlyAgTyZSOHVj5JE/D3NWD64lJ/6ClTibE1lp+OgBUT3Z5923z9aZE5vmoqJ1P8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfETv3Og; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfETv3Og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922D21F000E9;
	Tue, 21 Jul 2026 17:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654304;
	bh=LoDzIp2Nx3skatf0nbyEJXIWiYFI6gWC9q2GpD+YjBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UfETv3OgiI6EWSEz3KqSBwFPOwoAXCsDFYrwAah6Df4IcgaRE/JXTLbQdvEjXB83C
	 aUAPIJNLpeRUrvfsZX4UMGtB9YSQcZK6/pNWYsXC0m7YBEaruuhYe78hUXECgABT/8
	 pI3TD1ylQ3RaoqhlYCironqbEQJPF6Kb6/ixxYP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1652/2077] batman-adv: tt: prevent TVLV OOB check overflow
Date: Tue, 21 Jul 2026 17:22:05 +0200
Message-ID: <20260721152631.713571426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4025,7 +4025,8 @@ static int batadv_tt_tvlv_unicast_handle
 					     u16 tvlv_value_len)
 {
 	struct batadv_tvlv_tt_data *tt_data;
-	u16 tt_vlan_len, tt_num_entries;
+	u16 tt_num_entries;
+	size_t tt_vlan_len;
 	char tt_flag;
 	bool ret;
 


