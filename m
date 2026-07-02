Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C93C26F46F;
	Thu,  2 Jul 2026 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011500; cv=none; b=Pi0lJwlu6dPYfU5LFCWrn9ii+jlTueoqqGZfHZPbD6jSr8vdl7rOJNVLUMNLlXWiP8MrYhgj1efNq35JtYK749dsEiqgiHwFStMHOvdQTNRqCZF1cs16FcY2VrgzinLyIJUPk7mfTwR9deph3us2UrJtmP9J2Eo9SS18iA8QwnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011500; c=relaxed/simple;
	bh=OCnwdL3DWzidTCK/lHpJrE7qMduTaeoeZp2CMmArSMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c53swXBB0wB3uKlCu0boHr09xCGQt2s8jQXfhi6+7HW7eMfE3aEEW4808XfDJiHQijgM8bMT5dDX9GCH23+RGbwlOM++ASdXeELLThXqTKEJQE79tTGgnnQzD/74ectZlKv9e5SK3F7W3jbPwL+Cu4MQ+cm4bctqaegW85qhpZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oFZx3Iy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oFZx3Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DB21F00A3A;
	Thu,  2 Jul 2026 16:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011499;
	bh=GzNl/VTj7iSBWwVXMOqnCAqbhOSTKiZRan5xHAdBBcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1oFZx3IytCEK1VJlEDjHgioUYwNfVyh/P+to9FBIQGV4OA4rJ/DX8LxdEi207Ugab
	 JxEWITFpzDiBhFXwtHrhmm1H7Leb0Ap7LJOh/+mqeD9MG2SidNcILdvHzJDijTcwjT
	 2Z273M5J/mAcl9sW5Zn3fZ0++52i08PtU4JCsssA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 023/120] batman-adv: tt: dont merge change entries with different VIDs
Date: Thu,  2 Jul 2026 18:20:19 +0200
Message-ID: <20260702155113.440562633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

commit f08e06c2d5c3e2434e7c773f2213f4a7dce6bc1e upstream.

batadv_tt_local_event() merges/cancels events for the same client which
would conflict or be duplicates. The matching of the queued events only
compares the MAC address - the VLAN ID stored in each event is ignored.

If a MAC would now appear on multiple VID, the two ADD change events (for
VID 1 and VID 2) would be merged to a single vid event. The remote can
therefore not calculate the correct TT table and desync. A full translation
table exchange is required to recover from this state.

A check of VID is therefore necessary to avoid such wrong merges/cancels.

Cc: stable@kernel.org
Fixes: c018ad3de61a ("batman-adv: add the VLAN ID attribute to the TT entry")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 9f6e67771ffa80..acd8af4446671f 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -446,6 +446,9 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 		if (!batadv_compare_eth(entry->change.addr, common->addr))
 			continue;
 
+		if (entry->change.vid != tt_change_node->change.vid)
+			continue;
+
 		del_op_entry = entry->change.flags & BATADV_TT_CLIENT_DEL;
 		if (del_op_requested != del_op_entry) {
 			/* DEL+ADD in the same orig interval have no effect and
-- 
2.53.0



