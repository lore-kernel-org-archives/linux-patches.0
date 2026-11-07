Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062576;
	b=Bi8IieP3UpkW2BOISeFkzzS8gfyE/CnpcaNIBXl0dIsZcfDxn7jaCW8HDPH0uKvZJJz8
	 V8HrAMcHQWm3UPNbBBl8qZi7SOCVp3Um+yhJP4hYZ2uEn0w4bAm+mZ8f4qLbt/0DS0OgR
	 g1oRozpVDz7oJfMZ7AUHnwXpdtx3eTtGM4EOuQ+ZfIYqMbRgU5YxfzV8RqqXLMIDjpWtQ
	 Z4HjU/u7UvTjg4CZrDlyNL3zmjpXcp68MD44LgM3bMJpRgxbqu5rVURq0Cg/C3H/BQLc+
	 FyJ3oVmzpshnHCa/orUT0TWuTPo883UYX7/vp3fHyMzt9bfAxQqANmCaroq6FZLUnJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hTHlSZYFIJ/wLItCJ51hPVhhMQ6+rqoDAMN1huqKi0Q=;
	b=suW938mmnmbRYelNUGZM41V2VyjoTXud/ANibYkr8yKivuXZN3vY104C0M21E6RA4ASc
	 Dy5CK8vGRCahKyD/QUI7COUtFgVMu/rSw/YSAlkSJlcD8tNnpjN7O54KKTI15gQmqmp67
	 Cb7gagtN0cDlnNMd1e1tu2QLRBmXckYz0jYbcAOOTj2y4AQqVa5a3SIqEMwzUdpXE6nwu
	 OZAvcRlslqXeKBzkrWE/m6n0cWKhQF1By4kGw/UTAuyEVkav9Gwj3IuQHqoqUHRNusd32
	 JL3+S0QhQRpjfitWZRWWc92fuQphP3vUnkZpFfSwePoZqDQm834lSUR3Dxw8TEUCa8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwQzQu6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ED4606A32D;
	Sat,  7 Nov 2026 14:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwQzQu6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFD71F008A1;
	Sat,  7 Nov 2026 14:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062575;
	bh=hTHlSZYFIJ/wLItCJ51hPVhhMQ6+rqoDAMN1huqKi0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwQzQu6gvSPC+b4RC3a2CPSNQZqNK8NXpORRI22CohXSQJOj/DhF8gJLdxtA/3DYn
	 WqHWYfVBuR9wkS1kcJuzI9fcZTqPAgCq1lfgUN+STurJ5EKQkn/hpNbaGni//2KZbB
	 ZE0XE+B4kXmtdAXq86ddkVpZ2ZzlrvEZePqCkrfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1458/1536] libceph: Fix unsafe decode in ceph_redirect_decode()
Date: Sat,  7 Nov 2026 08:57:54 -0500
Message-ID: <20261107135038.790012321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c27c8858b1652..b1e95ef61761a 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3665,7 +3665,7 @@ static int ceph_redirect_decode(void **p, void *end,
 	if (ret)
 		goto out;
 
-	len = ceph_decode_32(p);
+	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len > 0) {
 		pr_warn("ceph_request_redirect::object_name is set\n");
 		goto e_inval;
-- 
2.53.0



