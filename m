Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045790;
	b=Iryt9amiiKh0s0vg4djyqpJAVjVet5PuuccbyqjvHecfHTKxVIoHVWYpPczqiyg3Sj3u
	 LNgSj8YQqh5+mVlPKtQ9xVS56d7qu65YiDpT7VOUj3GMOr/hmO14IssEdov78iEnbzOeo
	 g6HI/cPC6DUyR9CBCAiyShllk4Mqa8fXie17Kn2w1IOuLmI/x1MilHUJV3J6YDWUJHYr7
	 SWZtNWwSdYoA8J+hHReQjMkEWtckjqvr39Z5csl7Nf505brtiNdawn2oFxukMZ9hih9VS
	 05kJAtml2YuYiAYcJVDmd4O6O4DLX4x1pxzQ/XJ4i/qPfq6dHDjEyHH2bAMBCtne3bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d5DEv3sygdH7uYDKwepHc5x3mvXdkzK/1cnxTRVpPCw=;
	b=cpwsfspNojPoR44rI0C4udqhHU41ohPLyZZ9aC/NEY02di4i+HJHNDA0a1B8kcihQqGm
	 4f2wnGu6Kf+0Q0NxwwGxIRIViu2smcjbAc3uvss+I7JCAHE6ZziUwnv6r7GuaxiqsHfq1
	 j3e8htdBQ8dYPkQFfoUW9OIsltbkpZ17zmD8RFIfR3R/EFJGOiLaTZJfq7YrsIaaGOkGV
	 I/UVgtzuaYdPyU1VPaAP887jUDtwERhSs0iwbbK2FmmbdMHiDi1T9ADDeEYnS5BurrASE
	 /rnm374TWnKTTa60edUDX6uSCQfCfO3V8z3iQ7GH1BTlYYorvkvVohPmF0WE71IfV7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="E2H0T/MJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8CD606A325;
	Wed, 18 Nov 2026 23:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2H0T/MJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF20B1F000C4;
	Wed, 18 Nov 2026 23:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045790;
	bh=d5DEv3sygdH7uYDKwepHc5x3mvXdkzK/1cnxTRVpPCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2H0T/MJ0MqubYoNtLcSEdvwNqTWHJwe23Ab4zCZwVrgIpbGR45AzugvqFesHTow4
	 q5sOLgZznNTwQloIsOrJN/L3bc539q9NCZ3Wams1btkPgW8unms4ZDT4PQ92OC+oz6
	 ew0SPxrpXcnDHTIo9GD4AgTLBs1Cuvnf7tPqdqFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1049/2857] libceph: Fix unsafe decode in ceph_redirect_decode()
Date: Wed, 18 Nov 2026 15:34:43 +0100
Message-ID: <20261118150239.364796049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

[ Upstream commit 0405670e50f213594366ab7eddc07002bd7f84c0 ]

ceph_redirect_decode handles unchecked data received over the network
from an OSD. Currently, there is only a bounds check covering the first
three decode operations. After decoding the first len field from the
message, the only remaining check ensures there is enough buffer space
to hold len bytes. However, there is no guarantee that this value is
large enough to hold the subsequently decoded fields. The decoding of
the second len field is missing an explicit bounds check. Consequently,
a corrupted message can trigger an out-of-bounds read.

This patch fixes the issue by switching the decoding from
ceph_decode_32() to the bounds-checked version ceph_decode_32_safe().

Cc: stable@vger.kernel.org
Fixes: 205ee1187a67 ("libceph: follow redirect replies from osds")
Assisted-by: Cursor
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osd_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index a96ab9a1098e4..7df1b9239b4c3 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3579,7 +3579,7 @@ static int ceph_redirect_decode(void **p, void *end,
 	if (ret)
 		goto out;
 
-	len = ceph_decode_32(p);
+	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len > 0) {
 		pr_warn("ceph_request_redirect::object_name is set\n");
 		goto e_inval;
-- 
2.53.0



