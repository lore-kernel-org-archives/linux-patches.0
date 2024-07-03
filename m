Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E08313B280;
	Wed,  3 Jul 2024 11:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006037; cv=none; b=hztavizj2+KHlGZXovMpABoN1RRTN+k1wsfiD3EKLBlwETM9cdFDr29VThQLl4lIt+umrN/blG0J2depkyVVuViyjKRNdkyuleF+i3f0VvjiOVu2tzEJWYd4sQKLbXtxGYVzpm22xgTKGUeFWwVLiBnBdztckCG7DvEsYRwxJ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006037; c=relaxed/simple;
	bh=C1pIbqHC1intFVSYAl9r+dZ385p3hqfrzZF7o9m9lhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ub8I2GDaigstLevj0hNYjW1FzB9pNLT/pL5JoFlllrT8SFe/Zy+WKVEeSIjckJ93iBY3IvkrIO2aXO+F3EjXg317CUBUU8jCN8vvj3BeYAU6OOhaZWkMV7utUhlozfuYo85j3QxwPjbvMLYALU5S3zM8YEIXkl+bbR+YBjk39Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D35nsL0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D35nsL0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74250C2BD10;
	Wed,  3 Jul 2024 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006036;
	bh=C1pIbqHC1intFVSYAl9r+dZ385p3hqfrzZF7o9m9lhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D35nsL0GbHD2ieKneN+fy3KT1YgGRYAHTVT2sAoUYZobcnJAzBJdfnnReMIpd2W9l
	 prbXm94PUGLmKT5crtYXPb2WrboRFEebD4jg/Fc0JKTh8PfvN5J0O1EhP/twj3OM/V
	 2beIVMsvZE43DSH4p08iDlkOTz/Vjt51JRR15if0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Maennich <maennich@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/356] kheaders: explicitly define file modes for archived headers
Date: Wed,  3 Jul 2024 12:39:44 +0200
Message-ID: <20240703102922.500399351@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Maennich <maennich@google.com>

[ Upstream commit 3bd27a847a3a4827a948387cc8f0dbc9fa5931d5 ]

Build environments might be running with different umask settings
resulting in indeterministic file modes for the files contained in
kheaders.tar.xz. The file itself is served with 444, i.e. world
readable. Archive the files explicitly with 744,a+X to improve
reproducibility across build environments.

--mode=0444 is not suitable as directories need to be executable. Also,
444 makes it hard to delete all the readonly files after extraction.

Cc: stable@vger.kernel.org
Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/gen_kheaders.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
index 5ab483a3ee5a5..c618e37ccea98 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -82,7 +82,7 @@ find $cpio_dir -type f -print0 |
 
 # Create archive and try to normalize metadata for reproducibility.
 tar "${KBUILD_BUILD_TIMESTAMP:+--mtime=$KBUILD_BUILD_TIMESTAMP}" \
-    --owner=0 --group=0 --sort=name --numeric-owner \
+    --owner=0 --group=0 --sort=name --numeric-owner --mode=u=rw,go=r,a+X \
     -I $XZ -cf $tarfile -C $cpio_dir/ . > /dev/null
 
 echo $headers_md5 > kernel/kheaders.md5
-- 
2.43.0



