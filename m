Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214513;
	b=s4gfj5bVWPbjsXC6V+tsjqgWgc8pPd5uBLnhg1HGAj2VAgUOKdspD4pnH3Wyu+FUNGwV
	 Ouu92OttWVM4gBy8jsavpfR82VeuRr2QrPMfU2zeFw4xcIJBOlRIp88uS2OjdDw9tz9Bm
	 uRk5iO4QLbEugiKBf2bY2c/L5cY74TNVM+CJEIScs2x9JNo1g4zOHEKiXE+5fQ3J0TdFg
	 O8/92TS+oj+7tlkmBhKsBxWY3O1aMIKJCgbwXrV2wAbbJ5fox4G9B+oW1KM4yru923ZeV
	 vB12xjz4RzfPGSxG1k5ulhZGa0iqEgOPsemxu/M5g1+2tCgVtUQ+F/y/8qoRyiZBi4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EjQ9vXECIlMTEhlZswhkpXWAytNgF9nps1E+dL7koz8=;
	b=IpUAlnryQEEhbMSwkKPuIlfUllaWjN/LKVZz/O/E74VwC7n2NlJ4d0tS9u3GskPRigUH
	 qLaO5zbADBDW6m6eeiXTOljeBXdBzTb5HQC3BeEwWg3nvK926T18Ow7nSZuud3WhOsLYh
	 cH0CuRGsmjnbUitnNaGsuaoerhZp5jrMshooBb5wO8uSF13mpo6vA7mjGBYSHsdMadcN9
	 2pcDkUj48hlmKtHyEKZ6+evrAEQNy7lO0qUWZn5gKm7PXEq94j4Xi0PanWAWOBhLSL+Lo
	 tlOc+FCef1WntPC0DCdIRaq+5b9qcktmX8+DrCA4v9KESgjUfFs5OqLREyyJNc9zyYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L522/AIO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C0A606BF8F;
	Wed, 28 Oct 2026 19:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L522/AIO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394381F01828;
	Wed, 28 Oct 2026 19:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214512;
	bh=EjQ9vXECIlMTEhlZswhkpXWAytNgF9nps1E+dL7koz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L522/AIOpCP4AaWJTll+3Pufz+3ACJ4AWP2vn/MKNC52/N4VQAe8nsBiUEbY+GG33
	 kem0pu1VAfU92uk7eYUWuLDa2JDQbqB98ooEEcTxeKBfEYATp4fVqjVi3ro6cfEYs3
	 AH98UFdMcUPzIfanbYFL7Irc3ugFUJrr+kRC8qDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0884/1887] smb: client: fix potential UAF in smb2_close_cached_fid()
Date: Wed, 28 Oct 2026 17:49:40 +0100
Message-ID: <20261028170519.538619343@linuxfoundation.org>
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

[ Upstream commit 734e99623c5b65bf2c03e35978a0b980ebc3c2f8 ]

find_or_create_cached_dir() could grab a new reference after kref_put()
had seen the refcount drop to zero but before cfid_list_lock is acquired
in smb2_close_cached_fid(), leading to use-after-free.

Switch to kref_put_lock() so cfid_release() is called with
cfid_list_lock held, closing that gap.

Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
Cc: stable@vger.kernel.org
Reported-by: Jay Shin <jaeshin@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index baca533953fd1..3ff56321b7a1e 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -354,7 +354,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			 */
 			cfid->has_lease = false;
 			spin_unlock(&cfids->cfid_list_lock);
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			close_cached_dir(cfid);
 			goto out;
 		}
 		spin_unlock(&cfids->cfid_list_lock);
@@ -399,12 +399,14 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 
 static void
 smb2_close_cached_fid(struct kref *ref)
+__releases(&cfid->cfids->cfid_list_lock)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
 					       refcount);
 	int rc;
 
-	spin_lock(&cfid->cfids->cfid_list_lock);
+	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
+
 	if (cfid->on_list) {
 		list_del(&cfid->entry);
 		cfid->on_list = false;
@@ -439,7 +441,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 	close_cached_dir(cfid);
@@ -448,7 +450,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 
 void close_cached_dir(struct cached_fid *cfid)
 {
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfids->cfid_list_lock);
 }
 
 /*
@@ -510,10 +512,10 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 			spin_lock(&cfids->cfid_list_lock);
 			cfid->has_lease = false;
 			spin_unlock(&cfids->cfid_list_lock);
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			close_cached_dir(cfid);
 		}
 		/* Drop the extra reference opened above*/
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	}
 }
 
@@ -526,7 +528,7 @@ smb2_cached_lease_break(struct work_struct *work)
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	cfid->has_lease = false;
 	spin_unlock(&cfid->cfids->cfid_list_lock);
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	close_cached_dir(cfid);
 }
 
 int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
-- 
2.53.0



