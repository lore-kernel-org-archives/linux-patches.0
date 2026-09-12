Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498FA4322FC;
	Sat, 12 Sep 2026 13:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220056; cv=none; b=I8G37MZp0zNtAmYebyh4Vvtuu0bjqCRssLJpLZOOz6fWdXBJMCvfgyl1yfmGihol7Rkrj3tRFUpQGLY1J0kdQBwF8bKFnNBwABGFffH1vIS6MSd00Rfg9cDegtfh8nqZhiH3tSLpj0F4CD5jaB7PNnOrkQHEEuux5Npg6+0Zc0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220056; c=relaxed/simple;
	bh=lQz8856SLO7ViNio53d1f6H1qwZp5cgTClSxEilqlJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlN0H6m8PAEyEvLKyoWEfz2vkhJWd1fruY2i1FNfgk78HUP+NP8KOVcXFe3J4ghHsGx4IYM2IBmCPQNg1L4qYUhvC5aj6To/P5nbDJpQnA9448dyyuR+3F7t2fqUb888KnB3sHNtJtukFiUTCMBQKrZ62bv3NbDiygS89O3QhPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eljBfM3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eljBfM3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A9D1F000FF;
	Sat, 12 Sep 2026 13:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220055;
	bh=AqHFhWldWXKYFqMIWcrcZBRu+3MgcakwOFMfllkrWfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eljBfM3OXmlBNrvTT6VulML9Seo8iOEjNTewBPCntNngcScOQwr/MZgPINUPRT1qb
	 Wy19pRs8nYmmnUdBB4RTBUkvTM4K1qWuXqURFxtGKm8Uh7YTFpHuqgEc8lXrsRt726
	 BGi/6Zd5cTSd4XZGbtn+0neIA6RK0l3/9eKmDokU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 0072/1424] libceph: reject buckets with mismatched CRUSH ids
Date: Sat, 12 Sep 2026 08:41:44 +0200
Message-ID: <20260912065608.920241411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


