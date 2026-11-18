Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052874;
	b=mrPOi/JLd8fds76G2AnNJaGImzYIRRU+rUHielMCB89z8sE8zFojNf0IN066EA2Rtc+G
	 a0hA9lswRKrp+yX1RhF6/j8DvIp1qqoBnZElq4ODC15w6sslygbVNxBACTklF2zP2gYPQ
	 XksAJJ0+fgHbLvPuKU2/4ovf+yxdupSVy5ZU9x+dzW/fSyiKY3hk1h90sH7PQPCu/zFnZ
	 MJt2YnudU22lpwgnsDa7Sqx6H8L2e8LOq3+FZI045J/yMID6oU106NYVJT6xQPpcyra5v
	 WArIbGH63KnxpFTGN2kdE3BIxE4G42+DJtOAo9rkoIMs+oDADbUEFw5jssEbCuqbGog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cV22o0xgXFtsNNMqr35ySkIVI9+UdK475sikL54cieA=;
	b=qNnyOkhcQOgxpUFTs+5Wh3eKe4pnaceH9PdP3iF0U91FcFVZl1IWkPy/jnYp0SBVkOkn
	 +AeKmOulsgFfqxBm2S31jElj2Y5Lt4j7bL4M1cJsW3v/aw2nxkhgKrSkpCJ4MXoTMAVG4
	 NusAR3SJnz0I2f9u7W+B2pypm0zrnZSNSX78gpbbf5fzGdQM3mPdO9z2cmkN1UOrnaqOT
	 mVHBLpyfZF2Z7O1ES/PEvRFCOyrybwyaHLyDsmp8zj24spBmm3nEU/j/ynV/x4ZR0M6Vd
	 ir8d0vGuQ4ZGN9/42tCda4aqfbTxPxiopE8W7etpquypBqfx2t2C/N12rKHQP+F5piA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ykr0kkJV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6AC606A33A;
	Thu, 19 Nov 2026 01:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ykr0kkJV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9B81F000C4;
	Thu, 19 Nov 2026 01:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052873;
	bh=cV22o0xgXFtsNNMqr35ySkIVI9+UdK475sikL54cieA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ykr0kkJVr4xyFL9YvxluieEHfzDK0BhIY/26J8XGVMXwJziykVA6uLpJuMm8rCYz1
	 MqROOXCnTcq82Vyz0Mc9IvZXoi5YtzkmPKyKyo6WgHb0GxyoMP/97OBVErHq016mza
	 blhrusgE4zw0aTw84TZrdHkhMtZ5O07ltRbl0a9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0717/2214] ceph: Fix mds session leak in __open_export_target_session()
Date: Wed, 18 Nov 2026 15:39:53 +0100
Message-ID: <20261118150040.480612726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7c47ce276a993..beda154f134bf 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1417,8 +1417,10 @@ __open_export_target_session(struct ceph_mds_client *mdsc, int target)
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



