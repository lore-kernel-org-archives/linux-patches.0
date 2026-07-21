Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE4A367B92;
	Tue, 21 Jul 2026 19:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663622; cv=none; b=MtFX3loUkRu4DNZ9GPYYelcbPlGzJmbwJ2EEnLUWK6TM2O4r2lOPPr/I2vEcX2cGxzTeUI/Yzd+JGTX80u0kRWTKA6lc/KWI9hGQy2Ket1l2hUvTEQ/BKt6tgL21WtOYm/b1vNJkx5zE/nvB+x4FXEWGVQi69QbKi+ogtymUd7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663622; c=relaxed/simple;
	bh=N14Ajg2v8jJQZWzZxsA1y0DJMTt5v41dXdUVLY9ByCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxJmE9SmDicV5/klp71xNDvNBPZVgYfk1UG7JeilPs1j1V2AP+z0rcO4ku8Or3ysCr0+eTIY4mxZJ3uHvhtRQrhHA2TSVKvevbPl+00WSZbBGh78lkp1Rb+2A+LacqrYpSf1Af4P1cdPaqRlnJp4kLguw28nMM7kdzNLHjPSv8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waururVI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waururVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AF81F00AC4;
	Tue, 21 Jul 2026 19:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663621;
	bh=SC5di6EXfGcaZhYEh0IReax1yemGxU5CsJmygYWhgq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=waururVIIwN0qSo+V9goVXEwNrUGE2I5Qj0HAbFwM55QZ+pUvI8I+vznMr7xA3r3+
	 FpAWuxDAo82QayTIJq1HEcFIXQuuOzbN78YxQTEgbdClVfpEUrhdeVe9NQKOzpO8mA
	 JNa3nCzOwlIHigBmefXw3jhCYEEeXQQc59Pb7uqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0893/1276] batman-adv: tt: prevent TVLV OOB check overflow
Date: Tue, 21 Jul 2026 17:22:16 +0200
Message-ID: <20260721152506.028132344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


