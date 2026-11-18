Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036946;
	b=Z4uM5vrCUB8q1OI+OToQ7ehzFIMP6ykJkB9V0IQrSa44GPRvP1wWmpLb/rQUHjVUHIJM
	 GGQ+tGP5NN/Ay7ZvAs4uQMAsFWwSz8OrhhAnrUDeWvzFahaOzTzVFY6FDlXGVAnZPx6+o
	 /0VffIzG83uKvDZ034c6nAG7jd6+HgL3PB0odvXSN2QaAWmlMNxEiioitlRGBm4RQVfdS
	 hSjNvLUeSQK1LQ3S/H5uBEK8kwvBvPU9CAVhiE8Obur5ocShIzpqwzud61MSOmDDP88dm
	 9iiPxCWHds1vYJOqEwhcfN67QshPyOuu3bc4fMoavVetuMou8dO+x5GWFaUTBTFz5sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ob5PBVzv1MIuCwSFxV7JmE2mQAZQOhSOmyoit0RIddI=;
	b=Vuqw1stLCGcwa4HZwzf+r64GwBbydzqfTFtH+yBT8yAcFG2l51VBbFuR/jEjsROif02s
	 FudcWwM2pkSnboWU4ouqkJUpDBQY4O2qd3uV6cNVUEg5P7JILAWWATDzZPboXnAtHuvFc
	 THiMeAmWD5tidStguqLhnfbvRvY+2p5DyWTdzvXfMdVDv+umaH6YqRJ4exajUiTsPCrqB
	 vVC1H9ZhHAi9Gp0z2xQFppdNdtopDQfMeXY+T1m5RoTa7B9JtETpl09i3Onpv5vxA2cxf
	 KkOV/aa9kw96g70dF7kNsBNdUVWCgtdagdH88PNmV86XiO3hxO11DWESFBrjIrRUdxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rHawz9nx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3793F606A31C;
	Wed, 18 Nov 2026 21:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rHawz9nx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872231F000C4;
	Wed, 18 Nov 2026 21:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036946;
	bh=ob5PBVzv1MIuCwSFxV7JmE2mQAZQOhSOmyoit0RIddI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHawz9nxc9HBXBUSs7Dt/+eD9vEthDpnc3V9FwtSdRcnRVn/bh+bgXp7ZUynkg/L2
	 qMZuNvbFZRpXrNgvQelqPtQEZWKfcncwcxCgEJVL+jSabhsdQjH+5iy4AjbJ6MWxwl
	 SWq2O+fI0225jpIZrUlnxdFgD6eAksSfIOhITsq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1237/3318] ceph: Fix mds session leak in __open_export_target_session()
Date: Wed, 18 Nov 2026 15:30:59 +0100
Message-ID: <20261118150357.302458403@linuxfoundation.org>
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
index 20c3e637ba796..07dd43f4d472c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1738,8 +1738,10 @@ __open_export_target_session(struct ceph_mds_client *mdsc, int target)
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



