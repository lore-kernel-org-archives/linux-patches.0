Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214884;
	b=2ElAEn88V5CYHXPYCtm6q8FfqC6hVzfg+zn5NABrloBE8xmkid0tpeMHfxXTYkzkfrnl
	 XXPVM0XMv1uqlo+n9LezOm0+8tjT6Qo5QWOhu5jFChvKQ3D0lSmFl2WtLXbdIO4QWfFU6
	 8EyrCsxyUohqn6nLde4UwUbafOMD6MnBeTiKAqkTeASoSw3Pt8AhxEljI9ylNaH+5izr+
	 m6/fe7uH0euTzk4XytNps8e7lSZSMvY9BpAg5XUEOU1CBuvjcciu8XHC7EYo2/R8Gkfgy
	 SbUxlciQDeuQ/r3gFRxGKRXBOHzMyBzmsExw99E4I8gi35q0M6Ys/inFIlFFN859pNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1uxSn3oB3Ns1kwEdpQZjQYbuWRYIeVz0RD+whmJZPko=;
	b=lBkkD3BJk3HJGtxxi6hB9ojXtkZxxf7BaP0mq0sbaDi1yPxWdTPWjf1C5F0qzaHqfdmo
	 WH/wBSUKT5ymDHewWsEPm3E0TFWeQQzYN7YWJ0m3NUKuU2tl+qMfqoDL6qf8slVRauMKf
	 abNjfvKcNMK4GZIDEsnuRnrnRMWZhdokitU56LbnumUn4yLGpijt5+MPKx5QfbNwSRwa5
	 8JP3uvtZaX4DLquR85KwbbzC15LxvHOUSAC+qjcH+x49MBD0m5j5YAArrnyG1lzXiDRTe
	 tSeMmUPxTmLvyO1bOG53MNB6ty++9vm3qhM/TZsSge/UV7TiD5v4I8KdQW8W2TzxCIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LK8EoGv2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4147606AB3A;
	Wed, 28 Oct 2026 19:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LK8EoGv2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8F01F01828;
	Wed, 28 Oct 2026 19:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214883;
	bh=1uxSn3oB3Ns1kwEdpQZjQYbuWRYIeVz0RD+whmJZPko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LK8EoGv2fLf/b2Ar/SBAcVP4qLgpSeJ1liWdY4ADBauku3YMs9H2TWE5ylvD8jeoo
	 +8U8JRlhd/+Da2TDM30aRaSSI9EebeUpH5mwA//YihkAwMtbQYqyk7kHzn5aJZqNm9
	 a2r7YyPIbFmwv/Z7OK6tWJOey9WoMfqkO925P+d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1016/1887] ceph: fix memory leaks in ceph_mdsc_build_path()
Date: Wed, 28 Oct 2026 17:51:52 +0100
Message-ID: <20261028170522.536513858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 040d159a45ded7f33201421a81df0aa2a86e5a0b ]

Add __putname() calls to error code paths that did not free the "path"
pointer obtained by __getname().  If ownership of this pointer is not
passed to the caller via path_info.path, the function must free it
before returning.

Cc: stable@vger.kernel.org
Fixes: 3fd945a79e14 ("ceph: encode encrypted name in ceph_mdsc_build_path and dentry release")
Fixes: 550f7ca98ee0 ("ceph: give up on paths longer than PATH_MAX")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 939f9e870de0a..63c30ee31763e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2453,6 +2453,7 @@ char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
 		 * cannot ever succeed.  Creating paths that long is
 		 * possible with Ceph, but Linux cannot use them.
 		 */
+		__putname(path);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 
-- 
2.53.0



