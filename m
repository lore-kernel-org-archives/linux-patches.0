Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464A1280A32;
	Wed, 23 Apr 2025 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419761; cv=none; b=ggtQ3U2rBzTowb7hnVjUdkQCgOtOUlFbOeJMxviQQYoLIlVraiCIBAfFDjhitwnyNa8JW+e3TZTOjxkenR6h7Vb2rweAaTVhjjdKlpGHVxlcFQJRPOOah4oFOgsjXGzoLqXGCWT443D9SJRb8+e7j2fgUm4osfyoJ7eM6gOSQvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419761; c=relaxed/simple;
	bh=qVfEIvv+xTbZuKxoAQ1JL/p3+EgCzvitIJ61RtV4+ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qx2OHqfoegIjH9MISNFd2awxQJWYWk+OdUNEbjQHZecJShncisT8FuIUCKNRr4q95baHnwpijo1hAAPpnq32guJSW9bZACCpISEA4Bc8DEvZUItqVlZxZdkDCfaCAoIUpEhqNT/5LcKQ8VaGanVZvwGugwmYHdyGZRHkXmcVQn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUniwyiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUniwyiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2D9C4CEE2;
	Wed, 23 Apr 2025 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419760;
	bh=qVfEIvv+xTbZuKxoAQ1JL/p3+EgCzvitIJ61RtV4+ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUniwyiLnJ3SCCcVoPSUgwNl2fCl+xBb3oWk1f2bv+SbhH5p7az+k4wMgU7TcBji0
	 bpd77cmsl8BxGEYG+VDZp0YQgMGKD/E/IhVMxyI/ocrZKjZbXstt2q6xThfSWleGPr
	 u8VnWDtlBjbI6YMQ7vEq1J9ROguESypXgi/1edNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/223] tools: ynl-gen: make sure we validate subtype of array-nest
Date: Wed, 23 Apr 2025 16:42:09 +0200
Message-ID: <20250423142619.450198831@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 57e7dedf2b8c72caa6f04b9e08b19e4f370562fa ]

ArrayNest AKA indexed-array support currently skips inner type
validation. We count the attributes and then we parse them,
make sure we call validate, too. Otherwise buggy / unexpected
kernel response may lead to crashes.

Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250414211851.602096-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 265a0ec0ef811..40f1c3631f985 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -665,8 +665,11 @@ class TypeArrayNest(Type):
     def _attr_get(self, ri, var):
         local_vars = ['const struct nlattr *attr2;']
         get_lines = [f'attr_{self.c_name} = attr;',
-                     'ynl_attr_for_each_nested(attr2, attr)',
-                     f'\t{var}->n_{self.c_name}++;']
+                     'ynl_attr_for_each_nested(attr2, attr) {',
+                     '\tif (ynl_attr_validate(yarg, attr2))',
+                     '\t\treturn YNL_PARSE_CB_ERROR;',
+                     f'\t{var}->n_{self.c_name}++;',
+                     '}']
         return get_lines, None, local_vars
 
 
-- 
2.39.5



