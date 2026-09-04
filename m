Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DE438E8DD;
	Fri,  4 Sep 2026 05:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498869; cv=none; b=Pideu0C1eNqZSDLAkdQ8ANgYQJo2KDSHYaW9gmbDG0Ojy31vjFp1/4sg8qrABLRic6ARGfAn6rT/x7LjHAXHL+TaxdeywyvDoBVkIoAD0R9OidF21MgYmIHsEXLWUdYPqS7Vn8gZiZw+kntA5OXr5+jQw0u5f98JRROUHQuIeL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498869; c=relaxed/simple;
	bh=qzQkLC7BQJhmdHO8AlpQrrJdFlbldPQjLLrxlDM4jEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aR7sZ4YcQTSIi5HQBROB6BDHSSwGWa4LFJiOWQDVOmoqX+B8Bucqsy6WT6V6TwXHehAwdZltHvcuUl3x9PjvRW9CHJHoiz8I6/4de+QAoR74Ep5VEhP+jBHWU/LZY8viMLArC6pBqyJlYLKxSXSQ9lk90gBU/3zuq+iVcli2K48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klsZZ1Ie; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klsZZ1Ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403691F00A3D;
	Fri,  4 Sep 2026 05:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498868;
	bh=f2EPcbu8GgnyHPwV0XwfYbH+QAJhquNSzKqu7/i/XSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klsZZ1IeHFGy9nSTLkDkimrCv3Mwhs2HJbdtZScEtdz9xM4YZvYM/8pKk5DBGXLfr
	 M4g3qrOwrue1JqheIirGIcYsKHdK9y6dcWdtZDbTrp4fqRXV2HGH3pujT5wauPZfsC
	 XfEnhSG5SDbvPEC0fUiEmag22oASO7EWjxv3TSSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.2 214/713] libceph: reject buckets with mismatched CRUSH ids
Date: Fri,  4 Sep 2026 06:53:02 +0200
Message-ID: <20260904045808.614575179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -517,6 +517,8 @@ static struct crush_map *crush_decode(vo
 
 		ceph_decode_need(p, end, 4*sizeof(u32), bad);
 		b->id = ceph_decode_32(p);
+		if (b->id != -1 - i)
+			goto bad;
 		b->type = ceph_decode_16(p);
 		if (b->type == 0)
 			goto bad;


