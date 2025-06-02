Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F36422E3FC;
	Mon,  2 Jun 2025 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875945; cv=none; b=GcYmTTIPQpyB4EGyL5ZpT/i1PUbvfBx/V6svmr3Sn8aC5ZLiKfKaSDuzZV4fzAEb9Gb2HWGtMtFt3qvgiNT2dgUdsm5x88pAn3RbvJZKWU8PNABDN1EbxMkGpgSyIZnciiiCYJ6GrAnl+uyjLtRGKWFWkgGZhVOERoh+bF6uN4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875945; c=relaxed/simple;
	bh=Eh5bRi0POL8YIzyJ2jLrW7kDSA1dubKFaUvc2TnzdjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3spgK83jbA6j9CgU54DFes7RJ6lIwp1a0aMBYtOu53wn6/81tir30AS9m77EP5tqXS7E1SQYUgnk9ut4CFPjfR+pbNVKIL14SJ/nrKgrVdctoVk73QGojcBtlpusPHz2xguaC/FMOhpYjdbDC+BjCgKyoe0LWK5Ud3SiazvsyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkZPSR1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkZPSR1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2B1C4CEEB;
	Mon,  2 Jun 2025 14:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875944;
	bh=Eh5bRi0POL8YIzyJ2jLrW7kDSA1dubKFaUvc2TnzdjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkZPSR1FvX4AQfHOZ+aFFrkeGAuZ4JoVRtG2sYCVv14xutt/rDaYnXqb0d1SVrgUU
	 b1FS4bCKrLojpoWSWq/9bHU7OoDczsyRWI3lH8IKoaumXTHSZwGH06BbZMb8bz7Gb7
	 w67XTThAnNUbDtCSsJIGIL3EX7uLPKgyEJtUknDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gomez <da.gomez@samsung.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/207] kconfig: merge_config: use an empty file as initfile
Date: Mon,  2 Jun 2025 15:46:20 +0200
Message-ID: <20250602134259.098360990@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

From: Daniel Gomez <da.gomez@samsung.com>

[ Upstream commit a26fe287eed112b4e21e854f173c8918a6a8596d ]

The scripts/kconfig/merge_config.sh script requires an existing
$INITFILE (or the $1 argument) as a base file for merging Kconfig
fragments. However, an empty $INITFILE can serve as an initial starting
point, later referenced by the KCONFIG_ALLCONFIG Makefile variable
if -m is not used. This variable can point to any configuration file
containing preset config symbols (the merged output) as stated in
Documentation/kbuild/kconfig.rst. When -m is used $INITFILE will
contain just the merge output requiring the user to run make (i.e.
KCONFIG_ALLCONFIG=<$INITFILE> make <allnoconfig/alldefconfig> or make
olddefconfig).

Instead of failing when `$INITFILE` is missing, create an empty file and
use it as the starting point for merges.

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/merge_config.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index 72da3b8d6f307..151f9938abaa7 100755
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -105,8 +105,8 @@ INITFILE=$1
 shift;
 
 if [ ! -r "$INITFILE" ]; then
-	echo "The base file '$INITFILE' does not exist.  Exit." >&2
-	exit 1
+	echo "The base file '$INITFILE' does not exist. Creating one..." >&2
+	touch "$INITFILE"
 fi
 
 MERGE_LIST=$*
-- 
2.39.5



