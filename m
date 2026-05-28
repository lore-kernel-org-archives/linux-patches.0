Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD472F1FEC;
	Thu, 28 May 2026 20:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000497; cv=none; b=KCcCVvBs+3QBzZLgq2/4G6dHVObYuI5cXeB7UJELj/AGSXKjS7rKiaRm0OSLek5aNuOTuwitOkGi4OKJ9dLXKuTM+Rij0Gok7npIv0a8IG9wijx9P8LWclRRTZWDYhjdRvGe0UqhRhQs6h7YfQ+LLN0aa0Ln/OSXhDoxILF4kfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000497; c=relaxed/simple;
	bh=0wSvuOAL5KhCRo+9lOEeHso1TXj2guotSDw7OeZRRdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXkrbuFFIVrW28fjgJyiVKiULUdOP6dWaCZNhowxrEbfY2rSXvW14/rxC7dU+YGoG8Xbjn6gR37Eh2D9Yagpn9PL1WZqYHVN5DGZ7zXLEgMpSsEN9C+XJ8FROg3BWqtbuChxHufoghUjeNvX1V6UC5TeDKg5yBo2qggtoUFazfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lk6yvr6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lk6yvr6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968D61F000E9;
	Thu, 28 May 2026 20:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000496;
	bh=fEVBkcLhwdR+w5tlX+D02/CZ9ITVHG+H6KiK2fSS0+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lk6yvr6dZiIhUBG8+5lPX7DgoL8avZfiDxQLpsjavM4i6bmg6JSha3KU0beCBausW
	 pnuatbwIGiLkIQXIRA0090BiMxys47pUtYjnnysQF9Khq/KxGuFkt7qynDhCj+eqIJ
	 3uR9dqLa/o6XGqz0kEZqYs593lFSlQvjYQusPc3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 048/272] smb: client: protect tc_count increment in smb2_find_smb_sess_tcon_unlocked()
Date: Thu, 28 May 2026 21:47:02 +0200
Message-ID: <20260528194630.727278364@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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


