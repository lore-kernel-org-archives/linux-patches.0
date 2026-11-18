Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022394;
	b=o18xOjaN1aVqRWIShjq1VJQsdXHcaXjhAt/aT1qg8tThBNuhCnOnqoCMXVHSAuT3FoYc
	 zyZsg1wkCUf2KnkOow3MdEqR18cbUREAQsv512FOyEWBfHOS7JHIOa1RwH69or+F1ASvn
	 Sw/pQ+n9HqzAwDImdrVQ5f8wWpwQ6wCnmQAKIB0aZsExLXrHn/nerrN0yyYVpIQxZg6Nm
	 sBH/oZ9kBqN7I1Rgs3/FQxgQ9OlPqEQQVTHuWxHm2ehykBknkdaDEPVMGcm6RivsigPya
	 s2IDCz8zr3XQN0rd2mobVxnarufuOZlis9HaZVDtNcbYWHrAbxxE023I+fMpStQpAwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=stg9YkpjzsV9rnO+ia0D8yUGGJeIkpOJunkXdvbSwBs=;
	b=0Ax0TMZbBrlDcnIetE2b5HepnouKy9AQxhDX9zpNPqKtxuACkSCOaj+hHcVOLH4mjtIM
	 Y+HGjK/keaGecgxxCmd86Rc3vB9FxTR8Wu65J1BeghtYOy5izPIb78Y8PmGRZS9VCcJTP
	 ZcCn4npI7Y7zydZcFgYvldcFYjZzaMXO98FXRFM6Cwek3bFMLKG47B2V+px9Yt4e5nMs6
	 2A8yn/0sAY7Hvy7iAxZHkiwTyuZMsvIleoIfgCkXu+fcxLJRb32dTW2ORD8DuigNwvW23
	 gk4Djem13Z6FOdUWnwq9u3vW0vJ5PVgIpyOri+aP/agFmj9or6qRdlDRQ7pVjr0CcdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WMpxubQs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE509606A325;
	Wed, 18 Nov 2026 17:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WMpxubQs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC961F000C4;
	Wed, 18 Nov 2026 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022394;
	bh=stg9YkpjzsV9rnO+ia0D8yUGGJeIkpOJunkXdvbSwBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMpxubQsLdTQZcKL+TF/aACA0ACcO4zTUg9GRSBf39hyr7S8ZNH5L12OycdpXblZQ
	 DYz5CAaY8MlpH1kM18zhMmd1iJX9+QOI5X73xYfTXwp9w+ipfbw3c3Jx2ccZ22mmCI
	 7lu3LTf8JMz+IhRToqg4UHcePbVFw5Okv8Ur9U/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.3 2646/2651] kernfs: avoid READ_ONCE() on a kgid_t in kernfs_new_node()
Date: Wed, 18 Nov 2026 16:04:46 +0100
Message-ID: <20261118150419.336436282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
@@ -748,7 +748,7 @@ struct kernfs_node *kernfs_new_node(stru
 		struct kernfs_iattrs *attrs = READ_ONCE(parent->iattr);
 
 		if (attrs)
-			gid = READ_ONCE(attrs->ia_gid);
+			gid = KGIDT_INIT(READ_ONCE(attrs->ia_gid.val));
 
 		if (flags & KERNFS_DIR)
 			mode |= S_ISGID;


