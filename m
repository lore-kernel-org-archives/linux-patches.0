Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065464;
	b=IlkWAZh9L/8OSaywT2DppvSIBG5g7dUWDcgfnXmdrwT9MSzwKkDapZlOKIbpoVL4YWRX
	 kTdgkqLGB1JGKBIJUwk75aOfZWVc716HoC2nZtuoICmYX+n7sFykq3+7mgPWtY3wEbXF/
	 bOt/CX2nsmTVOEKCtOPtRsz8UAQq8FjCHj1PGJILQMyhZn3lhv9jPeXLDmyaDxvazZsGC
	 ZgBn4ubQlDQmQyWbCwgJG6/po/G+dzLuINL1ucMlWI6D11VkDhJonFbKV7El+9DaFedf4
	 QgJPUnTRiyHV1eHfI92+av8TYphOn2gcCSR7uqLqiS+JoAWeGhUJN6t0XrqTBUOjdXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V6LgQzGQIqUFxfeCAEwgSIkJqMSpRshJ/yG9cVkhdUk=;
	b=Ks/Tbksx63AwVWB6klJmRp2x8BwAuauCBhBVQAHJ3MyMyET/4mduVECZq/4+e+dIhGk3
	 4VpfaBaO7ojwgoyBLxC0QBf9gTzn3zn3UNUIXCeabPgxYHzPiO3wXcvLC8rnYiQ4l2ZL2
	 nbC4ex/kndSMRzXhH78Q+tDpRo5KZBfLfTXpBMMgjsvWABs015y4kolM1LAL+qYIzlhjx
	 v5FHR4j/vDZZtZgoD/4eHJ5EW5y0lqyj6bzPsjpi55TTYEq8MavlyRgIwzxKW3ICSM/fg
	 /PNc3/kOgq889RbiFQ3Xklr/YWaR3RVHPmRi+E48qPhfPrCU6lT0rsEfbXzEQoxHbGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0L9JFv5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665EA606A335;
	Sat,  7 Nov 2026 15:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0L9JFv5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8091F0089F;
	Sat,  7 Nov 2026 15:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065464;
	bh=V6LgQzGQIqUFxfeCAEwgSIkJqMSpRshJ/yG9cVkhdUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0L9JFv5DrCs6z1JZgDWrVOxMKDe8cKWGNGYB55vJGBJb7b02HOTXamA31eEfZh5P
	 Rc/WLLXCyHaEt0Zq84Z+foUNYmJK6xsodnZczYS66sSKCczdbT/lYYAPHOGx1GVeei
	 pBfHSyVdCp13dpADXWlvskZkwzoN0rezed3jVO0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1125/1257] ceph: Fix xattr buffer leak in __send_cap()
Date: Sat,  7 Nov 2026 08:57:01 -0500
Message-ID: <20261107135010.306822614@linuxfoundation.org>
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

[ Upstream commit e51cf76e7275d1bb5ad2d529bb00feade632dadc ]

__prep_cap() takes a reference on the xattr blob via ceph_buffer_get()
and also grabs a reference to the old xattr blob returned by
__ceph_build_xattrs_blob(). These references are normally dropped in
__send_cap() after the cap message has been sent, but when ceph_msg_new()
fails, __send_cap() requeues the cap and returns early without dropping
them, leaking both buffers on every allocation failure.

Release arg->old_xattr_buf and arg->xattr_buf on the ceph_msg_new()
failure path before returning.

Cc: stable@vger.kernel.org
Fixes: 16d68903f56a ("ceph: break up send_cap_msg")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 86e195c5fd325..4cedbdd1d4033 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1569,6 +1569,8 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 		spin_lock(&ci->i_ceph_lock);
 		__cap_delay_requeue(arg->session->s_mdsc, ci);
 		spin_unlock(&ci->i_ceph_lock);
+		ceph_buffer_put(arg->old_xattr_buf);
+		ceph_buffer_put(arg->xattr_buf);
 		return;
 	}
 
-- 
2.53.0



