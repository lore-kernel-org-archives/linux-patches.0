Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CDF227586;
	Mon,  2 Jun 2025 14:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875477; cv=none; b=DsJM8cCkLJP0QvKHrsGvnLDYlkE8VI4ufkPHAwlVXPemEwzacqlViQ9aJ0Pveyr+EKhQs2vjoFKiDG4paBUzvc9Ai16G6n+2Tgp74CvhBtdRlP7hKHxDFi8tmiaWu7UeW5GBPW+ZGnuJb/Xuk1dg95uVabIuib1zBRxAGE2MbdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875477; c=relaxed/simple;
	bh=w4ikRrS5HEMaL5T6rNYz2ZcO7sfWebqt9LfYE3i3Ba8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAX/8St0kww7otz69PScEi3r+RHCw7gSv6N+EYg5j9gOlMPWQ/Ydr8gBbXjZplQXNfKXbfzcKACgszih8UhgFJdF6O04FmotFCtN/O+M4qzz6yz41O7BuGgadN5TUW8lFY/SrZsT7K48TV+wuMPM5Zl6gR1zIiQj7NpEZ58uYt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkDvrHJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkDvrHJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B40C4CEEB;
	Mon,  2 Jun 2025 14:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875476;
	bh=w4ikRrS5HEMaL5T6rNYz2ZcO7sfWebqt9LfYE3i3Ba8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkDvrHJRL+1WK9HM1EKIz6azuW4aBK7Nw85iPEt4MCMvtMWRW64DBGAJo11kdyQIW
	 ODCiC+U6bfc3LNJTmJxdHORrvLhKay/WGuqels63tfA2AtWlcayN07yeM9H5/3XQR6
	 SXdcprytGyc63hnkrAH7n9Xm6eKez3kME+7iPjTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <imandevel@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/270] kbuild: fix argument parsing in scripts/config
Date: Mon,  2 Jun 2025 15:47:11 +0200
Message-ID: <20250602134313.194835709@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8c8d7c3d7accc..330bef88fd5ef 100755
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



