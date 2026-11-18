Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028459;
	b=XcW76IzCRIbo6vhbIbBc8AMgNdbPMd+2zQBpBcuEREk4LbJUcnYzaDGkkvvJkDiX287x
	 3pPgjeZHPmfqOGy8NGJrBMduK2S7qdOBZYADGJppfqlSb0PQ4qMg0NkdVX5S4rNGm85eg
	 WTuU1seJuPY8Bg2Sw6bsZZjc+TcJ4yJ9lxPcRQBp87YgKVbCBAJWtDWeDKaAdvtPqK/J3
	 pzRBK7ca2GaX73jMUg3dwWiZ15VGAhlwcyGQLSUpT3CdrcBuslIhseXLCfIOuu8/VYaYc
	 Kx/lBxbqlwqhrdQPua3gZ6IdQYDhSiPF00yBsnf+f9S0ACQmaVvQwAEcX+0iyMB/fEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SEtZ7HjPTbFa3r7r6uXrCZS4Ij3minuT/nMl257BWqs=;
	b=WKNbVd4Mdc4n/BKzpU+UnWFCA09xIhfzW7/6h3rNLs7C7dSelQASp5DSv3cS0x6LAuN2
	 R4eh1JNnD1wloNq5FVXZ6s1xiA60D5cXHeAmmqp+1+I6uq5+aKo/0SG9TgPT6HRPrQjW9
	 haXlRHg6eVjFdgWwVB7XIitskHc28sPTarXUlG4qaB7hwlMtbDis/B8WLDFjN4qAznr1D
	 7s86N2XMd1PdRXN9L5ZwnTUHIIvMai6E2WAN0a/OV02de3F0wq5fDXzLKdJ7eWkEIjAOK
	 zVvfCQLdsVqNXxtmDb1lNAxQaDolUinbTBmKEOo6CO74aYU2ATBofZMgev+l+yywXJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uIPOqbXF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB4F606A336;
	Wed, 18 Nov 2026 19:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uIPOqbXF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2FE1F000C5;
	Wed, 18 Nov 2026 19:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028459;
	bh=SEtZ7HjPTbFa3r7r6uXrCZS4Ij3minuT/nMl257BWqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uIPOqbXFbMay9AifIrp8C+PFvz8SzpngymJ1RLPIg7bO1sWG7XrMs3T+Odvc4I2Q3
	 bjutYO/QuW2wTM8VP7ZNG/feHVnOIWKls2zcZfOPTmj5dmU4D1Gr6o8DfdFj89mtxc
	 eUCKieK9rEIJSFKNr1soVD6uydzs2QRE9Ivieus4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 2134/2151] kernfs: avoid READ_ONCE() on a kgid_t in kernfs_new_node()
Date: Wed, 18 Nov 2026 16:04:29 +0100
Message-ID: <20261118150239.414280170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

commit ef179363b04306dbc645c53207b9ad3516ebc75f upstream.

kernfs_new_node() reads the parent's gid with READ_ONCE(attrs->ia_gid).
That gid is a kgid_t, which is a struct.

On SMP alpha, READ_ONCE() ends by casting the value it loaded back to
the type of its argument. Here that is a cast from a struct to the same
struct. GCC accepts that as an extension, but ISO C does not allow a
cast to or from a struct type, so sparse warns:

  fs/kernfs/dir.c:751:31: sparse: sparse: cast to non-scalar
  fs/kernfs/dir.c:751:31: sparse: sparse: cast from non-scalar

Read the gid_t inside the kgid_t instead, and wrap it back up with
KGIDT_INIT(). This is still a single marked load of the same four bytes.

There is no functional change. With GCC 12 for alpha (the config from
the report) and GCC 14 for x86-64 (with and without KCSAN),
fs/kernfs/dir.o has the same object code before and after this change.

Fixes: 81bdc85b4c08 ("kernfs: fix up the unlocked attribute reads on the creation paths")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610261608.vItiXCGW-lkp@intel.com/
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261027143247.3537239-1-shakeel.butt@linux.dev
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -714,7 +714,7 @@ struct kernfs_node *kernfs_new_node(stru
 		struct kernfs_iattrs *attrs = READ_ONCE(parent->iattr);
 
 		if (attrs)
-			gid = READ_ONCE(attrs->ia_gid);
+			gid = KGIDT_INIT(READ_ONCE(attrs->ia_gid.val));
 
 		if (flags & KERNFS_DIR)
 			mode |= S_ISGID;


