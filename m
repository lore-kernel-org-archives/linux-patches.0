Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEF43DEAC2;
	Mon,  4 May 2026 14:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904788; cv=none; b=J5JISDgpyo6QWDUt8t9gYGgHTJ3lK9QpKecni2nsX4FyneNTWpbi81nt10Hc9U0XP20OPy5kkcOqaRF1UpxaU+8HAIMjZcDVaZzHwWa6f1Sb+j09dfSrLsRjZw9FcqK400fmmjJ42dNTlvM74VgN9qsmZ4bCnlxtzumVCv0pOt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904788; c=relaxed/simple;
	bh=5/GSNmGWuU+SuWuZpR0Em3+QQ8/5q2a0wcbm6w5jMsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ph51CbLcd082OC1XbTumqEIosIkmFN9QJdIMwIb8zvYI40aUPMcSc+945eB3yeWZ8PdjNnTqikLWapnmOcCbBwHWpIwF2nwN4YbaDN4EOk9RiC2x/gq0AEe4F/bN/SWvSuj+/XoiFgsb8J+Tz2zGeM3O1hjz93+gQICSeFzBf1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCseIYB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCseIYB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B34C2BCB8;
	Mon,  4 May 2026 14:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904787;
	bh=5/GSNmGWuU+SuWuZpR0Em3+QQ8/5q2a0wcbm6w5jMsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCseIYB/ZtS/6VbRTMCWFY9i17hQoQ0WeaJY5T+ylpGmAJvmZktkqy1x5kuLXKgg5
	 PKfFQ+cbkWAap0rsr+vPuQQqT3O2HlU1vaF3yWbyB5s9VLfxc1PhsiD1Xubc3pgcJA
	 6wGZWs7OrGHAWgigo3mn3kQQw1cbBrtVgeBiyOUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>
Subject: [PATCH 6.12 142/215] check-uapi: link into shared objects
Date: Mon,  4 May 2026 15:52:41 +0200
Message-ID: <20260504135135.342707829@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit a261f6dff3c1653c19c065c3b3650c625447b8a7 upstream.

While testing ABI changes across all architectures, I found that abidiff
sometimes produces nonsensical output. Further debugging identified
missing or broken libelf support for architecture specific relocations
in ET_REL binaries as the source of the problem[1].

Change the script to no longer produce a relocatable object file but
instead create a shared library for each header. This makes abidiff
work for all of the architectures in upstream linux kernels.

Link: https://sourceware.org/bugzilla/show_bug.cgi?id=33869
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260306163309.2015837-2-arnd@kernel.org
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/check-uapi.sh |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/scripts/check-uapi.sh
+++ b/scripts/check-uapi.sh
@@ -178,8 +178,11 @@ do_compile() {
 	local -r inc_dir="$1"
 	local -r header="$2"
 	local -r out="$3"
-	printf "int main(void) { return 0; }\n" | \
-		"$CC" -c \
+	printf "int f(void) { return 0; }\n" | \
+		"$CC" \
+		  -shared \
+		  -nostdlib \
+		  -fPIC \
 		  -o "$out" \
 		  -x c \
 		  -O0 \


