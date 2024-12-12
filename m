Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427A222333E;
	Thu, 12 Dec 2024 16:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020392; cv=none; b=WVlX0rES5U7Q95itro3dJwRFEMIKpb4+L0FUG7JvM9ElfR8jXrR19JZaHV57tHQ3g0r0rp7DNgP3MUXRGwYLKYSxar5aURsnUcy5bbRDTpT72nnTgAJT1KU0dmEF9jqnJ3S7L8eP/GiIkZU11KitCrIvkhUkMmQ6wPqPNoGorqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020392; c=relaxed/simple;
	bh=5LUkU4sPIIjjPJgkxbVekzUO47GfRAK+o6MCQheD3AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sd3EQjtFAiRYoSpeJcg7k53Y0kSFlF9kqBncCHbSnMlFceGduXkKXxMiljQIIhddrIMQ9jB2fcFuFU0up6vMBOtxTDlGsZapA3crR57rjGpRj9AsNTUsnH3KZljdbiGCVc38cGxkmWxqgBNplAQTiOebgtsnoYaESlYwlryyym4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9V+2RAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9V+2RAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D3DC4CECE;
	Thu, 12 Dec 2024 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020391;
	bh=5LUkU4sPIIjjPJgkxbVekzUO47GfRAK+o6MCQheD3AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9V+2RAODZp3nId2Secpfz1JGrcqUG2IVqfbXyL5GJLuLcu0OlnXHSMOAGbegu0Zy
	 oiH+VBgaV8YmVii30VZVALEVzewmRu042ySLcUxohrD0ZbMsuKlQB8icj0DBiD570h
	 0EbNmHzPIlNKp6zvYwNODeNpv4SiVI0KuR+kyLis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 425/772] SUNRPC: make sure cache entry active before cache_show
Date: Thu, 12 Dec 2024 15:56:10 +0100
Message-ID: <20241212144407.483055040@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

commit 2862eee078a4d2d1f584e7f24fa50dddfa5f3471 upstream.

The function `c_show` was called with protection from RCU. This only
ensures that `cp` will not be freed. Therefore, the reference count for
`cp` can drop to zero, which will trigger a refcount use-after-free
warning when `cache_get` is called. To resolve this issue, use
`cache_get_rcu` to ensure that `cp` remains active.

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 7 PID: 822 at lib/refcount.c:25
refcount_warn_saturate+0xb1/0x120
CPU: 7 UID: 0 PID: 822 Comm: cat Not tainted 6.12.0-rc3+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.1-2.fc37 04/01/2014
RIP: 0010:refcount_warn_saturate+0xb1/0x120

Call Trace:
 <TASK>
 c_show+0x2fc/0x380 [sunrpc]
 seq_read_iter+0x589/0x770
 seq_read+0x1e5/0x270
 proc_reg_read+0xe1/0x140
 vfs_read+0x125/0x530
 ksys_read+0xc1/0x160
 do_syscall_64+0x5f/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/cache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1431,7 +1431,9 @@ static int c_show(struct seq_file *m, vo
 		seq_printf(m, "# expiry=%lld refcnt=%d flags=%lx\n",
 			   convert_to_wallclock(cp->expiry_time),
 			   kref_read(&cp->ref), cp->flags);
-	cache_get(cp);
+	if (!cache_get_rcu(cp))
+		return 0;
+
 	if (cache_check(cd, cp, NULL))
 		/* cache_check does a cache_put on failure */
 		seq_puts(m, "# ");


