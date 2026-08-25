Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBC847D949;
	Tue, 25 Aug 2026 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666448; cv=none; b=gITsg9nai3cD2LWu4LfplMb7qGMU67cvfnDRdmej+30jt2ks7Wg+qB8pcpBkpq4VRKGplb1W8HRc/Epql+eJTY3dd8wrUyinGRwBConlWMvJqrmbVZk7TzJqO7fjBnWEFXA9gbPe1KKOnHS0r7m7C9pOKM8t2cOg74xiS7cDeM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666448; c=relaxed/simple;
	bh=rgEOUiGLakZuNyvlLi+u6iOhzdaUAft4aqYmBmrxy04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfOlsbET2jUpCoadOhjMqMAsNNGozXVhxZSle2T9YtUgk9LA0hIVjGn3gTLhkCIFwhrokRh5Xeo1GxiLd/MGBhJSZgQSIsg1tAqLJ2BHsWi+VoIRjrxtS7U8ZKE5/TIQZGlkfs8VZRdU2j+TTBULZ8hKOMVPMH6/35Rn6nx+Mmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6bp5ROO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6bp5ROO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8481F00A3A;
	Tue, 25 Aug 2026 14:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666446;
	bh=rQ6wuTq1yFBKUA2YdA8yK0qYs3nXYynOX/2jCZZSdMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6bp5ROOoxoueYDdXw9wTWqhMb4UBS5G65fDzyF9PBFqrzjgMboX+kO0AgbF+EDyn
	 ZpGr1QtJ/uwRbMjITBReVoDhvNZwez6CyxWyPRer9jwIiOmrRArRcMYSmXeGuWU0kU
	 P4zkOg++lrbLXLUXWb5ColdPAxC83APe5e/bBEy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/57] libceph: fix OOB read in decode_watchers() via missing bounds check
Date: Tue, 25 Aug 2026 15:27:07 +0200
Message-ID: <20260825132543.099548855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavitra Jha <jhapavitra98@gmail.com>

[ Upstream commit 00ead17c7de137a692edee59f2772e6af687e8eb ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4993,7 +4993,7 @@ static int decode_watchers(void **p, voi
 	if (ret)
 		return ret;
 
-	*num_watchers = ceph_decode_32(p);
+	ceph_decode_32_safe(p, end, *num_watchers, bad);
 	*watchers = kcalloc(*num_watchers, sizeof(**watchers), GFP_NOIO);
 	if (!*watchers)
 		return -ENOMEM;
@@ -5007,6 +5007,9 @@ static int decode_watchers(void **p, voi
 	}
 
 	return 0;
+
+bad:
+	return -EINVAL;
 }
 
 /*


