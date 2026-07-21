Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8C2471250;
	Tue, 21 Jul 2026 18:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659294; cv=none; b=fdozmQBfuzkgWCz6+djqYqJYQ2IL3ZPt1d/HDmR8TaZIV9BLwHDLZE53BfLMyuJC5UbohJAD56qZeib3Fsh0bYwdlllb/zYwZFqsbXvvyZuv5QOQ7U8waPiLG0+9sdvihx6UOgmPCT21uwQl2N5ZE7QhpB1Ia8ZN+ZLfVW65/0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659294; c=relaxed/simple;
	bh=tS6nlVVWmuGLTLroCYw3Ut5okMqrToDRCdRgcUddX2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWo0Rtn0CGPMv91yttmvbADQtbdjwlu9oNG6jY0FfeETx+qHxtGX9pINxzd4T6wW27lfwMXqx8X8UDf1f5D2TPyhjcFu7KrW5PXEMCeLxXJ5SEAW+q1hx30ae+4BUmAjdOOAgjJfpqtv7LNYFZ5CTs+CEuLIkBZa+VOgiG4amo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzLkqkdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzLkqkdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744B51F000E9;
	Tue, 21 Jul 2026 18:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659293;
	bh=yR4pi/7av9wQuZh7I/tOq6jPRbYaXj5SfcjUnYLSS5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzLkqkdXx/akLCUaiW8vEfIF0W+m63T+x/VNSN8g9J7GN0EHRvAm/YDvVyGOOfs8s
	 b+AS/1B97h7T0MNdYjVsLR6BI6Ba1OzFKQQGk/KvG3aJNsBTaAtC0JvP5amLapBmdF
	 ZoBHwdnhhkVzMLvHREj/is1QzBKb34EmkjJDnFvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 1439/1611] fhandle: reject detached mounts in capable_wrt_mount()
Date: Tue, 21 Jul 2026 17:25:55 +0200
Message-ID: <20260721152547.813882633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

commit 6c732471740bc2ac9b0946134f9f551dc75f4369 upstream.

The recent fhandle RCU fix moved the mount namespace capability check
into capable_wrt_mount(), so a non-NULL mnt_namespace survives the
ns_capable() dereference. The helper still assumes the later
READ_ONCE(mount->mnt_ns) must be non-NULL because may_decode_fh()
checked is_mounted() first.

That assumption is not stable. A detached mount from
open_tree(..., OPEN_TREE_CLONE) can be dissolved on fput while
open_by_handle_at() is between those checks, and umount_tree() can
clear mount->mnt_ns. If the helper observes NULL, it dereferences
mnt_ns->user_ns and panics.

Return false when the RCU read observes a detached mount. This keeps
the relaxed permission path conservative: a mount no longer attached
to a namespace cannot authorize open_by_handle_at() access.

Fixes: 620c266f3949 ("fhandle: relax open_by_handle_at() permission checks")
Cc: stable@vger.kernel.org
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: LLM
Link: https://patch.msgid.link/20260701114438.24431-1-david.lee@trailofbits.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fhandle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -297,7 +297,7 @@ static bool capable_wrt_mount(struct mou
 	 */
 	guard(rcu)();
 	mnt_ns = READ_ONCE(mount->mnt_ns);
-	return ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN);
+	return mnt_ns && ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN);
 }
 
 static inline int may_decode_fh(struct handle_to_path_ctx *ctx,


