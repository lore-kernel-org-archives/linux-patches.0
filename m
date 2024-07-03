Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B1D45945;
	Wed,  3 Jul 2024 11:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004974; cv=none; b=CQ13Bsw4KCoH8Va2zQ+75xK8pKNdPW3JLiR/kzIN2LTgvRXgRY5TxMIE0VKkq5Io9sVVhMaXUF+7JOgNz2svtvgCzcCv+inr+keI+u9d4dCDW+9kilMZqlHtSaS2QOrHpQTkRsp2rbD11jUigsnWj/nAmyY2rzpC5swiWhdLznw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004974; c=relaxed/simple;
	bh=P2iaoBj4+X4tH3CYsr+h+uwvaBYzWmKzb05yzXAVcD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RErqe3Qmawc7pboyxl/REkD8kZvhJpUi8ouCjqSypZON/NC00KF+xhQxhtKYCUxQcVr7Pbjlte13d0hB17d/yVW0J/Irld9GpvZ8R53bHw+U9o4pdUKEOMqhleW9aWX9V8+5ZKPyt/D1F7ibjOvl3cd1X9AcyRh73RCMOld+SZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYa5P8RW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYa5P8RW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6FBC2BD10;
	Wed,  3 Jul 2024 11:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004974;
	bh=P2iaoBj4+X4tH3CYsr+h+uwvaBYzWmKzb05yzXAVcD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYa5P8RWIrIWk+V5SSnFa0LfWxKHjLdHgr1seTisPXBr6sY7bI+ojmYiPl2+ji9Mu
	 6P6fN8yaeS5/tXyVJP6Nro/3HD4NloFLvx7VjbhKkw2H+Y0vjq9BaUS3XGRKWPuoHQ
	 RyH0esGnHUo38AAP/bW+Q9lZa/WJdLbIrkOAyM2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Maennich <maennich@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/290] kheaders: explicitly define file modes for archived headers
Date: Wed,  3 Jul 2024 12:39:32 +0200
Message-ID: <20240703102911.381942993@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d7e827c6cd2d2..206ab3d41ee76 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -84,7 +84,7 @@ find $cpio_dir -type f -print0 |
 
 # Create archive and try to normalize metadata for reproducibility.
 tar "${KBUILD_BUILD_TIMESTAMP:+--mtime=$KBUILD_BUILD_TIMESTAMP}" \
-    --owner=0 --group=0 --sort=name --numeric-owner \
+    --owner=0 --group=0 --sort=name --numeric-owner --mode=u=rw,go=r,a+X \
     -I $XZ -cf $tarfile -C $cpio_dir/ . > /dev/null
 
 echo $headers_md5 > kernel/kheaders.md5
-- 
2.43.0



