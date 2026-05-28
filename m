Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0511B2F9D85;
	Thu, 28 May 2026 20:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001229; cv=none; b=cyg7O2IxwLzp5io/4vCy4xzibchojBpvRvPUlEOEUQpy1ifk9jfCIJqJfbhW3mNSjo1IcxebllYfWsevt6DpqhOMNUEy6hav3aPW1wJG7t0c1svek2NdWwCw2mTZqffKgYPmKy+e2rYy1NFVZz/S17R+S5qWEZRkPLZf/vaFdsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001229; c=relaxed/simple;
	bh=ksVwvnZPa4KeD0tW4i2LxFylUgaAyRPztGDUnGQA6go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSWOvsUcCX3CfXeaJzjb9gQXhagAjbTBYAmT0y6Dr8NljIoAE6ZAf3RpJHATvQVwzANiN6rIEW/Teap5kyVwamilOa6r4oY/OM2flrOD178KTtRJCwEXJMA5KYplBCkob3QEWKC4eAUuYMGH+OjHB2EPPgZU3P4ryKmXEKkTVg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1dH9pC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1dH9pC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635951F00A3A;
	Thu, 28 May 2026 20:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001228;
	bh=5bZ48wh+otZeVL/heGNArsTP4bornnrfhQMmHDCryjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1dH9pC7zqFaJ6F9AKlZN+7W0vza0AX49/ThY9XKEn+Fw+Z3ig1SlfvQZixEqr+Sq
	 YSRZHRM79HCD3AUzD8X5/tYiB8YV9lHVkyRIHYLE8oeVKzNevzEEHLaA1NRe+TIcg6
	 4vY/24IxKdAKiRl2m9CJPykLKnVKVUhtQs+WBXpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 026/186] smb: client: protect tc_count increment in smb2_find_smb_sess_tcon_unlocked()
Date: Thu, 28 May 2026 21:48:26 +0200
Message-ID: <20260528194929.666705925@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 4d8690dace005a38e6dbde9ecce2da3ad85c7c41 upstream.

Commit 96c4af418586 ("cifs: Fix locking usage for tcon fields")
refactored cifs code to change cifs_tcp_ses_lock for tc_lock around
tc_count changes.

There was missing lock around tc_count increment inside
smb2_find_smb_sess_tcon_unlocked().

Cc: stable@vger.kernel.org
Fixes: 96c4af418586 ("cifs: Fix locking usage for tcon fields")
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2transport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -214,7 +214,9 @@ smb2_find_smb_sess_tcon_unlocked(struct
 	list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 		if (tcon->tid != tid)
 			continue;
+		spin_lock(&tcon->tc_lock);
 		++tcon->tc_count;
+		spin_unlock(&tcon->tc_lock);
 		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 				    netfs_trace_tcon_ref_get_find_sess_tcon);
 		return tcon;


