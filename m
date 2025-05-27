Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B09A1CD0C;
	Tue, 27 May 2025 17:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366789; cv=none; b=r8zcWgs36F3lP7QECMB2dNUxMsg1geH88DBAAS4lqMCkl7ziZfiB4xm77vWo3QF+n/VdT1sh0Y5zhgTi5tw2znvkKJLbPaugsLYOT2yaRaSWQHpt60vDd8Sk2Mr6/E6wO1rt6uqiinzJI0JTQN4wP5zeNG4PqHTiRKnumxH8VQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366789; c=relaxed/simple;
	bh=G04qnh1yxbb7s2VFNj+KIfkL+1vBGWk5g5EmSBaMjDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yhl2MMOEARlOK9+h1b0EqL1OX9wzRxFvX2Vb7PfuP9YPyI4nEYcmG0UAisG5qbCMEWonWtXsepw/kkdoklSiZlsP96RZuwOpcrgVlIefPDpAQKZeeljW0aXqwm2RXwhc9KUi4WR/5JAcSdHcKwBNGNCBgeKdU7H6yRoIPlQMzM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9RfYdWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9RfYdWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04849C4CEE9;
	Tue, 27 May 2025 17:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366789;
	bh=G04qnh1yxbb7s2VFNj+KIfkL+1vBGWk5g5EmSBaMjDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9RfYdWzuN5fZzVbP8q3v6WzsE9D363EfYhtSklInUsN5962I7/kxTBOM0RdptGld
	 hiZXOXpiCZnbDTDQSNARErhcdtuA68O4/0f0QwGu26a2vXodFyWFIHC0KqW825Fo6b
	 jAsxLGuKp5s7kxWxEezr5JIWotjBsS2rWZ3CIaaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seyediman Seyedarab <imandevel@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 177/783] kbuild: fix argument parsing in scripts/config
Date: Tue, 27 May 2025 18:19:34 +0200
Message-ID: <20250527162520.369575032@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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



