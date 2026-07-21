Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD7846D2D9;
	Tue, 21 Jul 2026 18:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658709; cv=none; b=CxwWhfYrnyFuekVBmLKby6Hsc99IiC3fZp/olSLquuAxSFfmoGysvlxQ7z/tMuwKxv2Ay5eNdDusLkZOVAxguntQtSXxMxgHUM1ABohZCjl/w4v/Cad2RRVC6FQ49j3UPzhey/V4O4RRNycFNHB2OFGdeoJ3+o/xWGkC9uc8MGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658709; c=relaxed/simple;
	bh=qJWrZOHmaFkuhnunAwXm9YfSpmedepJoFRKxosy7cGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zm0TIv2uyir7DWCeltiSXmiKwj+3BqjjvXMuqtCRTTwlJC3OoNq8WG/MlJmi0qxyclCL52wB+yKVBoR9QlGuOEjWXlDboMljt9WQe2l6VVGOnXBoqCi3svWQcGDMfgFrYICVKrXR5zQv3m4e9W+c3ilQDAdsd1ArIP2WeXxROWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOXwQ8NS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOXwQ8NS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B68E1F000E9;
	Tue, 21 Jul 2026 18:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658707;
	bh=7z4vH1yQZvC/Sem19fEiqJiEaPbT5HKb8XYrpwnXxO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOXwQ8NS8Y/7hbG6Tiy/jX4yfxZonPH9xF93xXqLOnBms93jRH7Kx80FWa0bZhqE5
	 KXc40FCW9DnbS8LJpg5sfTWhE4KKBcJKAKu3NSue9jmzBpgycfHhumbvh7WPNK25SK
	 ExaiGrgsWqH1j28GdngTUoqtTNMt/Tc3FrW0Mn3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1208/1611] batman-adv: tt: prevent TVLV OOB check overflow
Date: Tue, 21 Jul 2026 17:22:04 +0200
Message-ID: <20260721152542.605666051@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
 


