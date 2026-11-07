Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062758;
	b=3RA654rXUgLPWgqWd5Pq5bHQGq2kv7KAB88RKj+vB7p4t2LI1AnsuN+sN3rdcsLF+u4l
	 PAYBsEVGrf9hm3xTBg+EPo6wnICdVJ4gtfs6DJ3FYvk41hJEzwzmpyPwnijLrPASJorLj
	 SqneINuEcOAslsFC/LAzOOmpFc+SwcDKmjyAP8byrmTWAWcRPgOBMVYNVxYE0jpvoMtgl
	 sYOYrPak8C9OJn11wa7eMNXcBAP27874Cm/d29+LyOky45yDogEXo+82GTVpuTG4k/l0F
	 iehyIpD7em1UzqWhlbbAQ/oXnD63+eC7KrD7s8nyNweyhQHbz0jhkb94xCqyr5dhZsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tu+wimbtfaATCjqK/9oUBf70mIU7KAlY5c9DTp1g7DQ=;
	b=oJgpGZ7wSzqCOd0XR3kc1idx/7R8+qgapFfkjLbxfAgX7OgEf2YMpkSS1kwerU2iUGJ9
	 nHuoDMiXCiUXNt9exVjwtbLsj3t02vfGZqnS7y7abLLX2JwmdaUwE7uWhuYp0QiQsVFrY
	 nx7XiyGp+AOEjyJkheV1MOz2sEUxQu6a2G2OaATFz1rcD8mDmYp1tX6QTU9b+0mh6350a
	 bXHAXEdvrlenj/3MJBT+yHRUSgeDv2JrFg2W/uL70N/wF9hKa8wvhZRT0tmA5rYBd4Ptm
	 H8zgbqQHFTDCTRyqwQLVJCnk8RbsAIkZ73R+PpFti+6ZA6GKf8egOyjm5u9ArO6Nc5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YavcBX4U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600D4606A326;
	Sat,  7 Nov 2026 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YavcBX4U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4321F0089F;
	Sat,  7 Nov 2026 14:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062758;
	bh=Tu+wimbtfaATCjqK/9oUBf70mIU7KAlY5c9DTp1g7DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YavcBX4UP4joY7ZXNMSYPhzW+uiO0LgSBgfLHByv3LnvtSLmwWR0LfhjmyvOl8R7W
	 PFU0nisqRj4NmqScXHHQFmfbH7FuvOs9Jdl5Nr3n4NQfr5RN7UNyS7qmUFzNLpAjN/
	 b/kJa+dZq6YMIS52zdPG7UcEYHOPvKJE2RTQ2BkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/869] ipc/mqueue: release notification resources during inode eviction
Date: Sat,  7 Nov 2026 08:45:25 -0500
Message-ID: <20261107134853.596712666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit eb85469f0dd69ca145d63117450e14c31f67f698 ]

mqueue_flush_file() removes an mq_notify() registration only when the
closing task belongs to the thread group stored in notify_owner.

A task in a separate thread group created with CLONE_FILES can register
SIGEV_THREAD notification and exit without closing the shared file table.
If another thread group then unlinks and last-closes the queue, ->flush()
skips the registration and inode eviction loses the only pointers to its
resources.

The orphaned registration permanently retains the notification skb, its
netlink socket, a pid reference and a user namespace reference. An
unprivileged process can repeat the sequence with new queues and sockets.

No inode users remain during eviction. Remove any stale registration there
after dropping info->lock, since netlink_sendskb() may release the final
socket reference.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20260824042359.925145-1-4ncienth@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/mqueue.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 093551fe66a7e..11eaf5df3645f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -529,6 +529,13 @@ static void mqueue_evict_inode(struct inode *inode)
 		list_add_tail(&msg->m_list, &tmp_msg);
 	kfree(info->node_cache);
 	spin_unlock(&info->lock);
+	/*
+	 * A shared file table can let the notification owner exit without
+	 * running ->flush(). No users of the inode remain during eviction, so
+	 * tear down any stale notification after dropping info->lock because
+	 * netlink_sendskb() may release the final socket reference.
+	 */
+	remove_notification(info);
 
 	list_for_each_entry_safe(msg, nmsg, &tmp_msg, m_list) {
 		list_del(&msg->m_list);
-- 
2.53.0



