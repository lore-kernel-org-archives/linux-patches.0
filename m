Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDF712FB27;
	Wed, 19 Jun 2024 13:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803315; cv=none; b=hfy3zWRge97hPrj7VGI5PmBJzFiq+K1bgf4ZDTrcck8f8Z6aAB+SkEdQZos/R0HW10OcbXdH/JZbDfBsP0N0RLOmEDq4OGFHSMrvnckj75RwwGdLY3T0zkadA66IGNiHs5g6oObjzWlOneRJSgXTlX3HqoMXZP+F4fmDbhzQfjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803315; c=relaxed/simple;
	bh=xjYV0BfTKlTt1QqXbPNwlpi021AO+Tim6NUY4D1uCus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2NwRrZ+OEvavVHpDNz4Hr92MSvbqzw4oF1qoOESXHgfq2naMVQiAPLMupEI3eyn8e8XKWzdcMYvLT4sdW9QvUf2zoo2MCZheZOSPgReNXFt40wSEXQSSwPs2XTBRongUgop3+PJwFDkuAqlR5A0P/Oq44fiPLVyB/XHva1dCM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oETiAV7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oETiAV7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB22C2BBFC;
	Wed, 19 Jun 2024 13:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803314;
	bh=xjYV0BfTKlTt1QqXbPNwlpi021AO+Tim6NUY4D1uCus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oETiAV7IZJ2fwDuGUtEG1k0Eu3niwuZCC/J06HJma/ErO2D10OSOsw+Ody1+xQ0iT
	 wUSTiosQrfVEMCinTmVC+zNm5gnhMqBVb9D5mkTau1HW3jYvpNtAx8obqF6FxXGDiL
	 JIw675dxMLkUHtLRMxBGyer3qHjhJ6KC9OC0l5VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Maennich <maennich@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.9 226/281] kheaders: explicitly define file modes for archived headers
Date: Wed, 19 Jun 2024 14:56:25 +0200
Message-ID: <20240619125618.654672573@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Maennich <maennich@google.com>

commit 3bd27a847a3a4827a948387cc8f0dbc9fa5931d5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/gen_kheaders.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -89,7 +89,7 @@ find $cpio_dir -type f -print0 |
 
 # Create archive and try to normalize metadata for reproducibility.
 tar "${KBUILD_BUILD_TIMESTAMP:+--mtime=$KBUILD_BUILD_TIMESTAMP}" \
-    --owner=0 --group=0 --sort=name --numeric-owner \
+    --owner=0 --group=0 --sort=name --numeric-owner --mode=u=rw,go=r,a+X \
     -I $XZ -cf $tarfile -C $cpio_dir/ . > /dev/null
 
 echo $headers_md5 > kernel/kheaders.md5


