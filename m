Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062585;
	b=R8s7pMSTkCgC9oMlyQsEek2rLON58+4Uzadq9hOgKtahQFP5bCCVAqdPn4jXzgCDt3K4
	 axxuH+UUgrx7sxC5QlDqUeh1fbyMN6J25hmiZar5rNRKzhB7bRdqH7hQ3h6QTYA9wAV4N
	 U4bPk8HTpQ3FMkDK2Qm9BWy1iqrMepg3lcZNB4ZP0iq6OEUHA/oAC1JgZ09ksjOSCQtGU
	 co0kJiyF0XTqIZBK0VR2O+eTZ+pF//247sNf7SadMzDMoBF+FIX2grGdy7pQ9m1ekj13E
	 1nxtyEpXzbg4z6yCiAmj7Lk0lrdC1KD5QUmBQNoO5rK6h8UIGRPF43SKPJpPdnX85hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cUYpWyQaxzOL9h09aiSXHkcQyrE3Tp31TKT2Js/Hfg0=;
	b=4JWdIiMBoh89ghqh37lbR1QeULtU8KGTr1bZTAr8AAK7rs9dJiPbm/Em1JPZq61Enps+
	 TIrYM0Lk/snm0SzcJfDNmnX4Evl8P5JUeRVIKo5v4FqWBTAPpIrEi+RLkwxiG47ZO7ps4
	 dXX1y5oiYwr2KwMniHLPxz9cZVYLN0kpRk+/ydQR9ylxKHyahoFv5oWI0HOlD++32aVKE
	 JZ3KIi0xbIIeT3isBUmV9u1423YJVzh9uYEvfslRCjlEHMYoSXvWjpDQNoLknU1zP80pd
	 KHGwQpT7JoIxuuiK0x+Sxvxg/MPUvHkKXPq4QETY9j6G5GmXdMMTo/MSjh7xlfLm6DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxBaq8iq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D86606A33E;
	Sat,  7 Nov 2026 14:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxBaq8iq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245D71F0089F;
	Sat,  7 Nov 2026 14:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062584;
	bh=cUYpWyQaxzOL9h09aiSXHkcQyrE3Tp31TKT2Js/Hfg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxBaq8iq/aa8LwX5RLAea0kazIN3evxF9y3w7sBjW+gGL6wm/OqGl95zA1fHpvbSr
	 AHT7JQJZ2nCTicmuW/w1SkWt7DqSDJvBgL37nJlHj/zDjd1f6I7TuSBn6u74pmTeuE
	 Zvsn6LpCGYeruaGi/OP974zqNl/I43LgYRDdD6a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1464/1536] ceph: Fix mds session leak in __open_export_target_session()
Date: Sat,  7 Nov 2026 08:58:00 -0500
Message-ID: <20261107135038.962427793@linuxfoundation.org>
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
index 96a08a73aeaef..a2870baa8ec8d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1757,8 +1757,10 @@ __open_export_target_session(struct ceph_mds_client *mdsc, int target)
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



