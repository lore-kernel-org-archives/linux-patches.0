Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085091891DC;
	Wed,  3 Jul 2024 10:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004219; cv=none; b=YnWo+gruj75mb1c6FNemnym6goc8ChD2U3l0X4kJtKNYQ3JACBN9o/AcHRbiKHWp85gubkXP5cTuQbYYaYC9rjWZWac5OztbTVTRKmRNvdz3AJgtmQBx2lay6qr6XOmi4qLznQD78wu4H2kbo8x5OOBRisYqYtS16+I+kNd5iws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004219; c=relaxed/simple;
	bh=hYfKbOZdzAOpPBhMdNByCuDwqTkDZ/4wMH/Sg/qry3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCo0+kz32GYX1RRUV4sgBWsb0Bm3XZWsL2XLYNKUouR4cP8xT6O53Y/F8TabLiOtGXJlZQA49fNWS4jD/mD/eUWC4lim2grdn2C8oYazbwNsO6f6FUMVEcYb0XemLmd1FWeFOxKSeepfX0Uxt5bYglronmSPM2tVIzoCTV9xGss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHI0dItz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHI0dItz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C5DC2BD10;
	Wed,  3 Jul 2024 10:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004218;
	bh=hYfKbOZdzAOpPBhMdNByCuDwqTkDZ/4wMH/Sg/qry3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHI0dItzb64HOA63j2ByDV+Nk1EsXlIbQwXVJQ1KhZKhx9rgC7k+w+EZCLoHs+u7K
	 hCDHHH6Rb7HLZpFHpVU64YKR0OvBC80nwI9vw45YkmsZVqVFYxrjObrybtwv0TfqoY
	 Z7xP03d3yjfiZDXInmEol04cL6+4iX16KGBfcl3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Maennich <maennich@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/189] kheaders: explicitly define file modes for archived headers
Date: Wed,  3 Jul 2024 12:39:48 +0200
Message-ID: <20240703102846.285605473@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



