Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053916;
	b=Lg1ObI8AEFNENWUjPGo5z0ffSsYAx3HRZnWUdetgi8eo++awV5uw8toXjgCPdX5Glp1p
	 eplzu9aTMHOjMcykWd56MIuDbM+FykMPxhMyJtvBS3J8QXRF8cvDJsRSlN9GSh/iE5ix7
	 UdGkGucrOCu+WuDjs0X2LKUE/MyTX+bYPURhzDso+aMrJ55K1ImSrwjAELNKMwHEflvxs
	 YJWcwo39gGTh0LexcbJdtXOUjHiy912XRXWp7cV0Z1trqf4wcRlC3iBrB+TeoVkfeq/0r
	 G+6siz0jlQFFO2Gkq+t1NlQt2o8YCTjlNcoTDFsrfa1lowM+YK4nMBhLSzlhLkQjQZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z631bfxmjzZgfJLPN7AkKNwZeeHXXk+MbEuqQnlRCMA=;
	b=uzY2I9omfjz1NTEYt3sK0+xM3N/j5jwEucdDev4TxfHcqIiaYI8hOuL+c2y2i1CK85kH
	 rH1DWtXhDedZJ3MKebP4qY3LlUBiHgQ/9IhZaeE5NWemKDOAGExxkVpNK0UdcviLbR1q3
	 3aYYMUFbFDhBddlYMaT5m3wAZtOlhDfKdtmsdj4xon6oPCJiObP8GXXJHLqUH4ZFv57RY
	 7E5t0gAlbhtC4eAhpwdr8hOulyCz8ZqEOSb2Cj/DQEYRcVOCPWiuf8OtA471zkOu0YR3E
	 /9Yx4avFIZjmxc/NXUCtejvLB9JSqWPWzq1nCRjppjGRJrvyROil20CJWWP/9wimauA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZF/nAjIS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603AB606A320;
	Thu, 19 Nov 2026 02:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZF/nAjIS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B285E1F000C4;
	Thu, 19 Nov 2026 02:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053916;
	bh=z631bfxmjzZgfJLPN7AkKNwZeeHXXk+MbEuqQnlRCMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZF/nAjIS3XFSKWj/zH/M8O2RO+D+0gChy141c2and6rxneAsLVihiJ4rxDJXh1O3d
	 y9S1Oml/v1RUZSUGh4M0E0d6JpYiIp23UAIq75a2H/xSt+WPIPO7PCiVHynE0E3I4i
	 zFRK9ARmJh7xN3LiIyC497wuvBCsBXqVNAAqmcLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhao <yuzhao@google.com>,
	Alexey Gladkov <legion@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1089/2214] ucounts: Use atomic_long_sub_return for clarity
Date: Wed, 18 Nov 2026 15:46:05 +0100
Message-ID: <20261118150055.792665407@linuxfoundation.org>
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

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 32342701b4ba57a6fd77e8aca2f65f68c0fa1da6 ]

Decrement ucounts using atomic_long_sub_return to make it
clear the point is for the ucount to decrease.

Not a big deal but it should make it easier to catch bugs.

Suggested-by: Yu Zhao <yuzhao@google.com>
Link: https://lkml.kernel.org/r/87k0iaqkqj.fsf_-_@disp2133
Tested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Stable-dep-of: b14fcabd34e0 ("ucount: take the rlimit reference before checking the limit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index cc8ec071d46d3..a751fb6e94e51 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -279,7 +279,7 @@ bool dec_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v)
 	struct ucounts *iter;
 	long new = -1; /* Silence compiler warning */
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
-		long dec = atomic_long_add_return(-v, &iter->ucount[type]);
+		long dec = atomic_long_sub_return(v, &iter->ucount[type]);
 		WARN_ON_ONCE(dec < 0);
 		if (iter == ucounts)
 			new = dec;
@@ -292,7 +292,7 @@ static void do_dec_rlimit_put_ucounts(struct ucounts *ucounts,
 {
 	struct ucounts *iter, *next;
 	for (iter = ucounts; iter != last; iter = next) {
-		long dec = atomic_long_add_return(-1, &iter->ucount[type]);
+		long dec = atomic_long_sub_return(1, &iter->ucount[type]);
 		WARN_ON_ONCE(dec < 0);
 		next = iter->ns->ucounts;
 		if (dec == 0)
@@ -330,7 +330,7 @@ long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum ucount_type type)
 	}
 	return ret;
 dec_unwind:
-	dec = atomic_long_add_return(-1, &iter->ucount[type]);
+	dec = atomic_long_sub_return(1, &iter->ucount[type]);
 	WARN_ON_ONCE(dec < 0);
 	do_dec_rlimit_put_ucounts(ucounts, iter, type);
 	return 0;
-- 
2.53.0



