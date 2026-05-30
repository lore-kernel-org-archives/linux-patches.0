Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9497A233952;
	Sat, 30 May 2026 18:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167085; cv=none; b=DK3B4RPOJU7QcVLUk2Y0ZiCw9TSBECM9udq4mG9rm21g7z3LhVqLHYw4H1uRzayzjY+sIjzZMWiyWpXvsOYmfxcD8qFySJW1ek7UxkWvA1hCycIqW3fbSxVK9gekRmK02cfEiM1GBeYnrxIQI7QUk5OLwUnmzQgvaaYLJMEg4QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167085; c=relaxed/simple;
	bh=8RgCTmyN3eAwzEaBFlputksJ3vGlajKEK7RVOqT5hkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=te75nZ3gRGuHwQxA4SsOeVPu+K9fXD1pThJy/ufBX2Wg3ZdULEjRoL/IV25jVa8g51ux3BbQfN24euDnhoTASAGUb7qB8ecy5h3QZPQR+JPnTa0X8H6pJUbOLY58L0/ZawP3RcqPws8UTgjb8PHL9/x6wkPw5LS+0A5Ry8kYyGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7kQVayT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7kQVayT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D891F00893;
	Sat, 30 May 2026 18:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167084;
	bh=xscSBjX3cUGcI8359gWb2gg18zrfhurvsd0AJ+PESmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7kQVayTMYjvBYecBYRDsP9R1mmqP4+4MkWL37nOYittOLMB/fnFUUrCfQ6ZTFUiw
	 LHqxpHro3nhDHsuiQwhlV9SDwqC0CyJn4h+WhjpPWAQVb5GwgIQTVHQJ+0RFzi8RZY
	 G5cCr/3Wlc6W3ICo4eCHD4cSKS3GeXo1Q19OFoOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 559/589] batman-adv: tt: fix negative tt_buff_len
Date: Sat, 30 May 2026 18:07:20 +0200
Message-ID: <20260530160239.342878099@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit b64963a2ceeb7529310b6cf253a1e540784422f4 upstream.

batadv_orig_node::tt_buff_len was declared as s16, but the field is never
intended to hold a negative value. When a value greater than 32767 is
assigned, it wraps to a negative signed integer.

In batadv_send_other_tt_response(), tt_buff_len is temporarily widened to
s32. The incorrectly negative s16 value propagates into the s32, causing
batadv_tt_prepare_tvlv_global_data() to allocate a full sized buffer but
populates only a small portion of it with the collected changeset. All
remaining bits are kept uninitialized.

Using an u16 avoids this type confusion and ensures that no (negative) sign
extension is performed in batadv_send_other_tt_response().

Cc: stable@kernel.org
Fixes: a73105b8d4c7 ("batman-adv: improved client announcement mechanism")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -455,7 +455,7 @@ struct batadv_orig_node {
 	 * @tt_buff_len: length of the last tt changeset this node received
 	 *  from the orig node
 	 */
-	s16 tt_buff_len;
+	u16 tt_buff_len;
 
 	/** @tt_buff_lock: lock that protects tt_buff and tt_buff_len */
 	spinlock_t tt_buff_lock;


