Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F11E382F01;
	Thu, 30 Jul 2026 15:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426375; cv=none; b=NwpaLwvl7LkflKgmCiMPGZYN5Xeuh0ViFQeK6nO7FhBgt9ZP4Dt0rMcziLbW67ldvRbdSMGrpCHN/3g2BIktCFOLv2zqVSK/YP2PCQLJAsQlUtTrXI1h6Gv/YLUIFIcvNH1EgJ6JxIoX+GWMdOlWsVDZDlptKQyE9qaGDdfa+Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426375; c=relaxed/simple;
	bh=iSL1Xb0AC6XEe/I+uiohrnCfOoZ1JzJpWGfW4ohMTsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2Pnpi0cs38ZhEOTVhojAQS+xwm5EqJwmN3/Wgw20B9IPQeC9N7GeXVRxiFzQ0+vrJ+i7ep54+L9rsm1cICsce7On51xshSYkR27wlDM5JI5J80Q0oCaOmJuG9LiyvTvJXe6J/7jDCwzqLSe+utlRj55EG79E1MwDCk7AmXE0MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddKGw0C+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddKGw0C+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42621F000E9;
	Thu, 30 Jul 2026 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426374;
	bh=Q6jc8nWcBQZThTaoU+rXR+9agUpG3BQBcHKU8d46Fw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddKGw0C+8HRuXc7X7/YA3vBZkIcCtjz9FdN9v+1T9X0gpgZutHezG8v0KkUqiieWt
	 qkZoHDh5+Nw4sNDRE1Uun45rDQGzFQtv5qRGgX/Xno9IxuveCrQxzI8aBAxWGcCoOh
	 FJm5ThGGGMoaWKwGAQ3JxhDEua4xmUe5ADHPz3LM=
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
Subject: [PATCH 6.12 397/602] libceph: reject zero bucket types in crush_decode
Date: Thu, 30 Jul 2026 16:13:09 +0200
Message-ID: <20260730141444.302980569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


