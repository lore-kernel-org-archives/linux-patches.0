Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E8F7D07F;
	Mon,  8 Apr 2024 13:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581472; cv=none; b=CxLf0EnqGEZsQOE9yO7Duq8HHbJxqhu3DjJvDEsf/G/Es6pxik517zeEq6VrVOVInsZjVx50+1y6E9k6Lv3+c7p84QCv2lXVEpKK5hHy5kPxbccb0IcJoUW+6CmI5AsNNc3MdwIlUexYwvCQVZXptPQJM1n2vjiKEp5mgTXYTqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581472; c=relaxed/simple;
	bh=ArSJAl4tSTJCvgIh8UUN+38Yda4QLUf5+JhT6Htf9jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETOOkRux1n2T6cPZTZMlXfxEMLARA0lsC8hFG+PfqJqpJegswgr/XPIaqeIWEqIL19CtjjoTZgfwSnwCe+31mMDHesJjL2UdYqgtxACH4dEeUPYhqF1gpY41y+NajBsa6cpuSNdufZ+j86YPN14EkA6QcGJI9ruywSnRPQKDztk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NwTzRco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NwTzRco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C5CC433C7;
	Mon,  8 Apr 2024 13:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581471;
	bh=ArSJAl4tSTJCvgIh8UUN+38Yda4QLUf5+JhT6Htf9jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NwTzRcoxp8LWjylWWqXI2zIyYZKF83OXHe6gvuuDMBAcqDeKIlJyzyrY3fXwZlkY
	 S4GOSTJzEKFApiuvGjlZ/sgxP71flQ/ue4kmnxieNCTC2HF6KuSRcDcBKaWl/FcR2m
	 YUgx5kHxIoTcsEMmZCM6S3CJJ0I6VnLbEJSh06jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/252] tools: ynl: fix setting presence bits in simple nests
Date: Mon,  8 Apr 2024 14:55:08 +0200
Message-ID: <20240408125306.937244177@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f6c8f5e8694c7a78c94e408b628afa6255cc428a ]

When we set members of simple nested structures in requests
we need to set "presence" bits for all the nesting layers
below. This has nothing to do with the presence type of
the last layer.

Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20240321020214.1250202-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 897af958cee85..575b7e248e521 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -198,8 +198,11 @@ class Type(SpecAttr):
         presence = ''
         for i in range(0, len(ref)):
             presence = f"{var}->{'.'.join(ref[:i] + [''])}_present.{ref[i]}"
-            if self.presence_type() == 'bit':
-                code.append(presence + ' = 1;')
+            # Every layer below last is a nest, so we know it uses bit presence
+            # last layer is "self" and may be a complex type
+            if i == len(ref) - 1 and self.presence_type() != 'bit':
+                continue
+            code.append(presence + ' = 1;')
         code += self._setter_lines(ri, member, presence)
 
         func_name = f"{op_prefix(ri, direction, deref=deref)}_set_{'_'.join(ref)}"
-- 
2.43.0



