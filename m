Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029027;
	b=bltKQcppbD4gkv2aAQJ4mZGUnniaGL4GB8oVQgZMkA+bKb7WRt+xNjfVOUp/pWnrqIDz
	 mOIDK0RDV2xhZ8ZEYwBqREntHjmwsTnaxgkp9fbXUKpvPZRvcrmXZyn3+RKU9Uippb9up
	 OAB41wgfWf9nuXs3rJfEngcaG9e73+gYFAQgf9wxUwOWpRuyofTYrx9oa2li33Mznqa19
	 62508Wb7r9Im2L8668qRfEKVhIyhyRlIhnpmAWlU4PU0lM3HSbXB5EbN/cGWlV5xulMz3
	 gLG2ePy5rLifpeGB2ji357RFsTRQy8DFeQWDfc64XxvRP5Awcr7CnGaiEHg+j8io2Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/AoA+/cQsnWij2v6/PtYNB7B+jOVwfQ0uzftssZgdK4=;
	b=CvY53JbwUrVbFBXR0dXBBt7YW7jYREP9ObJM+/lTjY1TrdAW8tmdsdgDzxXHjHdgk77y
	 jlp2mpfu1qYX2l2stNK/Gye42sf7dB1l5KVaNy7oujPLoRa/0+1Q1PtQLIBl7vVKkoK8O
	 04nx17gTBAPv9eDBDEPgIhSH63bAME19du6VHRzv8J2FUkIXyPlWAULeehN010yTm6dmn
	 eY1ITiYUzCI1TJ912KNWtZdU4Cew7IKeHn4GPltt5bAhjmxJOBMnovdK0NtLTlVVsBEj9
	 Se7r8POgCYjt3ZZSwBhwlmwgGOjqPTmsuwjrkAxAEm1hRGYvZi/YV0Dv2ZoaVNlvgyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yl3lWjes;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF7E606A32C;
	Wed, 18 Nov 2026 19:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yl3lWjes
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2981F000CB;
	Wed, 18 Nov 2026 19:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029027;
	bh=/AoA+/cQsnWij2v6/PtYNB7B+jOVwfQ0uzftssZgdK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yl3lWjeskhsE0r59ljYTH8l8bJUGcyRCqpCJing1c28L9WFbaOpUAFjbwdkOJsums
	 64iI5p/c4yrtjs7FZLSIDbMtuWqbu/ijzcrL+8gI1W3841NXJk76Y+ljIlAHLCnt9x
	 0Z+fqN9MNo8F1XjgctPtUpuoKqcPPORIISMmD8vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Danila Chernetsov <listdansp@mail.ru>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0202/1756] dlm: fix NULL pointer dereference in dlm_dump_rsb_name()
Date: Wed, 18 Nov 2026 15:38:49 +0100
Message-ID: <20261118150016.414619242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit 19982c99a302ab544c69f95d37ca3070c89762d3 ]

The function dlm_dump_rsb_name() is called from receive_rcom_lookup()
when a debug dump is requested via a special RCOM_LOOKUP message with
rc_id == 0xFFFFFFFF.

The resource name passed to dlm_dump_rsb_name() comes from the received
message. There is no guarantee that an RSB with this name exists in the
local hash table.

dlm_search_rsb_tree() returns 0 when the RSB is found and stores a valid
pointer in r. When the lookup fails, it returns -EBADR and leaves r
NULL.

The current error handling is inverted:

    if (!error)
            goto out;

As a result, dlm_dump_rsb() is called only when the lookup fails and r
is NULL, resulting in a NULL pointer dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2d90354027ad ("dlm: merge toss and keep hash table lists into one list")
Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index ad0715f905195..18c4039058969 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1421,7 +1421,7 @@ void dlm_dump_rsb_name(struct dlm_ls *ls, const char *name, int len)
 
 	rcu_read_lock();
 	error = dlm_search_rsb_tree(&ls->ls_rsbtbl, name, len, &r);
-	if (!error)
+	if (error)
 		goto out;
 
 	dlm_dump_rsb(r);
-- 
2.53.0



