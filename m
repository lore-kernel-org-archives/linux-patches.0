Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A8E2512F1;
	Mon, 23 Jun 2025 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684176; cv=none; b=ttr7tPG0w0/CVEZNVdiMAm8TIhYBOlXn8hrEp6kSdnuK8TzSYxWI8Tswg2T0sgAERZcpN583dWkflYZVz1XU9hOIGG9R0NfpXqDzvnugg5c8ytODd23/YwfrsTWcE0xWBcK9ZD6u+yiaO9KN5lxFjx4wzbj6pHS7eR/fwkp+EuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684176; c=relaxed/simple;
	bh=5LNitT7uTvJIghn8cMCpoKfx5bWoc5a8vHq+N2A38B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3GQY7/H3qcs83HToPwcsHyIVX6ut9j7O4RoG0fVf/PcvcICtka/qTndjmOehW6N6Ma2isZqObxiUiudvlnDD+TeHfT0/z0Tm0CsBcmEjoXJUoTybINuvRyqA6FxaqzHFE5ZD+y2lVxAk8XvmpT4VYBEqBv9twefQMBWI1xsxwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3taF5Li; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3taF5Li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ED4C4CEEA;
	Mon, 23 Jun 2025 13:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684176;
	bh=5LNitT7uTvJIghn8cMCpoKfx5bWoc5a8vHq+N2A38B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3taF5LiVS4QqsmT8ZYkBH+avXg6bhqoozNU7EvK/BvCzvinniNCewAl9+HUSo+y+
	 ByDRWlAgHR0L6Km4u2Q+kdj9nCNrUjXJacuu1n6abI/fa0u0caEDJvpRt2Wr0ySTQq
	 iR+B8LGM1F5oPvzLwuTLLA9s4JuLa8nYx2xfl3fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Becker <jlbec@evilplan.org>,
	Breno Leitao <leitao@debian.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH 6.6 001/290] configfs: Do not override creating attribute file failure in populate_attrs()
Date: Mon, 23 Jun 2025 15:04:22 +0200
Message-ID: <20250623130626.966214997@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit f830edbae247b89228c3e09294151b21e0dc849c upstream.

populate_attrs() may override failure for creating attribute files
by success for creating subsequent bin attribute files, and have
wrong return value.

Fix by creating bin attribute files under successfully creating
attribute files.

Fixes: 03607ace807b ("configfs: implement binary attributes")
Cc: stable@vger.kernel.org
Reviewed-by: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250507-fix_configfs-v3-2-fe2d96de8dc4@quicinc.com
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/configfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -593,7 +593,7 @@ static int populate_attrs(struct config_
 				break;
 		}
 	}
-	if (t->ct_bin_attrs) {
+	if (!error && t->ct_bin_attrs) {
 		for (i = 0; (bin_attr = t->ct_bin_attrs[i]) != NULL; i++) {
 			error = configfs_create_bin_file(item, bin_attr);
 			if (error)


