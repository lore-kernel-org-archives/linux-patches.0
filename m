Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036926;
	b=WPw55JfCkw06676QiVT9k7WAfQaiuTpYu1Da3HlrXd4RCvsprLmj7pscm8c1hMoX5GBw
	 1eIwEAdwbbCiQCv9HcKyY/TO4H/lZXToGS52LRNiZ37a35/Vfq5JitMJd6gVXYsBJ+KPp
	 oZ9F+6exZ2/ybohz2Vj+LtJzGtiXf+cXQ6IHJXZrqRFHA40jnxuKvc2kOlhCslN7DEFlc
	 T2C90eO9bo380luLdoBjr6VSvRVgIVWvFxqvwZpC2Ky0pZCWMw8UgjIgW84Rbtf5mM/Mz
	 AbWtLsyiNnk63KfQRmg9BbtJT2CCKCLiI+Ozn3tg/DKyUN6SfIU9pbszUEPOwGXZiMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8QcDf8UnZo2QAz31x7I9Md9iiazJ/g7S/sgami6v7k4=;
	b=s75NQqNokppNJRlr47I0UcBgUlBBZsjmK4OGcpCx9KazxXqdTItYeA20OTUbLJTAzXRu
	 h6dIGsf0zaq6V0sdAqqFFIaB7QLWtWfELE36hqn1h3jHzBIa+03eDKhFpGaoQY84x7Gb/
	 VVjSsRo2GnMVHFsDQlB7kJlDz9JrQAECUcFTMoE8V6VMxouwIjkRLQHFryYrjVQQk7/BT
	 iIU8zI4KCvpMLBSNI6VS9Yrihvb84qZwLSkOOd9bOGDsAOfCXwFSqave6y9gTwk3I+qsI
	 Y4LNOBUcf61kkttx25nRjlhbUnSnS7dQTRcZmFN9zX5ha1DulO+VGaDNEkmXqIj/UKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrZo1Q8Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCF4606A31C;
	Wed, 18 Nov 2026 21:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrZo1Q8Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F621F000C4;
	Wed, 18 Nov 2026 21:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036926;
	bh=8QcDf8UnZo2QAz31x7I9Md9iiazJ/g7S/sgami6v7k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GrZo1Q8YgK733NCbbm2uWN2/O3UNPhvs6w0rC5LzZzi0DntmbJEm7EhKidJYya8Su
	 fhfdTsYIrp4+ToDtpVAMY5IbuvmrYMDPAzremzK8wQpFwrYMvq9K2RRNqJp5lS55sC
	 eGcO8rzIKUpDdBNMOcgQmNarKFTsm8SPQKCtmQVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1231/3318] libceph: Fix unsafe decode in ceph_redirect_decode()
Date: Wed, 18 Nov 2026 15:30:53 +0100
Message-ID: <20261118150357.124236249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9ac562ec3a81c..7892c15d74993 100644
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



