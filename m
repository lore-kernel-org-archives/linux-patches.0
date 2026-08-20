Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0144B46D091;
	Thu, 20 Aug 2026 16:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243779; cv=none; b=pOlbg8vPLbwW1vI8Pf2DcLgCZxy7VntJ07TcX+c6GhfcvTj2v9X0exXc9EEO7hdh4fLzsVSY/26fK/txtQfGH3ck/0pArFJ21h1nV8Ij3pIxs5nlcPjo7WLqfI9HyGBrvHZ4DTYWiJxGvuYLRSINLBRRCJ5xOWzUOdkLqQcgkEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243779; c=relaxed/simple;
	bh=VyvcscIVzhZ9Yg2GilTKBtCHiROdXS3fTrJXSVkNW4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J23mh2ZfFgnIuJX2mXEitGUmzNVKlN4NTrPBYecPGAlngxjPQoSAWmOobSXXq2nLuYp0SIYuaUTdVkgv15HOvqo9DfcyGQKs+/yYj/UpU3ZM1PegHEkP12waN3Zyk/wq8KOk80i6xuHp15UEVC+S/7pD/EgwFAZeHGhbLLQKzQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOZrBxxZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOZrBxxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A81B1F00A3D;
	Thu, 20 Aug 2026 16:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243777;
	bh=EBZUx/32TEbOEYyDmsphW9R3uAjh3VvD6z/vDLTjGiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOZrBxxZppWl0CUXGGMRafqzgohotbo08MTmAVxRIHxvh9YKyIADBCgv9IF4cUakn
	 vJDguhdKyXouqCKu1neT7cfJG6oZzqIK9iXHsou6aQ7dboXZLxzTZR7kU4iXLQucj2
	 ak05yWF7UFvu9gkI3YKRwZv8Ouc8/bsgY9fWxz24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/272] libceph: fix two unsafe bare decodes in decode_lockers()
Date: Thu, 20 Aug 2026 16:56:37 +0200
Message-ID: <20260820145237.994288800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavitra Jha <jhapavitra98@gmail.com>

[ Upstream commit a109a556115271ca7896dcda7b4b7e45e156c227 ]

decode_lockers() in cls_lock_client.c contains two bare decode operations
that allow a malicious or compromised OSD to trigger slab-out-of-bounds
reads:

1. ceph_decode_32(p) at the num_lockers field has no preceding bounds
   check. ceph_start_decoding() accepts struct_len=0 as valid -- the
   internal ceph_decode_need(p, end, 0, bad) always passes -- so when an
   OSD sends struct_len=0, ceph_start_decoding() returns success with
   p == end. The immediately following bare ceph_decode_32(p) then reads
   4 bytes past the validated buffer boundary. The garbage value is
   passed directly to kzalloc_objs() as the locker count.

   The sibling function decode_watchers() in osd_client.c already uses
   ceph_decode_32_safe() after its own ceph_start_decoding() call.
   decode_lockers() was the only site using the bare variant.

2. ceph_decode_8(p) after the decode_locker() loop has no preceding
   bounds check. If an OSD crafts num_lockers such that the loop
   advances p exactly to end, the subsequent bare ceph_decode_8(p) reads
   one byte past the validated buffer boundary. The result is passed
   directly into *type, which is used as a lock type discriminator by
   callers, giving an OSD-controlled one-byte OOB read with direct
   influence over the lock type field.

Fix both by replacing bare operations with their safe variants:
  ceph_decode_32(p) -> ceph_decode_32_safe(p, end, *num_lockers,
                                           err_inval)
  ceph_decode_8(p)  -> ceph_decode_8_safe(p, end, *type,
                                          err_free_lockers)

The goto targets differ intentionally:
  err_inval: is a new label returning -EINVAL directly. It is used for
  the pre-allocation failure path where *lockers is not yet allocated
  and must not be passed to ceph_free_lockers().

  err_free_lockers: is the existing label. It is used for the
  post-allocation failure path where *lockers is allocated and must
  be freed.

ret is set to -EINVAL before ceph_decode_8_safe() so that
err_free_lockers returns the correct error code on bounds violation.
Without this, err_free_lockers would return a stale ret value (0 from
the successful decode_locker() loop), silently swallowing the error.

-EINVAL is correct for both failure paths. The data received from the
OSD is structurally malformed. -ENOMEM would misrepresent the failure
class to callers and to stable@ backporters triaging error paths.

Attacker model: a malicious or compromised OSD in a multi-tenant Ceph
deployment can trigger this against any kernel client that issues the
lock.get_info class method (e.g. during RBD exclusive lock acquisition).

[ idryomov: trim changelog, formatting ]

Cc: stable@vger.kernel.org
Fixes: d4ed4a530562 ("libceph: support for lock.lock_info")
Signed-off-by: Pavitra Jha <jhapavitra98@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/cls_lock_client.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ceph/cls_lock_client.c
+++ b/net/ceph/cls_lock_client.c
@@ -304,7 +304,7 @@ static int decode_lockers(void **p, void
 	if (ret)
 		return ret;
 
-	*num_lockers = ceph_decode_32(p);
+	ceph_decode_32_safe(p, end, *num_lockers, err_inval);
 	*lockers = kcalloc(*num_lockers, sizeof(**lockers), GFP_NOIO);
 	if (!*lockers)
 		return -ENOMEM;
@@ -315,7 +315,8 @@ static int decode_lockers(void **p, void
 			goto err_free_lockers;
 	}
 
-	*type = ceph_decode_8(p);
+	ret = -EINVAL;
+	ceph_decode_8_safe(p, end, *type, err_free_lockers);
 	s = ceph_extract_encoded_string(p, end, NULL, GFP_NOIO);
 	if (IS_ERR(s)) {
 		ret = PTR_ERR(s);
@@ -325,6 +326,9 @@ static int decode_lockers(void **p, void
 	*tag = s;
 	return 0;
 
+err_inval:
+	return -EINVAL;
+
 err_free_lockers:
 	ceph_free_lockers(*lockers, *num_lockers);
 	return ret;


