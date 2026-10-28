Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217323;
	b=iorsCl1O9GffltXQuUgcpZV4qr7Cc7y9jCP9v8d8U9lph8XEOWVFOBcDEs8QbJwV+xNy
	 uecH6RlgZrDkNp6dHoWcNZjNkNRNhTkELZCAbJCAKDSEOHzrPqLPYsDAU+naqVz1SY22+
	 E+x9Wd37XgTSVd8/iyRmp6wYWcwsDUTpw709Saox+wYjWWPoelQafWbLvLG6DoMXTWn1C
	 sGRdiwipnVmShMUZsKHOoaCcrapdx+MUcGmFMuQj+pmvqJY2x1Q+Rq8kXqWLggN6smoeW
	 UPCMZCZXasWwjZB+4TiWzTROPEeKlgdMnruqNdjibHCBiR/fEpc/cP+oKuaZTGAn/fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oxFGg1ZTQ7mmr52YK+xujd9E58PFimlfI5vEkPmxO8g=;
	b=S9InawMTVMyqkp/G6ScnVK+IN3esqOLkVf89WIPEikq2H0voWmhX69SI+8dJD9whwNk2
	 A+lz6gQ+67/HaRG4reK4vF23hM4vYch3KaZlUMS0tJrZRD/WgyEV0el8N9n9JCmqH92BA
	 T+mXsmEXt/zb3SPYA8Wie4iiSCPweEv9AjdVmnavm0paV8vsNjU85tiKmOhVEFzp6LGMn
	 FfQWC2ToRo9HjL9E2oNSlqlIcEQCABSuSVZ3Nw+b8vJ448veqkDqEXqAxcE+c/+T9sxV1
	 aq9QI2s7OeIGS1KyUjKQ9fJntXntfSSLhqDHmb2yHQb7c44hB6mf/EPe8jhf8cXvOYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JwaDK4K2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DB8606A31A;
	Wed, 28 Oct 2026 19:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JwaDK4K2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5560C1F01825;
	Wed, 28 Oct 2026 19:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217322;
	bh=oxFGg1ZTQ7mmr52YK+xujd9E58PFimlfI5vEkPmxO8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JwaDK4K2SqPe15LoWH4RfQ0yUxSVy1zW6DlNQvJLglOgDyMQMEZ8kBvuUJPcCHKPi
	 FkhLotAaJb8wgSr3Q6sVL/DsiN6DUBQEfDMh9iMbLXwUmR6WAratpCtKXPXSacpq41
	 1G6gwAv4Ls+isEj69GOaRIgPrh4WRaIM+B7UvwX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1863/1887] smb: client: protect tc_count increment in smb2_find_smb_sess_tcon_unlocked()
Date: Wed, 28 Oct 2026 18:05:59 +0100
Message-ID: <20261028170541.847613690@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit 4d8690dace005a38e6dbde9ecce2da3ad85c7c41 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index f709bc3424dd8..b8441ffcff768 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -213,7 +213,9 @@ smb2_find_smb_sess_tcon_unlocked(struct cifs_ses *ses, __u32  tid)
 	list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 		if (tcon->tid != tid)
 			continue;
+		spin_lock(&tcon->tc_lock);
 		++tcon->tc_count;
+		spin_unlock(&tcon->tc_lock);
 		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 				    netfs_trace_tcon_ref_get_find_sess_tcon);
 		return tcon;
-- 
2.53.0



