Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951E143E066;
	Mon, 17 Aug 2026 15:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979524; cv=none; b=cpXNbiKUEzXV7+v5QptGko7qq0bJJ1XH+3dAcI2kPy51WYiVdb8pQhB8iUNbhJOycIAKr+yJlnxrn5+j1MKAgrRA/9qvKW+Po0HI92CE58Tfg82fVEk+e83biCQtKpTA4f90ru7cOw6+AEb1MX7tOVcd8e59wsOqThnuFVoA44s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979524; c=relaxed/simple;
	bh=kM9glQG3gvXw02tuhUblEBZb3kMIcbldDnYjflqlu0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyrkZA/n38MIHzDp8tfniX9VgcWS/k92YCN71ybIGYImwW0BjaLCu/lfSWW4LF1eFjeH2XW6t3QJX9wLeMBqWShe5aHvTyYj0sZuQtCpZcFjPprQwCV+62vBK5z1Xg9FIMafNhTq2rYviHqJYHlsxtMN9VOBkVmmr1UE062/m7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAgm+YCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAgm+YCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0605D1F000E9;
	Mon, 17 Aug 2026 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979522;
	bh=3HsuhoW/sQkq1CBDVHAO2FAHxDHYuhL8Jrjgq9IhRXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAgm+YCCFidpF5q/mfuuWRxNBNnIRrIIgN14TxtNRQU9u1hZ2sbVH9enMCEXaDL6x
	 jUOeiZKOIWYtN846RT28ucnlTsT5tZ5f6+ZD2CGaYr/QWeq2wNclfJFSPY6G50YPvW
	 S1ThlkR1IHUR4MonPNqYcZkCAhSIWzUpowvWETGU=
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
Subject: [PATCH 6.1 255/609] libceph: reject zero bucket types in crush_decode
Date: Mon, 17 Aug 2026 15:29:11 +0200
Message-ID: <20260817132552.633229858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


