Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860E736829D;
	Thu, 30 Jul 2026 16:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427835; cv=none; b=NNVBNuXDW/KcR9ACAenunfpcJFVAbcibM0jcFtHdTxHQgSo16tpS3yN+tOGJRM9yrI/bLUAAOBjDZw1u7B0hAyxX8mPEjVLXF6yyw4yugBvc71hs+M2CwT056vO9X70DlyFvUn3ezUow42W4ZQ/JbVH1wtp+HoQdDeI9pTy1xlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427835; c=relaxed/simple;
	bh=hIjF/JFscCeWchAQXcqAu2HXip2Lpy6MrVQvweWdJ5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+kn4armul69ozC/oEGK//vJ93P99HhOQjKcFUkrXSxEQdwPbbkCJ3w6srWB6F4/NKNONCt8GW+yl4DTAsC3oZr+OJ14VwS9dqs7TBgWrBXEiLinJD0zA2mZceQOypOOg2pU5pNn1CI0URB24V2MXOILIGf3hMXgJSYpNKxjOpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIkDSBIO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIkDSBIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA881F000E9;
	Thu, 30 Jul 2026 16:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427834;
	bh=9aZT8xUjoIw0w/IElypCgbmjaHyyrIeX5PBC1PWsx00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIkDSBIOUffUs6R5qKOMrq8zVLiRZAHDZDVHXW8VlavWGH1/x62uyrCwlYeRN3Sv3
	 WFTOSzm282stIgZRL6ErbuC/CVlgdbCk9Ww9UTtAs1bY8x9A50zr9pFgGMOopxRhJg
	 +JGHYGDs9gTwtuSPjiZxsyxz1x6mG5Fqq+abzOpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Douya Le <ldy3087146292@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 309/484] libceph: reject zero bucket types in crush_decode
Date: Thu, 30 Jul 2026 16:13:26 +0200
Message-ID: <20260730141430.201114570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Douya Le <ldy3087146292@gmail.com>

commit 05f90284223381005d6bcddab3fda4a97f9c3401 upstream.

CRUSH bucket type 0 is reserved for devices.  The mapper relies on
that invariant and uses type 0 to identify leaf devices.

If crush_decode() accepts a bucket with type 0, a malformed CRUSH map
can make the mapper treat a negative bucket ID as a device and pass it
to is_out(), which then indexes the OSD weight array with a negative
value.

Reject zero bucket types while decoding the CRUSH map so the invalid
state never reaches the mapper.

Cc: stable@vger.kernel.org
Fixes: f24e9980eb86 ("ceph: OSD client")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -520,6 +520,8 @@ static struct crush_map *crush_decode(vo
 		ceph_decode_need(p, end, 4*sizeof(u32), bad);
 		b->id = ceph_decode_32(p);
 		b->type = ceph_decode_16(p);
+		if (b->type == 0)
+			goto bad;
 		b->alg = ceph_decode_8(p);
 		if (b->alg != alg) {
 			b->alg = 0;


