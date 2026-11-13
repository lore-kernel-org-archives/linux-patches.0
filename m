Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585660;
	b=VsC0lXEl0jTBnqYdE8MPOLt/LCaA44k7tFzsBQFvNM9j+OJJwW5yX1SZvQep0HBwBYM+
	 A3K4ZN3Xcpr2YGJCaXgkeMYWveRnmk4F5kugwIR5920uMwArGw3r7wEn/mWJT3kuW1GvB
	 cjv5827wuc3mNUVVZ7WLzaiIOg5ncLkGgsmQAzgwAWPGgXyzDm4L11AFKxLFQzjVq+q1h
	 gEfjte0S80gCsQhNoJMxRKw0gcG38ZtNB5xUzs9NSAVV0ZgUaiJ5rNoBf0oq+6j9tvceC
	 pTZFGXaQzHvvoDFZ/kD9l+enP6HrYIkTwKe2Ir1c3Ed8a5o+8ytq/4+wmzypKGjtGQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rgWXrLxbqSq7+zISoxFGdAb9yYHtCqLBQcL0NxUZvAg=;
	b=y/Nmj6U47T0codzigyoloEN1Za19u+5FXybBSxkaO2nybxVpshOrUdsNGc6CwLu156Fe
	 w6RumBx8IZ/NOS8fG8nsGEO/SIsevmUzOe9kpEByTO2HrLICDrN1XJj/bCyVYmtHHJVof
	 VQRnkWELep0yw4RveFdpRISsAaoR608M6JoWvkxt1ehnoHQP5ZOUvgDR4syDMrynLM6OZ
	 XS4Cc03iVBEMDXFV/BoyoUzWiuc8JOksC4M23fKtCj3TFPWGlDHzd42msE1w2leDGkBlC
	 T0yg/CwqTN6VFC2124lc0tpPixU3Spt4Zt3t19GPU76Gl9F+C4eSJbCH5Fw4+i5B19w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=11H45MMX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7177606B5ED;
	Fri, 13 Nov 2026 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=11H45MMX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720CC1F000C6;
	Fri, 13 Nov 2026 16:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585660;
	bh=rgWXrLxbqSq7+zISoxFGdAb9yYHtCqLBQcL0NxUZvAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11H45MMX8odGUNvZrx2lq7CzWCx/HjqgwPWyjsyaOZ1PNQm35eAci/crRQWLMy1fQ
	 Kmtr3MeJ6GTe2CzR+kZeepSSJRT+BWK4di+/5Epx5lFYBByRDIivN2xhhZ+oFdN+Il
	 F1tY8r7ctHXrNZwXqUNRRyqS7Bpdp3NnMnseTFI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 273/507] inotify: do not coalesce rename events
Date: Fri, 13 Nov 2026 10:49:37 -0500
Message-ID: <20261113153803.959656105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



