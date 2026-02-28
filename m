Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711EE372235;
	Sat, 28 Feb 2026 17:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301531; cv=none; b=hL4EY6mOnvUp3yzMEI6cXbpmNrEiSsuIDG0t9fhKjCikSoc/cKhpCoVZ6ZuBztvdjQnPCXpYuSwgYCfPJWScd7c5z1S5YIabUuHpog5lEvdWdZ0PlRZrcNpbfqav0OROlju0AU9WygK/+/J4vHWYInOoaS5N8+0eQC2HlF17674=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301531; c=relaxed/simple;
	bh=coOCPQaLt3/lxoVZ3zWsfYGpDvAz1Ila6eSME24QlyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SM92ehIOaF+yaY/blrdYDnXL7mTBq40I3Bn9MzzM264bVS4FY7NwLbGzo5JcanFNgC3XFIo7vns3ShDmXdNOFL1wQvS25/6TA7C/3pLETqO+URg6RmJqjXE2/vX3HrO2xlNod4Wm7jcVPEkcugwzN6pEI0r9nG24Q86SOe3kxG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHhhV2S4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHhhV2S4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6392DC116D0;
	Sat, 28 Feb 2026 17:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301531;
	bh=coOCPQaLt3/lxoVZ3zWsfYGpDvAz1Ila6eSME24QlyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHhhV2S4dB63t4Y8ho8K9Qz6vaRB+DLYxO6BUwN+h7s1ykP4+uNOg7K3pyQmYE+bu
	 8S6q9VnQU00RSDfSWi66poo69xPJf5SYMWBZzTqGEBhTcUEeYwQlyFL3RA1GiZA8I5
	 3Piq/sdFcQ4835h/jAZCvojpnqVO4Nfj/f7ujLpOVv3WjkrBlUM6E4/qVhLhezvFpJ
	 CaZxvyOwyR2EqgtlSjNnLSNgber1S1eoAe0U6yM3h+ksSEO/L0EOsb5SFZFpLLCDul
	 BNt6E6cMC6cG6+3RLlYpoGlNFEJEm/zqrTQoGZG0rPaTiBMY3P/h3jZkEv0B0sVViL
	 u4XnTtJEfbEGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	stable@vger.kernel.org,
	Nicolas Schier <nsc@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 713/752] kbuild: Fix CC_CAN_LINK detection
Date: Sat, 28 Feb 2026 12:47:04 -0500
Message-ID: <20260228174750.1542406-713-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit be55899b71630c79ad01df54c92e467e47644f87 ]

Most samples cannot be build on some environments because they depend
on CC_CAN_LINK, which is set according to the result of
scripts/cc-can-link.sh called by cc_can_link_user.

Because cc-can-link.sh must now build without warning, it may fail
because it is calling printf() with an empty string:

  + cat
  + gcc -m32 -Werror -Wl,--fatal-warnings -x c - -o /dev/null
  <stdin>: In function ‘main’:
  <stdin>:4:9: error: zero-length gnu_printf format string [-Werror=format-zero-length]
  cc1: all warnings being treated as errors

Fix this warning and the samples build by actually printing something.

Cc: stable@vger.kernel.org
Fixes: d81d9d389b9b ("kbuild: don't enable CC_CAN_LINK if the dummy program generates warnings")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260212133544.1331437-1-mic@digikod.net
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/cc-can-link.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/cc-can-link.sh b/scripts/cc-can-link.sh
index e67fd8d7b6841..58dc7dd6d5568 100755
--- a/scripts/cc-can-link.sh
+++ b/scripts/cc-can-link.sh
@@ -5,7 +5,7 @@ cat << "END" | $@ -Werror -Wl,--fatal-warnings -x c - -o /dev/null >/dev/null 2>
 #include <stdio.h>
 int main(void)
 {
-	printf("");
+	printf("\n");
 	return 0;
 }
 END
-- 
2.51.0

