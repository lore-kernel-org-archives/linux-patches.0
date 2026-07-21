Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4840941F7C3;
	Tue, 21 Jul 2026 21:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670014; cv=none; b=Hk9tjyXqXoKAyqmcRk/vf8YIuIc0NlWz2okdi2JFQ1B0r2DqYJJostJ7AVEdHUoLJmunJF7/gAkLJWujyky5AEpepBAwECoM7TrlPqwTUWqKkKltvHJSbV1OSDHhlywBwuWHaMwOg1nzF34S9gRHOkQ96qdEx2K2Tw77YAI8mUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670014; c=relaxed/simple;
	bh=gC3Aey1Qma4TiEbMFLdiX6LFlK8wEI4vUJVQBs4+n+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ln1CEI8six1QPBNrt7o9J5vVYefIbFKnUGdIk0g4b1GAE8XwAzDNn3g+URFKsrNd5G+Y4/BvmdhKjjSxe9pg39bBC4QNYu5v2BM2zr4RdX9sg1d0E/cfvIcSNwnDsfVqckbkvwWd4EfVfF81oPkO8JVOxUQYkkR/kC9Y3j2TdQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vb6ihENv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vb6ihENv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF291F000E9;
	Tue, 21 Jul 2026 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670013;
	bh=/0fHxGupecRgWTHFDATdcSAKBmZ83gnT22WXJVWewLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vb6ihENvJZ0GDKsIUKNBiSqubVrO8OnKVeAYE5oiapeiqCmrCH4oKfBZz42yXaiAv
	 q9xgkx76G1BwlfUmrIAWbUTujH9MBXBQAZRui6LDIenlJVpXhA8BMg8JiZIgCaND7W
	 1clWr1t3c/0gyk0bgPs1gKHaJ+/qeyWuraQVTawM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0772/1067] batman-adv: tt: prevent TVLV OOB check overflow
Date: Tue, 21 Jul 2026 17:22:53 +0200
Message-ID: <20260721152441.840937649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
 


