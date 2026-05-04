Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213883DC4AB;
	Mon,  4 May 2026 14:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903501; cv=none; b=X75paBTxNGfWOTWkIfQvK1mT0wqVA38NU5F8nadywx0GBYtX5WFMm8PjZpCFlz7Ft6AstiPkFEl02hN/yoGi0JlFG5HBXXgKSOYXZDIGbFTTr1SDet0tyW0wev28WgXHyJnPUE7r1P+8txyIUmnEN5Qey+PNSNJn2N72D67LpHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903501; c=relaxed/simple;
	bh=lBHetLHnTk3qz1Rc+37OaHZ/P/yPotESJQdduXPsFGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JfcrwazA1tgIjaMyMcGkMmeLLPzM7BvuUT/46JarYZ0w/XuEomG6uhVT6K1wqwmxC0oLW60Sd3UaaA6UstuIZmEkvBg5ptLbwfQnpLxr2js6nu2PTFzM5skfE1FKVlLswVPkLVC6xStwuhl4ji3rU1wGwsGQ8q+HpzLvz0UkbrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2giSfZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2giSfZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5F2C2BCF6;
	Mon,  4 May 2026 14:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903501;
	bh=lBHetLHnTk3qz1Rc+37OaHZ/P/yPotESJQdduXPsFGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2giSfZygIYMSJfQyOEDnRQl85ctbJkKcEmD2r9uYulbu+eh2o+qAIw2U+B+4PibD
	 SATdCeVWaHY1tmFzxc/mz5oavMM/0C5sJTpZqUdi8zrAQ2OJULyVE0eNfETW3xVPxF
	 16vTFnTG6Je4dvw6R1nsiBCypFjVpiJXP82x47Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>
Subject: [PATCH 7.0 241/307] check-uapi: link into shared objects
Date: Mon,  4 May 2026 15:52:06 +0200
Message-ID: <20260504135151.903266242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


