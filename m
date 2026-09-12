Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A622242D65;
	Sat, 12 Sep 2026 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227058; cv=none; b=B0DVFYXlGnWrsb/RlCPGA6GxgtjMBg2f06373It/1cX31/2gXqa5FApjw8g0vFSaMQH3F16CsrvCoqq/y9uFHGbaX0G7iOw3kwcTB3gvjbfi8Pp3yiM+l7HISc7c+HWgqVbpX6azl8rkaIGI4sS2nff419kjpL++Oo2JXZhhnRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227058; c=relaxed/simple;
	bh=LTKvS0CGYAZfOe+aHAgLYbrglRmg2roNjhoeShwOchk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOnD6nyxBBmqR7dpDurNsRp0RMWQ40RWKqQzt8fNiigR3xz4CBBkm67R+dIJgFqJSKUDhKzM25AEqtcQrWaVaI2nYsgPIPkzJRUKD8FlWeSfcizkxH48J9tDKNERrM95oYPJHBWwIg2u8OZLfcWoc/alTVZPg0vxA9XU90V3jn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OF6dpq+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OF6dpq+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFC11F000FF;
	Sat, 12 Sep 2026 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227057;
	bh=HgP8X+VpdtTbZ1UZXymiOGvFQBhGuF1RHYqpvUXrFNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OF6dpq+g0ewYdYfTiowRSiqeZLC6kE8KbWDUVV/MXAyZhcvODuEg5XzqGmnHYHxSR
	 rB2Q3gsrV1kUJzQXxnUV5vJO1deHz/8pZ4tqctlUBLCQhphx7YjUfDg3Zj7f+VqKoa
	 eg+jSIM2AJLNggCHzQRB31y8M2jNpsIpdsCErfVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 0060/1191] libceph: reject buckets with mismatched CRUSH ids
Date: Sat, 12 Sep 2026 08:46:28 +0200
Message-ID: <20260912065549.501851604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


