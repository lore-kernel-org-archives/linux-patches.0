Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065401;
	b=xKHTqOuAY9IEJKA20F2hlLiI2Otq6Dgnyx+bgraRp9v3qlgy93HOhfRN7wshpNfH4T/s
	 736PZEyaLvx/2w26JYB7v1VwUfFr5FE4AquaWfzTVijvvYJ52d8T8RFtqVFgtRM8iZ/e0
	 5ov30qyvty/CdcYvOR2ChifbHjqAMotak26m/js8HRlJRbRyge17bVa7DsABR3XWDjQlv
	 HCgmiKjsKjyufRp0lCRKvE0/CtHHhANO74XlmDErFYJIO8bFoQPJEi3HmxTr0v7rBNNzc
	 BAQbknllj1rSfVuZKlht97s+r/cIqPJtarexOA7t1jKeT31r1JbjfP+TG/6bpy10Jig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VhnCMAqe0/QdwaDckF8Y8Jtj+cy4xEl3xZrzd5bA5mo=;
	b=BH79rSnX8O1KvMArkbKT0JOEzV9/beiD7xMIrLYfm9YlB30x9jlGUsXZ7Dug2DCaV3d0
	 eVUZ2XNcX29/h6qKrUUwBfvc2krLgZWI58Vp5sK8A9D273JMJOFJUcdyutec6HOQnuDZv
	 XoNA74Jpjkd9JsVN4Fhe5ORNIddZHZgY/yLnXqv3yll4UIuNPmW66cuQJ/m+Byc0bXrv7
	 jOMW8dUkIbW9M4VFMi2eHiPF85dD0NWteXA+D6aedq0fiyD22xR51YbPSUz0sF3P5IK1m
	 aexwyqVW8mgCe4aGwTfTnVGijuF/5yxJoUCDD5h5rEUBzQiQaD7GjbRgw5oGR2w+ohA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2hHPvvz7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79887606D801;
	Sat,  7 Nov 2026 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2hHPvvz7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B9F1F0089F;
	Sat,  7 Nov 2026 15:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065401;
	bh=VhnCMAqe0/QdwaDckF8Y8Jtj+cy4xEl3xZrzd5bA5mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2hHPvvz7eT0x5xPWPSWIr98qmlUwhL+sV1cCWnDKTaHGZFH+NumfMSBfS+WMIHyRV
	 uhUwOFi+EyGbBLJ8A8XeXFOO8yr3LWiWsdDsLl2k2zkaIxVtwvZd4em3ilBoR6VzpA
	 /J3a5HdFGf04SFWFBD1km3Ie3Aho277sTBu/iQlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1120/1257] libceph: Fix unsafe decode in ceph_redirect_decode()
Date: Sat,  7 Nov 2026 08:56:56 -0500
Message-ID: <20261107135010.172876012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 8c2b89e2004ba..3f23027fba3c0 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3639,7 +3639,7 @@ static int ceph_redirect_decode(void **p, void *end,
 	if (ret)
 		goto out;
 
-	len = ceph_decode_32(p);
+	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len > 0) {
 		pr_warn("ceph_request_redirect::object_name is set\n");
 		goto e_inval;
-- 
2.53.0



