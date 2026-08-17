Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A68427F99;
	Mon, 17 Aug 2026 14:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977086; cv=none; b=QQQUkNDE6H/x+HfgfMCG48bW9Mqh0IA9uupeE3+pXAbjIojavd08Z/a8uJwGBzpIIn60eq7cRh+99hQ9niclersdzKPQlSt+xWugzu1Eq+temqn98tef4DfKJ7uEvMXoxkqvhXAGSxHSXB/m/9Rsus718CIMUjOtZ83k7vOaWUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977086; c=relaxed/simple;
	bh=17tsyjZ3yuUisWwhfYSqDxyM1asTf6/FZw7Jg7IpIG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4IA8d3jKXFnD+rRdep0gf+QHuz22kvzwUqiAYQo8R5ZAqRnL0YODmPXVIS67SmYoqzVRv30DYO0nxdK5qo8Owb/xIHZGyX8pojxqhOwhiSk9ihAj5NPKo5Yhy9BWdpoKp8xTjVgc3Ig1GosW6TyTNVGChWbKtO+bpERjORJcRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTFR/D3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTFR/D3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021C01F00A3D;
	Mon, 17 Aug 2026 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977085;
	bh=oV2CB2ZhbJ00ZzcJ8mcY/tRv1Mb0zoQA1Arn8nSn01g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RTFR/D3/krI0ENZH2Wls7wuhfq1D+cTRg6LFdgVNcRMsAx+WW+SjuaWXZZnBs65s4
	 ql1vWE0KDNWn9WtMS6e5zKAEv//tGcTWgDY1DFg1uBRKo1rV21Ibl4W1B+T96x+ITZ
	 xsQuf033Ex5YCNA5Zkll6aC3RxB4ha0+bj3rJ54s=
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
Subject: [PATCH 5.15 207/456] libceph: reject zero bucket types in crush_decode
Date: Mon, 17 Aug 2026 15:29:57 +0200
Message-ID: <20260817132548.235553717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -504,6 +504,8 @@ static struct crush_map *crush_decode(vo
 		ceph_decode_need(p, end, 4*sizeof(u32), bad);
 		b->id = ceph_decode_32(p);
 		b->type = ceph_decode_16(p);
+		if (b->type == 0)
+			goto bad;
 		b->alg = ceph_decode_8(p);
 		if (b->alg != alg) {
 			b->alg = 0;


