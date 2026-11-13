Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591163;
	b=1w56Z7nVjSHuySD7oP+/1951DuWYkguK+y1Rw95dz4DAsc6L4PWU1igC10NDAORi72/k
	 vcFRBdwg0hDrj1JczqY58j5T5MTTbJ2aIK5LjBy5O+uldhYs43PkwnW2Ueb92nGckx23M
	 TOSq8PUMrIMSqJY8x79qyOFjzdTNOdhr2RQDgb/Py01JhEZymO+svqc+q+ZBjRY/Zn5RC
	 BiYIrESuNlnlx3gAN69LqKxwQVkKaFZXxUsfPdHy4HlvMovA7UK9UNESL1bV58eb3/3ho
	 ZPwuM/hg2ad9tzmRIG6O7V5ZT9CUfva/MhQHweVk295X5U28ybeTDwluzJ4h+9AtgvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e31ekx5+glIbJaZdFMgbNJfJTjK+oheCWzwbF9Mkq5Y=;
	b=BtYgywRAzduw/LrnpavcGTIDHw2PeoSkkIY5QtX954Pb+yTSKC5AqmRmup8DiOFTUEHq
	 69JlutRRiPtHvIHTtGgV/INSI6oFknT7RPLZlGIZ5XcDv7YIcIrO2u5UsOlI1qpciE8uR
	 +zgIXWFxh/E475zC9Pj2dxwNL5dbUlxnnnnU1ld5CLXMYEiOuwQMvOTKMLxFssOnj7vVR
	 5vIeydRFYqVdKDteD2esqD84VvOlQ+/vg+bq7gf0bWzibWycusJbE0QIreiOzJb7Elt4W
	 COuAx/4W77aohXnDfom0eg3q1h8ZbDlEbbD4qG2bLSL+Saw3BX0NXQBBBv7awyarWwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G2/6L49D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786CF606A8BA;
	Fri, 13 Nov 2026 17:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2/6L49D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241F41F000C6;
	Fri, 13 Nov 2026 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591163;
	bh=e31ekx5+glIbJaZdFMgbNJfJTjK+oheCWzwbF9Mkq5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2/6L49DcFId5pTrirC8U61se4menjlEF/jPexfrr+qzs6tvBw+hdV1ot8fZxzG7k
	 w660QyqgulVbI1VMudwwZWQb4+OpQXTD7zjH8WTdCtfrLDl5iFF3+Kgl6+eADusgyn
	 0GeFOCvEtQ7fyN3d4+10BY/PxxaOc0OYD3ampGOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/670] inotify: do not coalesce rename events
Date: Fri, 13 Nov 2026 10:47:50 -0500
Message-ID: <20261113153822.283874577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 993375f0db673..ff0af29745a8c 100644
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



