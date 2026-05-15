Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FF43FF1D5;
	Fri, 15 May 2026 15:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860784; cv=none; b=qWXHZUs4FRXBNv44A5S5q7UkbbUHYmyH9Ry/VhObCT4yuvOhSmpixvYDrcLP4/cVqiVsYnba60Cq8u1lJlI/wGn/i64ojrnmUigjKoeYmEj5wtDFSuVX1gymIFI4574JSM58xMKXTY2ptvSVUcqhUdgG5ZdBCBrqGDtBVHU8WaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860784; c=relaxed/simple;
	bh=XwtpgNGQ6Yc1q29X17wX0IP+eOzEL116KUT+XKcubEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/seKohASw+s1yc1g19Y3rcFScYnOf9/V01Ebuk/r/ZqY1DVwYKu6C57gAOZInUIsDdiM8WbqLCC8cNUJPOWQV9bJP7IMs7WxSQvnsxvvmWh377jDnTXt03xe9yJZM3w6rg5UNu5n/cfXB7Ed4+c/Kfiq0Ffa8x5iLNqU7NLEr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bo5sc9Q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bo5sc9Q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C8CC2BCB0;
	Fri, 15 May 2026 15:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860784;
	bh=XwtpgNGQ6Yc1q29X17wX0IP+eOzEL116KUT+XKcubEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bo5sc9Q8nPN6vNy1PoeLeAiueHt4nP5qrHMAJXiuqLTb82GTnHbLTtQ8kYHeuug4p
	 K/Q9y/hIqNOoBDPHDgKnXceG/iUt7SDHfm24sQ3CXfUBjubD8KPj7XdHBUckeqEt2z
	 xjYmUgSPnOvQ7wMAbchuRNEGI9qKRJ3wfuUWcNhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.6 079/474] extract-cert: Wrap key_pass with #ifdef USE_PKCS11_ENGINE
Date: Fri, 15 May 2026 17:43:08 +0200
Message-ID: <20260515154716.748348778@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nathan Chancellor <nathan@kernel.org>

commit 4f96b7c68a9904e01049ef610d701b382dca9574 upstream.

A recent strengthening of -Wunused-but-set-variable (enabled with -Wall)
in clang under a new subwarning, -Wunused-but-set-global, points out an
unused static global variable in certs/extract-cert.c:

  certs/extract-cert.c:46:20: error: variable 'key_pass' set but not used [-Werror,-Wunused-but-set-global]
     46 | static const char *key_pass;
        |                    ^

After commit 558bdc45dfb2 ("sign-file,extract-cert: use pkcs11 provider
for OPENSSL MAJOR >= 3"), key_pass is only used with the OpenSSL engine
API, not the new provider API. Wrap key_pass's declaration and
assignment with '#ifdef USE_PKCS11_ENGINE' so that it is only included
with its use to clear up the warning. While this is a little uglier than
just marking key_pass with the unused attribute, this will make it
easier to clean up all code associated with the use of the engine API if
it were ever removed in the future. While in the area, use a tab for
the key_pass assignment line to match the rest of the file.

Cc: stable@vger.kernel.org
Fixes: 558bdc45dfb2 ("sign-file,extract-cert: use pkcs11 provider for OPENSSL MAJOR >= 3")
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://patch.msgid.link/20260325-certs-extract-cert-key_pass-unused-but-set-global-v1-1-ecf94326d532@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 certs/extract-cert.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/certs/extract-cert.c
+++ b/certs/extract-cert.c
@@ -43,7 +43,9 @@ void format(void)
 	exit(2);
 }
 
+#ifdef USE_PKCS11_ENGINE
 static const char *key_pass;
+#endif
 static BIO *wb;
 static char *cert_dst;
 static bool verbose;
@@ -135,7 +137,9 @@ int main(int argc, char **argv)
 	if (verbose_env && strchr(verbose_env, '1'))
 		verbose = true;
 
-        key_pass = getenv("KBUILD_SIGN_PIN");
+#ifdef USE_PKCS11_ENGINE
+	key_pass = getenv("KBUILD_SIGN_PIN");
+#endif
 
 	if (argc != 3)
 		format();


