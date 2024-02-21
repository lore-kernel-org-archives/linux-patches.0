Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3D67BB1F;
	Wed, 21 Feb 2024 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524836; cv=none; b=WW8obyNCPcd8ltxNavZV/O53PjyjHgcvWkY/LFMbzv1jDlzxd8YEQBlbfChvZ+YsuGDI7PDK3KM3aJjJKCEfSlx4i7vyRMnWDMGxc8P4lITgfZnnPE11uVxO1EmTCOsWNsuMDGOgJCQCOSfruzQ+soq1NKuYd50aBPxLZC0mcfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524836; c=relaxed/simple;
	bh=UEb7zeyuLRrcDmUObbMW8S74OZJMLyHcbxYg9FNaQi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFWslOov2yVJvKpi+5i3hLU0JaI4g2YKjPsgiETorjgORc4Dyxe5Ew7R0pUOY3cnhWKCQ4XKQb+HY3DtnK9yMFHhQbN3yAVX+Qcc9jvFn5KnoFV0DNxUZE5HE9d8V7NgG1k78r/0qyPocru32CTQ+ROiYAoSWrv1BUqflzRYHQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0aUuo2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0aUuo2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7352C433C7;
	Wed, 21 Feb 2024 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524836;
	bh=UEb7zeyuLRrcDmUObbMW8S74OZJMLyHcbxYg9FNaQi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0aUuo2HKg4qaa0I1EVeDQHgkAB7WztrCjWWFoUZgJ9hmhVeukQr1r63ONRoxdmFd
	 DSvz8Uaskg+sB7NJYo09Ll9Tc2Sd/hckaCMwoUIViiGZLRVrJEoUj979qx4JrOymxQ
	 L+7906YrI8Z8hdvGa4OriKWAo6G9wKS88Vimu2mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/379] scripts: decode_stacktrace: demangle Rust symbols
Date: Wed, 21 Feb 2024 14:09:02 +0100
Message-ID: <20240221130005.804185033@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 99115db4ecc87af73415939439ec604ea0531e6f ]

Recent versions of both Binutils (`c++filt`) and LLVM (`llvm-cxxfilt`)
provide Rust v0 mangling support.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: efbd63983533 ("scripts/decode_stacktrace.sh: optionally use LLVM utilities")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/decode_stacktrace.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/scripts/decode_stacktrace.sh b/scripts/decode_stacktrace.sh
index 51d48bf65fd7..2157332750d5 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -9,6 +9,14 @@ if [[ $# < 1 ]]; then
 	exit 1
 fi
 
+# Try to find a Rust demangler
+if type llvm-cxxfilt >/dev/null 2>&1 ; then
+	cppfilt=llvm-cxxfilt
+elif type c++filt >/dev/null 2>&1 ; then
+	cppfilt=c++filt
+	cppfilt_opts=-i
+fi
+
 if [[ $1 == "-r" ]] ; then
 	vmlinux=""
 	basepath="auto"
@@ -157,6 +165,12 @@ parse_symbol() {
 	# In the case of inlines, move everything to same line
 	code=${code//$'\n'/' '}
 
+	# Demangle if the name looks like a Rust symbol and if
+	# we got a Rust demangler
+	if [[ $name =~ ^_R && $cppfilt != "" ]] ; then
+		name=$("$cppfilt" "$cppfilt_opts" "$name")
+	fi
+
 	# Replace old address with pretty line numbers
 	symbol="$segment$name ($code)"
 }
-- 
2.43.0



