Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AF0762C1;
	Wed, 21 Feb 2024 13:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523592; cv=none; b=MNNvVtToEV2YIscJA90SEA8ba7hQrnVelaMPk96WvfwwQ0wrDI4OAaAWv1/prJuVUiCB3YcWhFZwr2QbkPFiBUGdl9a/QN1zAsw03XHVrrsfjoDmvK8XvDm3ZLuIXlgOzGdHP3a1esANvhZh9Bpi0wYbzivdEeaBe80fD1N2TK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523592; c=relaxed/simple;
	bh=xe4YFakJTFwxcOPNvNCTWt4YAVbR4gfkl75aaNyTJQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohv8yssLG4t036RUhhj/weXL7rM93/SV4sXBR+Bu1rKpPQgBx75/6WDNt1AsvpSxY1XXyC88gTFyXP5Yul3J3TN7Wnx/uEYIboBPuNzJdBTJCQVepE3/vz+b0732FU3+ayEwo+4az/MOHO56NbHOkxhUpI7FfkTru//sBFYgXAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmpWl+fq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmpWl+fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073B5C433F1;
	Wed, 21 Feb 2024 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523592;
	bh=xe4YFakJTFwxcOPNvNCTWt4YAVbR4gfkl75aaNyTJQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmpWl+fq1fRP/CcgOfGbVccqI7IbT+eHMFmdKJpyEkltFwMNvQwMQlEojLr2am1PH
	 Jcrf1PiDmh7lPilG+bJCD0NJ8kxBPzWoVg9DDAXf79aqJFkjCGIUMSRVvz71xyMS1V
	 zfg/v9f4nUqgOmmciD0URgHCZ3/HhKYBXbYiojlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 455/476] scripts: decode_stacktrace: demangle Rust symbols
Date: Wed, 21 Feb 2024 14:08:26 +0100
Message-ID: <20240221130024.859760697@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7075e26ab2c4..564c5632e1a2 100755
--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -8,6 +8,14 @@ usage() {
 	echo "	$0 -r <release> | <vmlinux> [<base path>|auto] [<modules path>]"
 }
 
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
@@ -180,6 +188,12 @@ parse_symbol() {
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



