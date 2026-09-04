Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0842D738A;
	Fri,  4 Sep 2026 06:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502161; cv=none; b=mVTOtTSA6iOYOWK5BKnFRzCuFeCExLAzW9yfxrVTHRhBMnzY23Vubslkr2zytRDE2RMWoNXV6d8TdEm+whPp3viQ103N49ZV7QlbgDQgG6bvPV/9NMmFA5X6xMr7VbTr6Bzr7wneFx/cd17ZXqucdJ8EMyRUpb67VcSOb6ToIYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502161; c=relaxed/simple;
	bh=V12cs5XX1Byg3PG7ZIM4gX1J0GkmjWacndZ32wheS0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hoH9KbeaBqFBrMR3p2CHpJsoSbZEdCG4+vks6jdBsUOLQWQRXEFAnbHGuTspePaZbBeaw6bB9GdsLBIAZk2m+Z2QViJjkWFSGAmtHgkbwvUhI4cMIsbLRy4fw7eFpPrewzG7+MWl2kSpdGVGIKT/lGGF15wXDfrvW5HMn1OHDaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPsUYyMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPsUYyMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5244A1F00A3D;
	Fri,  4 Sep 2026 06:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502159;
	bh=R/NLLghFtScelWpZgsuM/l3MD/yW0ffZeQLQ4UFI0gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPsUYyMb9awmtr3qkfbuxUs574c2vc9IyDX3aI8+StIqHSY8DjtKf+7jU2paJVOT4
	 7YcYzczT3Uja+gQPP7g5gAtd4qdflwGFhHD7aBahEakJew8f3R1wRNu9xMRR+ZVmde
	 uEKYpzhX+tOI3LC2NUTtUdOh8QHABbvELHAfaL1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 110/403] libceph: reject buckets with mismatched CRUSH ids
Date: Fri,  4 Sep 2026 06:58:33 +0200
Message-ID: <20260904045737.330023162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -519,6 +519,8 @@ static struct crush_map *crush_decode(vo
 
 		ceph_decode_need(p, end, 4*sizeof(u32), bad);
 		b->id = ceph_decode_32(p);
+		if (b->id != -1 - i)
+			goto bad;
 		b->type = ceph_decode_16(p);
 		if (b->type == 0)
 			goto bad;


