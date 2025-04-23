Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829D528BAA8;
	Wed, 23 Apr 2025 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420994; cv=none; b=uHvaHQtvG6TR+WEoBKdGTl4uLWriy7SuMn4hZQi3Dcjb0MZEVuEmNfeHj3aYjdX6j0fuXvACQ1zisO89v3kCDCn64aLenCYd5IskksIAMkq3RXX4x1QKSYhM91SgHv4puUkXeQ8jAL8RnzYY6Pj5UHMTBI3KD72owaJvfkSAZCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420994; c=relaxed/simple;
	bh=hdXi4rrxrKrw9YlHDwb847ML12KVu7wpwzJkOh14NJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gt0lzusp/R1qhzYP6stlApAuxnGyhkrudum8y8HzQWuMG29Er7PgKPomp573rwI5E2biWH0Zi1fRYNDt001POISzWkiy92CvA35zzvFyDqFSo6+S8X0Jz4CxTb3+3W4lD2q+o9KTPjTMGvntBJr/WDNrHUzJtWslZgLcS1toiAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asaJGC3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asaJGC3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EAAC4CEE2;
	Wed, 23 Apr 2025 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420994;
	bh=hdXi4rrxrKrw9YlHDwb847ML12KVu7wpwzJkOh14NJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asaJGC3ojLwHxWQdqckDC9tzQdQsBy9F+2JDmMjxzqx9FFrWt9qfB0+yemo46BgMk
	 4PN85uQl2/3wFkrzq3sEH1U7SFg1XLCMF+dhYwEN2G2N7t/cHtnaesRI8eQURy4obO
	 iJCqobQ1INWABYzAQr8WAYypb1a53QnESRwShN04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Alexander Larsson <alexl@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.14 142/241] ovl: dont allow datadir only
Date: Wed, 23 Apr 2025 16:43:26 +0200
Message-ID: <20250423142626.358125283@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1137,6 +1137,11 @@ static struct ovl_entry *ovl_get_lowerst
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


