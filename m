Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BC01C3F19;
	Tue, 27 Aug 2024 15:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771312; cv=none; b=AwUzsAOKEi+qQhVjdrl8TdyBFIlRRKSpR6upSYBUOLOWs7cLFmyr++xOFuPDri8Dg7rkcJQIzbhDDraKTy7bD82HP0An6Pisuhxp7iBMN2C+fMyhtKkhtqURstPISC173H73BV9HnXe0iDDa8BvI5tGzLHOeE5WJug3DnvLpamM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771312; c=relaxed/simple;
	bh=uW4s/yAaLaNRO9UdBpqKsAGvW1kEumrKSAo7UX/HBw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fra6WY4nr9wWjKq8K9d03mKXqFXAji3qvcoz586STRvDMpnbJiKVPEi7Tg3KkPxtpxgeznPeSa6Wzt5pdzJvNStmbulOf6R0Z8yKe9dyHNctf41a9HnfLITgpKKstexogKGoNm2WsIwHckKgAyHLhKCeWvqg6M1QpY8e8YfzmYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLPyYOXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLPyYOXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B4BC61074;
	Tue, 27 Aug 2024 15:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771311;
	bh=uW4s/yAaLaNRO9UdBpqKsAGvW1kEumrKSAo7UX/HBw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLPyYOXwLtRphSFixljR8mQ4jwNIjFZt/ML7PuIhiQSx0tpq/PrQGwPMO0QJl+M3c
	 TDOLdyo3JP5Y4zK48Z0kH0alQ4SHvHHBX7L5owi2yB6IUI68PufLHFFpWcfXH23+VN
	 YB2maXoEpISPcrG4ZcRkz+ppb57S4Z8waCjYA7QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gomez <da.gomez@samsung.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 150/273] kbuild: avoid scripts/kallsyms parsing /dev/null
Date: Tue, 27 Aug 2024 16:37:54 +0200
Message-ID: <20240827143839.112284483@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 1472464c6248575bf2d01c7f076b94704bb32c95 ]

On macOS, as reported by Daniel Gomez, getline() sets ENOTTY to errno
if it is requested to read from /dev/null.

If this is worth fixing, I would rather pass an empty file to
scripts/kallsyms instead of adding the ugly #ifdef __APPLE__.

Fixes: c442db3f49f2 ("kbuild: remove PROVIDE() for kallsyms symbols")
Reported-by: Daniel Gomez <da.gomez@samsung.com>
Closes: https://lore.kernel.org/all/20240807-macos-build-support-v1-12-4cd1ded85694@samsung.com/
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/link-vmlinux.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 22d0bc8439863..070a319140e89 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -215,7 +215,8 @@ kallsymso=
 strip_debug=
 
 if is_enabled CONFIG_KALLSYMS; then
-	kallsyms /dev/null .tmp_vmlinux0.kallsyms
+	truncate -s0 .tmp_vmlinux.kallsyms0.syms
+	kallsyms .tmp_vmlinux.kallsyms0.syms .tmp_vmlinux0.kallsyms
 fi
 
 if is_enabled CONFIG_KALLSYMS || is_enabled CONFIG_DEBUG_INFO_BTF; then
-- 
2.43.0



