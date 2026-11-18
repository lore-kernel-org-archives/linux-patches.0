Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042799;
	b=VmUOJF80ilV3+QkKxbF4BKgKbtIpMU6dSQQr6pD7/ISM2DvcKUkJ937rl9nANWeF3le/
	 7GFMG4ArHyn5/n/gG7Ke86ntqGXa+pyi2Qm236xAF2c82n8J0eheyYNML24Lk0sEA77UK
	 CIXwuOe/Q93KOAd/CkaqcMrA56oEE3UM7RM0VQJr8rE2JovLCJbZqOa/fPbjaEme7DYgz
	 gfCwjuYzHjgaJPqympDwPSsjWQl3VYcdUduvKKcWhl58xBvzO19ch1iOyy1A+991wLZlg
	 /sqawCr5q1QvwHrVdJdjK5Anymmn63xFfmE4oKslPQwcKMaNU14XWALMv3/Ipycww0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PLCHVCEneQM8a66t2zwoZS7fuixQ0q7zueSvexU9ex4=;
	b=gM4jJi14zUp0fVfZw0dAlRQ/3PmDf5sBh0I/s9gbiq/kLVaJlDEQoCzP1tYDwUlCOkhe
	 Qi84NErPEgLWTYOqhkTp+XFcW4a/7RJiFZpN3Lag8geDnSTJmx3sxhn02Gf4gbwEhNOCV
	 cSq7oHdNy7ohBT+Lzvh2+zmZ5exF7yU10JBepO52SDfuweHARY+qJlixxShnrSCJjh65X
	 s0TM1n9EWI2cLYDjX4Q90qHoHQ4Wx9k3xxvUZ3kTzhSGuzbqKdl3+FGUAfbIRQYdTqKLW
	 XhbqoeCf37UhfbbrfpKndvGFSY7lHEcWJpcr1mnQwej1HwWHH7FN4Accprj2/c8vLNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6SDCPee;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C30A606A31C;
	Wed, 18 Nov 2026 22:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6SDCPee
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C851F000C4;
	Wed, 18 Nov 2026 22:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042799;
	bh=PLCHVCEneQM8a66t2zwoZS7fuixQ0q7zueSvexU9ex4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6SDCPeefsm1yqqbdypSSnYgI1dSsr0l0fYKGNVIbwQ8i9gu+kKel/pWWoRMgMiZw
	 nDQ5D/FE9wmcQV6ZnxNo2KuPPl0QMewPevxoGGvxBw+J9Y9aebBVX/IX0OfeQDUrd6
	 74Rt9RhxF1Shot+32q9zUU0TkkWFUaphARNv/ilM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 3300/3318] kernfs: avoid READ_ONCE() on a kgid_t in kernfs_new_node()
Date: Wed, 18 Nov 2026 16:05:22 +0100
Message-ID: <20261118150458.592213561@linuxfoundation.org>
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
@@ -697,7 +697,7 @@ struct kernfs_node *kernfs_new_node(stru
 		struct kernfs_iattrs *attrs = READ_ONCE(parent->iattr);
 
 		if (attrs)
-			gid = READ_ONCE(attrs->ia_gid);
+			gid = KGIDT_INIT(READ_ONCE(attrs->ia_gid.val));
 
 		if (flags & KERNFS_DIR)
 			mode |= S_ISGID;


