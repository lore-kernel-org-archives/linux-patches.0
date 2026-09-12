Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB88F47B439;
	Sat, 12 Sep 2026 17:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232653; cv=none; b=nMctubJylLJx9VVlt7RMfGSRwAMqdlhyL2BvekNVvmVdoB0Y1ge4WufBk0dWCCi/fFNcWnPyZosLl+EOvpOSwhdJpoWHYJzAV35BHfwlZ3mNR+6MNE6pZQrLYNHLTVKEWxUv6+D+6A2TuY5BbQa8UJ7KI2TLy3Etrey3WcQfGd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232653; c=relaxed/simple;
	bh=osuQQM3bDUARRiKUklCxSb5KFVQtqSTsOr0fVipM4NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WIK9df53I8c030FLIGJfDefB5A/H775FB79dopSsX3ifD45frzH/k6ThqSHPtQblHAguBj3IMIiKZ4yn8S9mzZ+dviLUU/PQrzWIQ0Mt3Vr5/2x0cf4jF8j2I19LA5ta/xNw3oToCVd75rhwYZNnfzdEBvccXZf9SridR3LX/UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlSuAskE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlSuAskE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8B91F000FF;
	Sat, 12 Sep 2026 17:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232649;
	bh=uDSCQgDRMc0ynmVfbHHiEnaexg6lVTwf4ueROBi6cMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlSuAskEEmh/TvTVvebe4s2gD+sRRAeOy8UyveD6IWHKPyBK+YpTUndP8ZCKfw4Js
	 vtCbu5Dd96/goPBhtT8N0WJM1dC9NSE6YmCAivLrUUxhOiuLT/ROlDeWXpKDGCATpm
	 MYQi05ox/zPKcIq/GiD4L05GKhuM9dQeI9iFWcrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 053/935] libceph: reject buckets with mismatched CRUSH ids
Date: Sat, 12 Sep 2026 08:51:23 +0200
Message-ID: <20260912065528.055366288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 3cde4a8302301679937474a5f7a851394cc1bd11 upstream.

crush_decode() stores bucket data by array slot, and the mapper later
derives the per-bucket workspace index from the decoded bucket id. A
malformed map can therefore make one bucket reuse another bucket's
workspace by encoding an id different from -1 - slot.

For uniform buckets, the second replica selection expands the source
bucket's permutation into that aliased workspace buffer. If the source
bucket is larger than the aliased bucket, the write runs past the smaller
permutation array and can escape the kvmalloc'd CRUSH workspace. KASAN
reports a slab OOB write of 4 bytes in bucket_perm_choose().

Reject buckets whose encoded id does not match their array slot. Valid
CRUSH maps already use the canonical negative id corresponding to the
bucket slot, so this restores the invariant expected by
work->work[-1 - in->id] without changing valid map behavior.

Cc: stable@vger.kernel.org
Fixes: 66a0e2d579db ("crush: remove mutable part of CRUSH map")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -503,6 +503,8 @@ static struct crush_map *crush_decode(vo
 
 		ceph_decode_need(p, end, 4*sizeof(u32), bad);
 		b->id = ceph_decode_32(p);
+		if (b->id != -1 - i)
+			goto bad;
 		b->type = ceph_decode_16(p);
 		if (b->type == 0)
 			goto bad;


