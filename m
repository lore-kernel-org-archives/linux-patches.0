Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063664;
	b=W2QYS3IER0U6PV5EeipA/v2tnQAMLZ5lpEW8IN+N822L+ouKGRoQsZ4ceRyd5Dn0vobt
	 m9vG9w6V2L849MW6uvLY5+g55226ursqiDyg2ejQl6I1dlS2B/S3CFOhZsAm0yNqiLwYF
	 XSMJMzVldgLvr+7E2XSs3/WuCkylFP6FkUy1KvHIqJorD7xsOS+WzE5pHTzpPTCMrbSaE
	 e8+UgBQCBEqAtXbm1NPRxW+TcCFoDi5joRz1jR5cMhupC/Wz7s48ORBzisE0nYSaBUzQu
	 MVAbUqRiyL3TEyisYbW4j6Sw8Zz1FvCMCUoTLeOVzPZoIZyz0Uas50cmGtsC7yFXizw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q3AABM1OJgeEaEocR60xaed1gSkKoid+CLjJCCTLsF4=;
	b=rHbnvy8HqgFgjkPH6QbhGELoDcvxLH9fGLy0NYZdMWS6Lfx0IBuAPcrkW50O1hgN+HE3
	 uTogxsyv+IrG/S4v2ttI8U/TDEPU1QEO9GJhlWsvVhqRCjCAm/fYgmesPapkiBa3zhy3U
	 X35qih3KaPbee8rzIME7oFR0+c8NBdKgMyM3yjezeQImpW6nPGP48wUudWsWxDBQrupko
	 qNDwrRgeHhaPEmKWzTIuAAZirxZNOYh6Zw1e3V+g/aBUrYd9Wn6MM9M0PMj5rFwDsfeMc
	 KfZPBCHUo8gNoC/ZuQxLx0Qbm3uHpiH7awbZisrfltf6ExKUUAcWJC3ZKYRDnJ13tMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dHlKPH+R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC1A606A9CA;
	Sat,  7 Nov 2026 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dHlKPH+R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24821F0089F;
	Sat,  7 Nov 2026 15:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063664;
	bh=q3AABM1OJgeEaEocR60xaed1gSkKoid+CLjJCCTLsF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dHlKPH+RivC1xgmvbSi/5fIzn7en4XLAKwQsVEWWw+ykFG5/6ZduwlF7xC6sUfvtY
	 7rvNFAoLm5xkHH786YKicQCIwgZTYAJEfj5MPzikdO05ewEhihSK9E16Ajrf8rJ5ox
	 2Cip2IzsuYrERCfmSeltma9eDhJHVYc5mMhrxsxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 777/869] ceph: Fix mds session leak in __open_export_target_session()
Date: Sat,  7 Nov 2026 08:57:39 -0500
Message-ID: <20261107134919.041640158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a5bc9f75e0f9c..56d8df7f7ebdd 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1758,8 +1758,10 @@ __open_export_target_session(struct ceph_mds_client *mdsc, int target)
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



