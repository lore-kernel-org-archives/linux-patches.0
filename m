Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062583;
	b=G1KxMXCSrHVVh0cEjTggfLagstqPt8fgr8hCpj1KnmYM8cCtPP1DLOguh6A3ti3+u5fz
	 YawFZB2ar4zzYRJWYO+xM7GW6HlchDx8QPjVrdORxJaU/z/0n2fcOwR/GDZTQHbcF3gqi
	 2LHE1Z67KVMNnk3YBQA+PqFKp3VtmRoueicCVfWIgeNbsH36OW2V/C4lfVTC+Af6/Vpqu
	 FwUZdubA2A34zn6I/C7E+XDho+57yOlcqSD5EPZs9uoF8VDkctjYeeGSaEXYX9gZL3p1K
	 M1ZEH8LT0jhTSSW1/gRDAPkX67Ap4agEM4hfCK8joTZZ0nRNiOVfS/01C8S5hjmo+Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c7MWh7V3+tvhmQ57Z4ynOvfpRBJxwzYnLthMBgXczEs=;
	b=5U5s4QmSqF7uriN/Ajxwr/It68v30/TpconESW7wc+u9Vz/FhkOxfRa6FnZotI6zUgpF
	 XkuauEPrc3yqq4QEQLgrKIfyX1P1Wop9/5AojEFC/z/yR5Aimc1qDfn2gDYv0JtQF0vj9
	 lEIXTMTgfgHo2Ue34hzrJf5gPxCyadjoFPmuEWee2qxY6tLf9etxyaDdjMAfvrLB+s09r
	 0RAUP+R7Nz1RyNVYCFxmdws3wRr+vHoTgKGKvRYwB3m4GasiTSkDZX1oftlDhGIAecxdS
	 4uuJS1pAe4I84S8NbrncYK7MhjiEz1liZbKLVu5ewaUxH8VKPMQ07jiQQREDjGFCCgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUW1zkTB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C871606A33E;
	Sat,  7 Nov 2026 14:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUW1zkTB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF93F1F0089F;
	Sat,  7 Nov 2026 14:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062583;
	bh=c7MWh7V3+tvhmQ57Z4ynOvfpRBJxwzYnLthMBgXczEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUW1zkTBi/ptlfFnW9vjLe0yxncJCNG3Fast73gYYiZgrk5VJ28FZb0jIIlOsxgoo
	 yzbdzXXaQH/g7xyrs6CDNJ3pFPwiY8n55cWw3ZUjTMBpdNDi40y143uBwIDAMqI8fS
	 uFWrOzbWF4Ma3I1WQuinUF/u3PgcFuKdcl0HgudU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1463/1536] ceph: Fix xattr buffer leak in __send_cap()
Date: Sat,  7 Nov 2026 08:57:59 -0500
Message-ID: <20261107135038.933928492@linuxfoundation.org>
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
index 3525d60ed9774..09bf30ec7226f 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1561,6 +1561,8 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
 		spin_lock(&ci->i_ceph_lock);
 		__cap_delay_requeue(arg->session->s_mdsc, ci);
 		spin_unlock(&ci->i_ceph_lock);
+		ceph_buffer_put(arg->old_xattr_buf);
+		ceph_buffer_put(arg->xattr_buf);
 		return;
 	}
 
-- 
2.53.0



