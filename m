Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB9B423A85;
	Tue, 25 Aug 2026 13:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666213; cv=none; b=bBPezLMP3mWYg1I6KRbqbs9cUKnDQAX9SZzmaDv03LKPV9Nyj4wTlmu6hX/ux1dR56mm5gsANv9Wdm/9AdN8EysWVCRI9uCKcWCdARIGYSsXIyCqlkC+vPDNmcX3v00S7fa+8Yfl158QSoLJUTfCQvw1ul4flfib+q7f4Hwe8pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666213; c=relaxed/simple;
	bh=k1jdPY2cSoqVSMi/DsM4bd0/1Yc2Gg4tidGpmFG5upg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ng3HrWm+XzmQDLvbucoR+SD6/OuFrks9IZVJftfeEuyJP2gnd2vLRHxkT3JzrkVNjdHWRVcTcJKzJTtLtUL2X0Cjqm7AvdS0opJjpjaVSH16COE4uH8fDj2cSyuNJxgc4AewXhyfMUmMBHQJcoWbQb8LhvagaYqjw8aA7+PZcXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmWqARUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmWqARUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF921F000E9;
	Tue, 25 Aug 2026 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666212;
	bh=va/L/IzCFldMALw+enGhExa0nmLSl9TgnYOpXvGK+3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmWqARUkVrynzXMqLqENaDJnRd1jpj4OT1lD6lsm510WCj7fJ0v/qxE9b00mPZcU7
	 9ogdrGIUPTT40izOu/0R8IY/Y3XjOeIRm4CnhkzNuRrjgLl0PKvV/loT8X99G9wBZr
	 XA6H01+Ml374v3Z+DtwrEMI9Cdr+YSQK/bvbc0Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 40/76] libceph: fix OOB read in decode_watchers() via missing bounds check
Date: Tue, 25 Aug 2026 15:26:33 +0200
Message-ID: <20260825132543.138211971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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
@@ -4995,7 +4995,7 @@ static int decode_watchers(void **p, voi
 	if (ret)
 		return ret;
 
-	*num_watchers = ceph_decode_32(p);
+	ceph_decode_32_safe(p, end, *num_watchers, bad);
 	*watchers = kcalloc(*num_watchers, sizeof(**watchers), GFP_NOIO);
 	if (!*watchers)
 		return -ENOMEM;
@@ -5009,6 +5009,9 @@ static int decode_watchers(void **p, voi
 	}
 
 	return 0;
+
+bad:
+	return -EINVAL;
 }
 
 /*


