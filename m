Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A364647A0D8;
	Thu, 20 Aug 2026 16:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243238; cv=none; b=LYmm9wdMrkcD6v2Tiat2XKWw4D9RaBhykCQM5Q+dGYdJlQAwB6fIw8wP2BxMhihYnE5r7ot/LP/ni84eioLRgicvt8gZcVg1oXGFUYQrwgFd7dXE3pkMHFRjS2fjj+X2tOcSRjFwRh+Wo3FhDmDHNjSMMVWVAy+LrIknS0HEZFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243238; c=relaxed/simple;
	bh=PoEF0ns2IEL8mowM3YUsDoqoOo0jLi3waeKUvhGyN0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEdaUjA4apU/V+qIFroVpzcggGyzm/N2nECT6JcyImMWlhYjRaeHr6iPZuX9NqhC+PN4YMl1Q/nToD1Omnjy1kCRLySbtT4S1MwGnsn/hUwdFD0aZPiVMvMwrzBDBXIw5gIWQSsN23gMXm9l76zilKlQKC5ZOdjB9wJk72X75yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dci2OudU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dci2OudU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F021F000E9;
	Thu, 20 Aug 2026 16:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243237;
	bh=eou0UpdsrSrMiq4UVJKGkUEoXfg9tzQEjvCyENn8KTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dci2OudU8yvSFhSfp5XdlOmPsIeGcXbnmKY/YO0TeLHVBIwgph4LYFpUK/y6rxny2
	 bG6h5uprqsrMXhREY2Vj5krSX10ujDsGrtMFgN8z4AaUlufgWaqg37J6x13ybdnVmq
	 43C5Gkp8B2gYr6NCkn/N1GabLtiuz6qBTRJ20aMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 025/272] libceph: fix multiple unsafe decodes in decode_locker()
Date: Thu, 20 Aug 2026 16:53:29 +0200
Message-ID: <20260820145231.986432783@linuxfoundation.org>
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

commit 437b6551cfcc235eea1d735a874f9d421f555e17 upstream.

decode_locker() in cls_lock_client.c contains three unsafe decode
operations that allow a malicious or compromised OSD to trigger
slab-out-of-bounds reads:

1. ceph_decode_copy() at the locker_id_t name field has no preceding
   bounds check. With p == end after ceph_start_decoding() accepts
   struct_len=0, this reads sizeof(ceph_entity_name) = 9 bytes past
   the validated buffer boundary.

2. *p += sizeof(struct ceph_timespec) after the locker_info_t header
   is an unchecked pointer advance. A malicious OSD can position p
   past end, causing all subsequent _safe checks to pass against a
   bogus boundary.

3. len = ceph_decode_32(p) has no preceding bounds check, and the
   immediately following *p += len is uncapped. A malicious OSD can
   send len=0xffffffff, advancing p gigabytes past end and escaping
   the decode window entirely.

Fix all three by replacing bare operations with their safe variants:
  ceph_decode_copy   -> ceph_decode_copy_safe
  *p += sizeof(...)  -> ceph_decode_skip_n
  ceph_decode_32(p)  -> ceph_decode_32_safe
  *p += len          -> ceph_decode_skip_n

A new label is added to return -EINVAL on any bounds violation.
-EINVAL is appropriate here: the data received from the OSD
is structurally malformed, which is an invalid argument to the decode
contract regardless of whether the caller or the wire is at fault.

Attacker model: a malicious or compromised OSD in a multi-tenant Ceph
deployment can trigger this against any kernel client that issues the
lock.get_info class method (e.g. during RBD exclusive lock acquisition)
without any further privileges beyond OSD session establishment.

[ idryomov: use ceph_decode_skip_string() to skip description, trim
  changelog ]

Cc: stable@vger.kernel.org
Fixes: d4ed4a530562 ("libceph: support for lock.lock_info")
Signed-off-by: Pavitra Jha <jhapavitra98@gmail.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/cls_lock_client.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/ceph/cls_lock_client.c
+++ b/net/ceph/cls_lock_client.c
@@ -259,7 +259,8 @@ static int decode_locker(void **p, void
 	if (ret)
 		return ret;
 
-	ceph_decode_copy(p, &locker->id.name, sizeof(locker->id.name));
+	ceph_decode_copy_safe(p, end, &locker->id.name,
+			      sizeof(locker->id.name), bad);
 	s = ceph_extract_encoded_string(p, end, NULL, GFP_NOIO);
 	if (IS_ERR(s))
 		return PTR_ERR(s);
@@ -270,19 +271,23 @@ static int decode_locker(void **p, void
 	if (ret)
 		return ret;
 
-	*p += sizeof(struct ceph_timespec); /* skip expiration */
+	/* skip expiration */
+	ceph_decode_skip_n(p, end, sizeof(struct ceph_timespec), bad);
 
 	ret = ceph_decode_entity_addr(p, end, &locker->info.addr);
 	if (ret)
 		return ret;
 
-	len = ceph_decode_32(p);
-	*p += len; /* skip description */
+	/* skip description */
+	ceph_decode_skip_string(p, end, bad);
 
 	dout("%s %s%llu cookie %s addr %s\n", __func__,
 	     ENTITY_NAME(locker->id.name), locker->id.cookie,
 	     ceph_pr_addr(&locker->info.addr));
 	return 0;
+
+bad:
+	return -EINVAL;
 }
 
 static int decode_lockers(void **p, void *end, u8 *type, char **tag,


