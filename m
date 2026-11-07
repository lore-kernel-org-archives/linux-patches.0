Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065467;
	b=nG9M5H/ipZWxbeUnSPjR4U0gKbv4q4ZCyErM2tjlDYv0yVrt5VgkXjG3vVVrEzUPmBDE
	 Q9YXxqx6rmn+RXY5FIrWN2WStU14rb71k6VajVG2xkBk+vWxV5Qs2ok7vM2kluywy5q4N
	 3WdCpKnmUQT96SPoJHYQT6QyxRO4u29kMP1cuTIBJabKT3pPj60ZW8T4sbVCKGi4zb87P
	 OpIp9c11hX3Hwc2Qyh6u3aMn1c0ur17DzL4/j4ZpdrWfjAGQKfqYOg0IgEvvaDbtrG9uT
	 +NDjFpXJxVde6plXhA9+x23vwakEgSmzF/KdqMcx1nGSVhcWyJWTq29uptFzAiekepA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1TpJEExpY9SoEM28TsFRYkxsYLfOiTduY+xCJP272Ds=;
	b=Ui0+mBUZ+lt73TyS0OKxipxj2d6JiN/JjH4Rzgd0HZA93xZI7WCBFSVUw61Z+kvcUCLM
	 32Wbt2QPWv7aItK/vLBDZal6XcF6cNgn8oK6T7hIK8JnN2BbWo8tETgwsv/hNLkfcxmE6
	 07X/NYnM8KiMe+ok4Y2fbePlQ2O4rDBRNhfANXV+AFNZNIh+ebotyR8uRyjhRChoeHcHv
	 +Eu784+U+6XYUmB6/FnKT6TgIDSmM8zKN+rL/odL2mGq8fO5DijOc7Zxen03iJn4Q+N76
	 VSsjQxmm0nPqPQbriO7HnJUMzbjc2M5gIv+4Yx4R252e1Fys13lajfbnDScrxZ5bpdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yaUSNPGL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43709606A32C;
	Sat,  7 Nov 2026 15:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yaUSNPGL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C26D1F0089F;
	Sat,  7 Nov 2026 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065466;
	bh=1TpJEExpY9SoEM28TsFRYkxsYLfOiTduY+xCJP272Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yaUSNPGLUdmB6pjJYREINA4wCcgEkygf0/Yh2WJtLUqLfTgGGSamrpV4431nhJzY9
	 SiHrOKl/qeCfWMSL2pXx1VxyfGzL937Fgy5xCV2tmcP9j8MTX7iZo6glNYbpX1/gSD
	 O96holks5JSDXoA/gJCuY61OWWzopytnOrDt0LPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1126/1257] ceph: Fix mds session leak in __open_export_target_session()
Date: Sat,  7 Nov 2026 08:57:02 -0500
Message-ID: <20261107135010.333471780@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 6c80207392fdb86107d7acbdbf4c86cac38da1af ]

__open_export_target_session() holds a reference on the target session,
either from __ceph_lookup_mds_session() or from register_session(),
which the caller is expected to drop. When __open_session() fails, the
helper returns ERR_PTR(ret) without dropping that reference, leaking
one session reference on every open failure.

Drop the session reference before returning the error.

Cc: stable@vger.kernel.org
Fixes: b682c6d41bc2 ("ceph: switch to WARN_ON_ONCE in encode_supported_features()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 073d9f4a3adbb..1c5c9abd7e5ae 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1805,8 +1805,10 @@ __open_export_target_session(struct ceph_mds_client *mdsc, int target)
 	if (session->s_state == CEPH_MDS_SESSION_NEW ||
 	    session->s_state == CEPH_MDS_SESSION_CLOSING) {
 		ret = __open_session(mdsc, session);
-		if (ret)
+		if (ret) {
+			ceph_put_mds_session(session);
 			return ERR_PTR(ret);
+		}
 	}
 
 	return session;
-- 
2.53.0



