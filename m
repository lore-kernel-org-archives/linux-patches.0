Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE032DF73;
	Mon,  8 Apr 2024 13:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581671; cv=none; b=s02NMuV5OaD6w5+S8haHixaoWkucZuvwXkHjJrbKqHCuO+sFUKzza7BYWMPFpUMaFWebCNrMeueIU0mwUOWViaiKxqEmrrMB5AWUUtiZrNx/0rR/FFNSTR/jy9RznaETS43POhPNSOJU01hSXOLI1a/YePgTbEigDFQRNLuHH/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581671; c=relaxed/simple;
	bh=sWYASfj13JmfSWVT/IcI0Jl6JJePFkCHRXFIO+qi6bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEl/JbFFjqs8iSZjGBCzPklPEZcx/t0JvZYU+Ygy7fEmWupfy5cWmjGtnU83mzr7JQBSgzqWBhWIyxz4yiYgyU+TpOpn0SEiVJrj/LUJ5lBVTg71o/NSNMpDeQaT0xirXodtSJUGCq//ikoTeeRnCi9XeMyetXALRcEGC377RiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtxqpExB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtxqpExB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038C0C433F1;
	Mon,  8 Apr 2024 13:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581671;
	bh=sWYASfj13JmfSWVT/IcI0Jl6JJePFkCHRXFIO+qi6bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtxqpExB7mNMtBZrNWK7BIuhRCrmo310odXi6Op/w0q65LGN6CB0ELNi4AfNImP4P
	 bwPDvwzaNXpUAuuZjKOdzA+TR06zOPYl/THAvKfUlaTfz/A+uD4Mu2H/i+Y5rri027
	 JwTQYtf90KkZdopuQNuuSZa5/RJJ0YEyPJiw3mAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 009/273] tools: ynl: fix setting presence bits in simple nests
Date: Mon,  8 Apr 2024 14:54:44 +0200
Message-ID: <20240408125309.576157068@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 7fc1aa788f6f5..c19dec2394915 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -243,8 +243,11 @@ class Type(SpecAttr):
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



