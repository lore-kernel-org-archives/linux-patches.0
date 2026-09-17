Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C086E4D17A2;
	Thu, 17 Sep 2026 17:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667064; cv=none; b=Am6569jsCpPLG7oaJldIMwmXd1BBI2FVmllvwyDiuPvhrR4PHUuvCTJu+FEIM9OjW/NJBatO9j02AuShG9WBBi1oTguDluCBZd1wa6Mk9F2Uysezr+x02OIw/Brf8MoLxycaHNMrGiFjSHeI+aLbM05c24wMoNzrhAxlt6vNHx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667064; c=relaxed/simple;
	bh=BRJcX+vTU7YKN2qShKkDSRbBazvm9t7cteZpgBf4mjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJukBHm2EmaA0nEcbdvZcWH4CKqcBghHN7e0mVo4toniizztbwR0n7yAx+93qG0YexY61ioKArx8EQbmrliB1e2RRH3tyxtXu4PSNPECLUwLfLpFIl91sFmbtIyMsKdVMwom3eqHWevob/WVwK2mgQUNhe812HhJkGrmKfikVkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUoMZ2Dj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUoMZ2Dj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A5A1F000FF;
	Thu, 17 Sep 2026 17:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667062;
	bh=/1bI+JH7nOXnjWXp24wvUGKENUmpYqQD0nRimnZ7kFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUoMZ2DjQsV1mwzB3W3RROxlJDrNiyn6e0+Vg9tRsmPwqd1ufqk66fCjwvvrmx8eo
	 s0uC5+4vOjswoGaErAt0Cxd8nfqA3+Sh4TSoke+pp6/b6e016uCqx2tSXdjlqSZdoA
	 ETng/DkgHErl0oEbT36Q5Iw9cGC0e9MBug+gWwxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1215/1250] ns: add __ns_ref_read()
Date: Thu, 17 Sep 2026 16:16:50 +0100
Message-ID: <20260917151625.217060613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 6b053576edb12c7739ea9c7c9900031361922631 ]

Implement ns_ref_read() the same way as ns_ref_{get,put}().
No point in making that any more special or different from the other
helpers.

Link: https://patch.msgid.link/20251029-work-namespace-nstree-listns-v4-9-2e6f823ebdc0@kernel.org
Tested-by: syzbot@syzkaller.appspotmail.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: cdd812d0683d ("exit: hold a reference to thread_pid across proc_flush_pid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ns_common.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/ns_common.h
+++ b/include/linux/ns_common.h
@@ -156,7 +156,12 @@ static __always_inline __must_check bool
 	return refcount_inc_not_zero(&ns->__ns_ref);
 }
 
-#define ns_ref_read(__ns) refcount_read(&to_ns_common((__ns))->__ns_ref)
+static __always_inline __must_check int __ns_ref_read(const struct ns_common *ns)
+{
+	return refcount_read(&ns->__ns_ref);
+}
+
+#define ns_ref_read(__ns) __ns_ref_read(to_ns_common((__ns)))
 #define ns_ref_inc(__ns) refcount_inc(&to_ns_common((__ns))->__ns_ref)
 #define ns_ref_get(__ns) __ns_ref_get(to_ns_common((__ns)))
 #define ns_ref_put(__ns) __ns_ref_put(to_ns_common((__ns)))


