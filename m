Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECBE19CD17;
	Thu,  6 Jun 2024 14:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683076; cv=none; b=fVOogvJU5OcxaXWfmdmwShfmdQ3T/UwPROrFmX2JDpZad/ORYLLaPdaPIRx9DXI0QJNwhZdTHSpWrUJfnox868LBk3rwOUKn8/GIfdaxmyJSo1u4FGSztIUBOoGYK2935bCXL/SPrGsMxrpTgT4uctbri8M8STmZBQ0PVE/QOPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683076; c=relaxed/simple;
	bh=7Wc8oC0ZRkCAlmIX3SjLbnlNOWNmDMjTB3f48Cm+vXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoF1BdbCZeGvUm52v2HVraivwnt+jijl47FLtxjYAX0mLO0XQWJvESwlL8gYjeEGQvn+gudGHYCDpnxS1UVxqADjxxMWg5IHcYKzMhgn1gfNJVXmOdPfJIXXFiXY9JqhDOyPwxXV1Sf9HXMetFDNcyBZSk9BJdkeIeUqbSsBz50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCtfCmYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCtfCmYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBB5C32781;
	Thu,  6 Jun 2024 14:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683076;
	bh=7Wc8oC0ZRkCAlmIX3SjLbnlNOWNmDMjTB3f48Cm+vXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCtfCmYyYBhlkqAIClEqQrmsSgGXzFDn3Wd7trBa44RLxVo3pyKJ76He/c5fxfyDB
	 IHFy/Trg+pFVZBnF2w78uDT0JFumpfEB3vacUUHUSOaY39efE4N1ZuIKKimnv/h+Mh
	 hBaSEXxSdd50zfbMUyg4xOAWsfjp3tL7/UfwOxi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 343/374] kheaders: use `command -v` to test for existence of `cpio`
Date: Thu,  6 Jun 2024 16:05:22 +0200
Message-ID: <20240606131703.340724691@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 6e58e0173507e506a5627741358bc770f220e356 ]

Commit 13e1df09284d ("kheaders: explicitly validate existence of cpio
command") added an explicit check for `cpio` using `type`.

However, `type` in `dash` (which is used in some popular distributions
and base images as the shell script runner) prints the missing message
to standard output, and thus no error is printed:

    $ bash -c 'type missing >/dev/null'
    bash: line 1: type: missing: not found
    $ dash -c 'type missing >/dev/null'
    $

For instance, this issue may be seen by loongarch builders, given its
defconfig enables CONFIG_IKHEADERS since commit 9cc1df421f00 ("LoongArch:
Update Loongson-3 default config file").

Therefore, use `command -v` instead to have consistent behavior, and
take the chance to provide a more explicit error.

Fixes: 13e1df09284d ("kheaders: explicitly validate existence of cpio command")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/gen_kheaders.sh | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
index 6d443ea22bb73..4ba5fd3d73ae2 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -14,7 +14,12 @@ include/
 arch/$SRCARCH/include/
 "
 
-type cpio > /dev/null
+if ! command -v cpio >/dev/null; then
+	echo >&2 "***"
+	echo >&2 "*** 'cpio' could not be found."
+	echo >&2 "***"
+	exit 1
+fi
 
 # Support incremental builds by skipping archive generation
 # if timestamps of files being archived are not changed.
-- 
2.43.0



