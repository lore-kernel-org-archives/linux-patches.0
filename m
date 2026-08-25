Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DFD2E06E4;
	Tue, 25 Aug 2026 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665748; cv=none; b=N/vD4mDyMgpKq8Wf4AIrjOCk6prZPoxKqT1nPomcY8nGwKpWxThGsKacE9OUI0LsS2V6VEDo/E81SbE4/ItTcPQv8Wqq5r3Z9tMV4Wj7N6WEQ/ejodg5WTqnVFPLSr70OIawj6RnJgkQYntJ5QEIX+HCLqctMFjyZypTer6yZr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665748; c=relaxed/simple;
	bh=8q0Lnw9kJwOXjFOi8yLOvAc8oiDGP4b0KRJKFSsRklM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgIch+PnhRG0cjY7IMDLK60tWz7N9r5vmAXNrCDubfOz6EhU9QZHq8aaDwHdNz6T35gnjtgDYDYNTsAZ7I7sYFppslXboVOhjTJZmQgCaIzEfysLumEXlyjsFW1KW/J3u1etJGQ9FteX/iCG1OvPePNZInL5bhmadiosfQXtdrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXNf2cgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXNf2cgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67E41F000E9;
	Tue, 25 Aug 2026 13:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665747;
	bh=ScI9I43TvK/UktGQt5x4xt5VJXvh285xDaQ4bTYlkOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXNf2cgzc+h5MQ1enceAD3m+/SSIEh6SyTVcF9qaDDeMY2X5pb0kj4CsNaUzvFh07
	 B9paEeHoup24kDQgTzx4KadxRTCRVSi8nqIu9OpN/TI92cngSdR6LNyqVRf8Uplg8l
	 DjGhtU0CMumHi8Tmfh+tSOUosUohP4pjwyTzat6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 51/87] libceph: fix OOB read in decode_watchers() via missing bounds check
Date: Tue, 25 Aug 2026 15:26:14 +0200
Message-ID: <20260825132543.849092773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

From: Pavitra Jha <jhapavitra98@gmail.com>

commit 00ead17c7de137a692edee59f2772e6af687e8eb upstream.

ceph_start_decoding() validates that struct_len bytes remain in the
buffer after the encoding header, but accepts struct_len=0 as valid:
ceph_decode_need(p, end, 0, bad) always passes. When a malicious or
compromised OSD sends an obj_list_watch_response_t reply with
struct_len=0, ceph_start_decoding() returns success with p == end,
leaving zero bytes guaranteed for subsequent reads.

The immediately following ceph_decode_32(p) in decode_watchers() has
no preceding bounds check. With p == end this is a 4-byte read past
the validated buffer boundary. The garbage value is then passed
directly to kzalloc_objs() as the watcher count.

The sibling function decode_watcher() already uses the safe variants
(ceph_decode_copy_safe, ceph_decode_64_safe, ceph_decode_skip_32)
after its own ceph_start_decoding() call. decode_watchers() is the
only site that uses the bare variant, confirming an oversight.

Fix by replacing ceph_decode_32(p) with ceph_decode_32_safe(p, end,
*num_watchers, bad), consistent with the established pattern.

Attacker model: a malicious or compromised OSD in a multi-tenant Ceph
deployment (e.g. cloud) can trigger this against any kernel client
that calls CEPH_OSD_OP_LIST_WATCHERS, without any further privileges
beyond OSD session establishment.

[ idryomov: trim changelog ]

Cc: stable@vger.kernel.org
Fixes: a4ed38d7a180 ("libceph: support for CEPH_OSD_OP_LIST_WATCHERS")
Signed-off-by: Pavitra Jha <jhapavitra98@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ kept the tree's `kcalloc()` context line instead of upstream's `kzalloc_objs()` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5090,7 +5090,7 @@ static int decode_watchers(void **p, voi
 	if (ret)
 		return ret;
 
-	*num_watchers = ceph_decode_32(p);
+	ceph_decode_32_safe(p, end, *num_watchers, bad);
 	*watchers = kcalloc(*num_watchers, sizeof(**watchers), GFP_NOIO);
 	if (!*watchers)
 		return -ENOMEM;
@@ -5104,6 +5104,9 @@ static int decode_watchers(void **p, voi
 	}
 
 	return 0;
+
+bad:
+	return -EINVAL;
 }
 
 /*


