Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558261DED5B;
	Mon,  6 Jan 2025 15:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178675; cv=none; b=DMgZ8D39l3qKVU35xZd9mmfdHDaA8MK1+pI/l6i8N9+4g8ubM2NvWsTR89EbAybth7qXDmBB09ptrvVpwRjHQJXPseQzmCSFJTAhlXTcHG53b3mcpcRZkWGXRePjKJjjZVSydfpIIdMyttG4CEdjGh4jgf7lUtVE9df7KeYarms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178675; c=relaxed/simple;
	bh=9rdJNO4wsFtvrVF/mvZkfRQk04uN1aC9m0wmGD4qjgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVJfhwI3y8W5j1ndKcaFBWl9iOLMWFXr4xjj4sO2cGy7prf4wZ+OgNwMAKXVozXF69t5oh+yyxC1n1MtrkcMOIQMvQ7PUDwxcEV26nqb29BtzXov+IjilawPyHcG2dCC2ick1DXrEC8614fd2UQB8ntVwWW4I9c2V4OyuF96Tj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=paybwzKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="paybwzKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEF4C4CED6;
	Mon,  6 Jan 2025 15:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178675;
	bh=9rdJNO4wsFtvrVF/mvZkfRQk04uN1aC9m0wmGD4qjgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=paybwzKS1S9gSqWfB3zCOJPA82sd2RtBOE8+o+8CuwhQWQxxA9y509Gu9fXohhetF
	 3Zr3eX6ijvb+iN088wkTqBziuubXIpwSWNdDvlp3w/kJ+rMR8I7q5xrvJqxs4cA5zQ
	 66EMBgu8GsPxiKMlS9X2YuFyHCL7zWWgr0+UPfpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 5.15 054/168] ceph: validate snapdirname option length when mounting
Date: Mon,  6 Jan 2025 16:16:02 +0100
Message-ID: <20250106151140.503755990@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 12eb22a5a609421b380c3c6ca887474fb2089b2c upstream.

It becomes a path component, so it shouldn't exceed NAME_MAX
characters.  This was hardened in commit c152737be22b ("ceph: Use
strscpy() instead of strcpy() in __get_snap_name()"), but no actual
check was put in place.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -301,6 +301,8 @@ static int ceph_parse_mount_param(struct
 
 	switch (token) {
 	case Opt_snapdirname:
+		if (strlen(param->string) > NAME_MAX)
+			return invalfc(fc, "snapdirname too long");
 		kfree(fsopt->snapdir_name);
 		fsopt->snapdir_name = param->string;
 		param->string = NULL;


