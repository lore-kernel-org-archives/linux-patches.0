Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DA12222BB;
	Mon,  2 Jun 2025 14:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873304; cv=none; b=LbgRQgj+xSh0wfK+lQc/IcEdIWjJ3G1jCgrdb5JVrTlNk+b3AjIlIulxiy0EyoE9bV/a+aGcxTypZ9h7a4f9YJtz4aBRpG2s8nOLrOrWQxQFc0+zG3ZKEfH9B/4YlTnpC0FSRRpi5SVsvGjGhYKm7BwvlPt5OGbChCTt4V7C+1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873304; c=relaxed/simple;
	bh=jkOvM4mtaJIDUYXGkFs6rfZR4n96+O8BB4B3E9zi5QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klhSBg4Y8MfALWeF1Z0P6u/ATAKOjltyjBflDe4fCE8yr4vWW8NKiKGfr7HGJpA8PXuLXg3VbwvILub52KcBLoOME71MENzoub8aHdXTCX9bCOJ6mub/K7qgMUFgHCrxc1c40G+4ujg7TIybJR5+x1oc+i+vSCnBiA9CWWjLXSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3R867gF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3R867gF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131F2C4CEEB;
	Mon,  2 Jun 2025 14:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873304;
	bh=jkOvM4mtaJIDUYXGkFs6rfZR4n96+O8BB4B3E9zi5QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3R867gFXri+1FDmtibtdM3qWoGNGaSIvZdYDRgkOn0Ksd6nNHonMT+R53+qZNI7u
	 p1OZl15lMG445ivAO7jmmkaX2I7s2pvn2+jZyzKDtCzqthZPQO5sCpqd6eDPMJ7fmu
	 mqg6BiFfS5JF2Ec/sz0PvDaeGS1UeP6p7C79vKVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <imandevel@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/444] kbuild: fix argument parsing in scripts/config
Date: Mon,  2 Jun 2025 15:42:43 +0200
Message-ID: <20250602134344.921702799@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seyediman Seyedarab <imandevel@gmail.com>

[ Upstream commit f757f6011c92b5a01db742c39149bed9e526478f ]

The script previously assumed --file was always the first argument,
which caused issues when it appeared later. This patch updates the
parsing logic to scan all arguments to find --file, sets the config
file correctly, and resets the argument list with the remaining
commands.

It also fixes --refresh to respect --file by passing KCONFIG_CONFIG=$FN
to make oldconfig.

Signed-off-by: Seyediman Seyedarab <imandevel@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/config | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/scripts/config b/scripts/config
index ff88e2faefd35..ea475c07de283 100755
--- a/scripts/config
+++ b/scripts/config
@@ -32,6 +32,7 @@ commands:
                              Disable option directly after other option
 	--module-after|-M beforeopt option
                              Turn option into module directly after other option
+	--refresh            Refresh the config using old settings
 
 	commands can be repeated multiple times
 
@@ -124,16 +125,22 @@ undef_var() {
 	txt_delete "^# $name is not set" "$FN"
 }
 
-if [ "$1" = "--file" ]; then
-	FN="$2"
-	if [ "$FN" = "" ] ; then
-		usage
+FN=.config
+CMDS=()
+while [[ $# -gt 0 ]]; do
+	if [ "$1" = "--file" ]; then
+		if [ "$2" = "" ]; then
+			usage
+		fi
+		FN="$2"
+		shift 2
+	else
+		CMDS+=("$1")
+		shift
 	fi
-	shift 2
-else
-	FN=.config
-fi
+done
 
+set -- "${CMDS[@]}"
 if [ "$1" = "" ] ; then
 	usage
 fi
@@ -217,9 +224,8 @@ while [ "$1" != "" ] ; do
 		set_var "${CONFIG_}$B" "${CONFIG_}$B=m" "${CONFIG_}$A"
 		;;
 
-	# undocumented because it ignores --file (fixme)
 	--refresh)
-		yes "" | make oldconfig
+		yes "" | make oldconfig KCONFIG_CONFIG=$FN
 		;;
 
 	*)
-- 
2.39.5



