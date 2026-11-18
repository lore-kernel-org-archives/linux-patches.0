Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045807;
	b=0theiO2zuiGQ2GCi4s78S0P8XtKhqeoa2jutHpET1sytuGbLPK9W3Y/Gp10tt4B/NpxS
	 MHpohKg81DWPMzWZePD3lCV0qwZHSbBLU8jLfx6MpNZc4vCdru1vX7+CazjYWIINJlBqg
	 QM8Ksl3DNbrKK2mGgUz4XsLP963JQwBQguohT7xqAP3kmqsjQcVHAUJgNSqyugLxmP40H
	 9pdDp3vYe+nV1kD57tG5QbJrOwH1TZvxRqkS/lNXnmBW9xZE4JmKjsHUE4sWiFet22aPR
	 Zt0F92ix+CDVhCGjRmdpwFYAu9boRmhtxH5InGmzFoyyEPIab/scqfHQu2BYgc28DCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WQZcfzKJ+14RMguT3M/+myFWZJoerjd0BVTmYeoCkzE=;
	b=yQJCWQ5xH/nOV+5LNqP0QwbK+cs3/V349jB/TrXSGx2K9BdSzldsCkmYJ2gXAXXntC10
	 5tm+dwAuiA+SPeg6rB9rSvJpIoEjvqCdsXLyW0ljopYYMhcfNnRJXVi9oV69vwyyVpEw2
	 Pvuju/eSFRJvipcCk+3r/fxq3c1qtIsb5sRPJcQ/iKfwgu9rm5ZtYsr6WB1+ABbKVCbLb
	 13RUlMcmHJSzEdk65B6OZ60jgu3UVnWW2zwkkP1q0uIgfnKsDgAACOMfP9uEizkyonv8I
	 DTPAPNgIyhdO8B2ezxh5CBNoKTqaP+ZwbLW27NgZPQiWBTsjpMy6l2WSBH0eiJDj4GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzOyXtwA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0BF60A2606;
	Wed, 18 Nov 2026 23:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QzOyXtwA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05761F000C5;
	Wed, 18 Nov 2026 23:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045807;
	bh=WQZcfzKJ+14RMguT3M/+myFWZJoerjd0BVTmYeoCkzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzOyXtwADYH3s+BZLTt2TWgdjLN77/C38THTsO+Ifmr0ZzngYvdDdlu4YpyJwjc/J
	 4sx7noK6xMX+tUruRs8yYDKoWWHSrVRIttyGdzrqsOlz8lJjJNrxGElJOzoeJOIKKc
	 GCf/99SIiaScCizerKz6SzcVCXfqigPewvhl4lHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1055/2857] ceph: Fix mds session leak in __open_export_target_session()
Date: Wed, 18 Nov 2026 15:34:49 +0100
Message-ID: <20261118150239.576645117@linuxfoundation.org>
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
index 0f28aeae054fb..a02913070dd02 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1564,8 +1564,10 @@ __open_export_target_session(struct ceph_mds_client *mdsc, int target)
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



