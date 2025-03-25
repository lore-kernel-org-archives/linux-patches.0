Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7F02586C4;
	Tue, 25 Mar 2025 12:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906072; cv=none; b=ukdOof9VYiO4VVLGEelIhqFU9NeefZp0dMYf+c2Dh4thzJRwou7LFJGeehhO7bRFjeM2isXJN/UPsMLvF2uLAW7Y17kdRvpzerCW1ZCZK+AlGP3WwOPB2jvI+qopT6G9wXRVCfYHqLpJNVyX2WNEi8MxQUuDkLs6FtX35vT39uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906072; c=relaxed/simple;
	bh=QzZsJMUXWWMjBTYJJTz7MP6rzpZ4iGTW4p4czDySPOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWJL72fqmc9sashghqMSafzrPHAn6sXjt3b/Ymgkcu/e02/cYxYVldtvaNbrlkYRSHJ8OptwfCIjPrsT2vTvemQL3YoT6NX+8eje2Hl5hC9JvSVnF8pHSpZDlck2d7DddjGFMD5ROvZ5HidvqCIjQd8j/jweiOkC7weZaRm1mRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZW2dSk6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZW2dSk6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F60C4CEE4;
	Tue, 25 Mar 2025 12:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906072;
	bh=QzZsJMUXWWMjBTYJJTz7MP6rzpZ4iGTW4p4czDySPOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZW2dSk6jC09dEnrxzKcRa4a7P2bKBR5KgXOZ23R0qv4nJEma2NalmVo2mOaAxi9Jt
	 wsBr1ZGxoVWNv9O0I9LbTlXl4NJxd9KEZZl1bn+Q7htKvs2J/eia9ORqgfAhyPqAZg
	 +smNfGpz/T/e1hAX53nWJgGvLQn+zI7vno4Li5XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6105ffc1ded71d194d6d@syzkaller.appspotmail.com,
	David Howells <dhowells@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.13 089/119] keys: Fix UAF in key_put()
Date: Tue, 25 Mar 2025 08:22:27 -0400
Message-ID: <20250325122151.333793621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 75845c6c1a64483e9985302793dbf0dfa5f71e32 upstream.

Once a key's reference count has been reduced to 0, the garbage collector
thread may destroy it at any time and so key_put() is not allowed to touch
the key after that point.  The most key_put() is normally allowed to do is
to touch key_gc_work as that's a static global variable.

However, in an effort to speed up the reclamation of quota, this is now
done in key_put() once the key's usage is reduced to 0 - but now the code
is looking at the key after the deadline, which is forbidden.

Fix this by using a flag to indicate that a key can be gc'd now rather than
looking at the key's refcount in the garbage collector.

Fixes: 9578e327b2b4 ("keys: update key quotas in key_put()")
Reported-by: syzbot+6105ffc1ded71d194d6d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/673b6aec.050a0220.87769.004a.GAE@google.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: syzbot+6105ffc1ded71d194d6d@syzkaller.appspotmail.com
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/key.h |    1 +
 security/keys/gc.c  |    4 +++-
 security/keys/key.c |    2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -236,6 +236,7 @@ struct key {
 #define KEY_FLAG_ROOT_CAN_INVAL	7	/* set if key can be invalidated by root without permission */
 #define KEY_FLAG_KEEP		8	/* set if key should not be removed */
 #define KEY_FLAG_UID_KEYRING	9	/* set if key is a user or user session keyring */
+#define KEY_FLAG_FINAL_PUT	10	/* set if final put has happened on key */
 
 	/* the key type and key description string
 	 * - the desc is used to match a key against search criteria
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -218,8 +218,10 @@ continue_scanning:
 		key = rb_entry(cursor, struct key, serial_node);
 		cursor = rb_next(cursor);
 
-		if (refcount_read(&key->usage) == 0)
+		if (test_bit(KEY_FLAG_FINAL_PUT, &key->flags)) {
+			smp_mb(); /* Clobber key->user after FINAL_PUT seen. */
 			goto found_unreferenced_key;
+		}
 
 		if (unlikely(gc_state & KEY_GC_REAPING_DEAD_1)) {
 			if (key->type == key_gc_dead_keytype) {
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -658,6 +658,8 @@ void key_put(struct key *key)
 				key->user->qnbytes -= key->quotalen;
 				spin_unlock_irqrestore(&key->user->lock, flags);
 			}
+			smp_mb(); /* key->user before FINAL_PUT set. */
+			set_bit(KEY_FLAG_FINAL_PUT, &key->flags);
 			schedule_work(&key_gc_work);
 		}
 	}


