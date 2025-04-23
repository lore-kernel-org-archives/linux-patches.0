Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BC7263C9E;
	Wed, 23 Apr 2025 14:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420234; cv=none; b=IB7Rw5G5HKrOlp7fPtdZdV6VbJ61/I82SNAWO/KHJSFpvtfJjQT/oauY7rLNzcwFO7t6KYvJZL8EkbdvbOiS+9MEeI+YOjPhpAGEADsCAvXpdi4z6PzfiGQTuZKvQdWqIc+BiMctD22LFCU30mUeQD4E4j0vVxYGgR/SSY1S+9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420234; c=relaxed/simple;
	bh=q6iu41dtoXDMR+mTs8DOf0m/HQ1MuyLU4HhOvRBRw3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdTKGc/udC/lKY7Gy9uoPkAg7MrNlkTY8GYavCmtd2Ig3u9wRpBM8tiuzEzgeOwaUBaykx75RRhTnQ+50JpteYWX1uXjKtNO9XuUbC9idZ1FDwBrMG3/cTOHVjuwsp7VqNwUcLsNa8b94W0Zo1qf4z0JCDcbpfToRLeU1yH6oD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t174VgD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t174VgD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F075C4CEE3;
	Wed, 23 Apr 2025 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420234;
	bh=q6iu41dtoXDMR+mTs8DOf0m/HQ1MuyLU4HhOvRBRw3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t174VgD8E7Xo9A/EolTUYFgH+FpY8KQr4IPZcVcRf68PZmfjU6y69iIaH0KAuGwgz
	 RUZdQm7l5y9wVN14IuetLfp3qtV/eo+sN810YSXBFXzgaMo9AD7xr30uooHiogXdrj
	 e+1XRBIy+YZj5q7tlWNWw5vkpLTHcFDzcORt96zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 066/241] tools: ynl-gen: make sure we validate subtype of array-nest
Date: Wed, 23 Apr 2025 16:42:10 +0200
Message-ID: <20250423142623.297717626@linuxfoundation.org>
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
 tools/net/ynl/pyynl/ynl_gen_c.py | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/pyynl/ynl_gen_c.py b/tools/net/ynl/pyynl/ynl_gen_c.py
index 9c9a62a93afe7..f36af0e1da78e 100755
--- a/tools/net/ynl/pyynl/ynl_gen_c.py
+++ b/tools/net/ynl/pyynl/ynl_gen_c.py
@@ -706,8 +706,11 @@ class TypeArrayNest(Type):
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



