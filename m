Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590375;
	b=k1UtGFXMBHM2wogXmycvZdOEH+gIT44K59q6mpBX50e7hVb8bOHCYswcljZBd0adslPt
	 ZwzAt0MRVO71wRuIIr/CpIKRuWwPlNlXnU9J53KBTQIE+He3ImQwTNdMEAYARfqqywtO0
	 rAN03YD34rLQXFmoTJ3Ep82jxpeEI3dM4Y3gBaysdjL/XHkx4np33iEZnHy2sl+sdj+P1
	 IEjxEHj7LQ4TYtJRjEma46tE+sc6kSyRhapd+WS/1ERjOilx3nYP3Ow9seT7wEjQHJGTa
	 08URE/jAAVenOPQvYBN0xLd/ya6r+voEUjKk/uowVNaYGFkugDTMJqh6N00CWxg6mNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3rKJ9L+M7mv0hfrFxlG/dWQYOZWhdlLsyIwr4ouHyjw=;
	b=tBOShIUkbI27yVnG+9GsarZ/zl/IrJ7BVs0Izxb7FJBNtq68pk3rtIWI6UqT2qnCeZw9
	 +mko/Z42kW6B+3JBszUv8BHrtkM4VgGBQkisPsOgqn3bcqEFArzfTBHxcOvaDNwn/Rdge
	 5dgH2BZQRyTUiwzAZFJuLMpn/0+M6us/EbKN8LqLPCeVm3r4OsS5fuMgymYMt7Qhy4hUt
	 S7gtMZ7cUx5cyIHpsWlixeVCG9DwAtyFFQsleDas+YymHA87h1j9Qgl6qUWsgPTzwm+nj
	 /Yq9r6OmMWwLgkM3WYasuJ23yfoS7ezzjaljDs1ANlyaSyMiWMiXjV7EG1UW4xXDruQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jELUt0Qp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09996606A327;
	Fri, 13 Nov 2026 17:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jELUt0Qp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692D41F000C4;
	Fri, 13 Nov 2026 17:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590374;
	bh=3rKJ9L+M7mv0hfrFxlG/dWQYOZWhdlLsyIwr4ouHyjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jELUt0QpimVArN/edY/Qqy5lra0M8SgIBwXHQISQTYgyIoa4MyOfTFs6RMlAjahIY
	 lq5fk0mCS2LPQCBW0cAjqULo/w4Yui/0TuRGg2XIkOPGsq/WotLhgT/izbcnC2K3VO
	 QjP5wv9YPHep9KblsGA3TNLd1E1C26EzVZvJpgpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 347/686] inotify: do not coalesce rename events
Date: Fri, 13 Nov 2026 10:48:00 -0500
Message-ID: <20261113153832.684771868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 581230d2ec3c0380917d1255792508851e7c4627 ]

inotify compares the mask, watch descriptor and name when coalescing
adjacent unread events, but ignores their rename cookies. Distinct
IN_MOVED_FROM events can therefore be coalesced, losing the cookie needed
to match a later IN_MOVED_TO event.

For example, watch two directories with IN_MOVE. Move an entry from the
first directory into an unwatched directory, recreate it under the same
name, then move it from the first directory into the second watched
directory before reading the events. The second IN_MOVED_FROM is merged
with the first, while the IN_MOVED_TO retains the second rename's cookie.
Userspace can no longer pair the second rename's events.

The original inotify implementation compared cookies before coalescing.
The fsnotify conversion lost this comparison. Do not coalesce
IN_MOVED_FROM or IN_MOVED_TO events, which carry the identity of their
respective renames. Leave coalescing of other event types unchanged.

Fixes: 63c882a05416 ("inotify: reimplement inotify using fsnotify")
Cc: stable@vger.kernel.org
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20261027192027.8617-1-dennylin0707@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/inotify/inotify_fsnotify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 7c326ec2e8a8c..6e3af6452dccb 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -36,7 +36,7 @@ static bool event_compare(struct fsnotify_event *old_fsn,
 
 	old = INOTIFY_E(old_fsn);
 	new = INOTIFY_E(new_fsn);
-	if (old->mask & FS_IN_IGNORED)
+	if (old->mask & (FS_IN_IGNORED | FS_MOVE))
 		return false;
 	if ((old->mask == new->mask) &&
 	    (old->wd == new->wd) &&
-- 
2.53.0



