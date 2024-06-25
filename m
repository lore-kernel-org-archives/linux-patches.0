Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23171465B7;
	Tue, 25 Jun 2024 10:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309768; cv=none; b=qYEDoshtRZfoxm7rlk0ac30frQPtWNp+MFfab3S7qM5p2mZ684cpvKxcZ4b6Hx4k0CIkiQJdOAsF3nwSVYtWaLWE1uu3TIzFRHsXQgAdrY/GcbegUeF1zdUbqQfBjHWPRXZ2WewxXMsa3BIF4DGEPrBJLrOhBj/mm0RKDBhzEhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309768; c=relaxed/simple;
	bh=XLZcKpYJL5DtL5VmVyaRlegC9lJn4f5i2xuvM6jhYMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ0dr5laQMpvmnmiSLfzp5SYYl9uhBVxw+aKgP2XqeDtbrrpGTnd7hRNTKxA4W6KqjrDSJlSWQGoJ2bgeetAykl9IBvrYcODafHBVY3ztramKZltMVVDm7eAwmb0vcv1bOZJ9MWv7WlzZDcT/LxRreMTRDUpRoIRlmANgPjoQYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuathelN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuathelN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C62CC32781;
	Tue, 25 Jun 2024 10:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309768;
	bh=XLZcKpYJL5DtL5VmVyaRlegC9lJn4f5i2xuvM6jhYMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuathelN9Pr4KBg2iP3P0CuOFa+7LaABqbNreyHdfVMDWXEz0+Rx+XJhF8sQLQYmd
	 55AOh6Vgf79PjSRmTUswtNf6ufrmEaRLTfTrhcyxDnP9J3NqeU9OwT5akXYUJCoQX2
	 eWJtE+RU1JRzjRVpJJf3v6RWCkUQ8y5UPhXlDYHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Maennich <maennich@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/131] kheaders: explicitly define file modes for archived headers
Date: Tue, 25 Jun 2024 11:34:42 +0200
Message-ID: <20240625085530.762507929@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 99422673a782b..12bcd08fe79d4 100755
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



