Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF915263C9E;
	Wed, 23 Apr 2025 14:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420353; cv=none; b=k1h9wjaqEyDgBrekkvHLaIF/Lpdx9HR4KPOgKHE1FeCLWFxGLKOQp1Rc0jKO4xc/Mf7wU9B1szaEMI+/U82F+gAoVKk9MHCHkm7OW0r8Kn4XTdJlQcJmpHJSYPaU76MiyswKiJdjCcH/niFpoer67gE2dQyhfsyErsmxGfqzGdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420353; c=relaxed/simple;
	bh=nAj3LpIsMZ4d3H4ypySCcqXQdX+JVGJVwn12BPuQq5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQakj+Nc4isBBNPZ/V7vslH48WlZfWbruSzN2kEYeDODBx9vBD6nTEoHbSk/MJPgZFka3SWI+fd0TLS7PAJSS54RAW4uihg7jwsyxNF/ayfEi4v0zxdteTJUzwxjG/B5Fz0HBs1uZXLynfR/LUSE2hZYqOLiq6/lqySzlrkreJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0g1bzi8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0g1bzi8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A8CC4CEE2;
	Wed, 23 Apr 2025 14:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420353;
	bh=nAj3LpIsMZ4d3H4ypySCcqXQdX+JVGJVwn12BPuQq5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0g1bzi8QoDQjYjC37mQzn5kJCBnr9Ij+ZaUHJ4+F+5WHlLFoeL2Dr75yvO8Add8NT
	 Y/ZgQagNU++pkzZUsSUw/dygsIGl4Hm17yuiOyLpZbQ+n1Aot2zyANpEkt/sM9gRlx
	 M/ifxPYjMN5m6VOV8e+rARKT/PLN8an9s4GqK/vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Alexander Larsson <alexl@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 121/223] ovl: dont allow datadir only
Date: Wed, 23 Apr 2025 16:43:13 +0200
Message-ID: <20250423142622.034686813@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit eb3a04a8516ee9b5174379306f94279fc90424c4 upstream.

In theory overlayfs could support upper layer directly referring to a data
layer, but there's no current use case for this.

Originally, when data-only layers were introduced, this wasn't allowed,
only introduced by the "datadir+" feature, but without actually handling
this case, resulting in an Oops.

Fix by disallowing datadir without lowerdir.

Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
Fixes: 24e16e385f22 ("ovl: add support for appending lowerdirs one by one")
Cc: <stable@vger.kernel.org> # v6.7
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/super.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1119,6 +1119,11 @@ static struct ovl_entry *ovl_get_lowerst
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (ctx->nr == ctx->nr_data) {
+		pr_err("at least one non-data lowerdir is required\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	err = -EINVAL;
 	for (i = 0; i < ctx->nr; i++) {
 		l = &ctx->lower[i];


