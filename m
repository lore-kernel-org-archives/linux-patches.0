Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4F42E9730;
	Tue, 17 Jun 2025 15:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174609; cv=none; b=rgpvIv2VeRgBLX5kWQ11uPlIlgLLRs+2NEBT49f1RSt9PBi22TT3a4XHHb0YiSEjYT8rNA16OkcaF4z3Mcg5EhP/PgmKOguDetk8mq73A30AGiR/DVNwz85uLZ18PYCAlzWmyet/u+4X9tJVTov9iioEJROg6fo4atv8XQRsrpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174609; c=relaxed/simple;
	bh=q5hWFfvffk8O4II8u8mtGuqSswxaBt/7PXGnr6Ez+Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lIiIlQlhRME3uOMP/QjQTktRt1KsM5Uz3VYoDO9mUeGPiJxqWqZ9/LjVxrRBC3sNsKtVXHfuukllsgAdacJD0aI8THJ327ehI1hahfjOpWub7GZ0/t8DIVYYBX8t/ND4i1aQ/iopgPQtbsqCBZw4ofJkqNAlNsNjA6KGF5VW7sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEW++Wet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEW++Wet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCAFC4CEE3;
	Tue, 17 Jun 2025 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174608;
	bh=q5hWFfvffk8O4II8u8mtGuqSswxaBt/7PXGnr6Ez+Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEW++Wet45zVYSrHU98uYAmdNMW7NAHpyXSbMkCCDn+hv6yQkVVT0HbNOpNiZTTy2
	 hks8ZSW8pCLR+MDL7ql+Sv/FuTefN6aqwlQuzSfmYfDX7H20JfG5O+lUcuVKilDCcK
	 OrnBh3Lj4eqZmv2ic93DqvZVXLVbBzb2xp6ie8jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/512] tools/nolibc: fix integer overflow in i{64,}toa_r() and
Date: Tue, 17 Jun 2025 17:20:08 +0200
Message-ID: <20250617152421.251891310@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 4d231a7df1a85c7572b67a4666cb73adb977fbf6 ]

In twos complement the most negative number can not be negated.

Fixes: b1c21e7d99cd ("tools/nolibc/stdlib: add i64toa() and u64toa()")
Fixes: 66c397c4d2e1 ("tools/nolibc/stdlib: replace the ltoa() function with more efficient ones")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20250419-nolibc-ubsan-v2-5-060b8a016917@weissschuh.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/stdlib.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/include/nolibc/stdlib.h b/tools/include/nolibc/stdlib.h
index 75aa273c23a61..4dd421ef4c021 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -274,7 +274,7 @@ int itoa_r(long in, char *buffer)
 	int len = 0;
 
 	if (in < 0) {
-		in = -in;
+		in = -(unsigned long)in;
 		*(ptr++) = '-';
 		len++;
 	}
@@ -410,7 +410,7 @@ int i64toa_r(int64_t in, char *buffer)
 	int len = 0;
 
 	if (in < 0) {
-		in = -in;
+		in = -(uint64_t)in;
 		*(ptr++) = '-';
 		len++;
 	}
-- 
2.39.5



