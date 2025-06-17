Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7552E9737;
	Tue, 17 Jun 2025 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174298; cv=none; b=pEk2zmTUO4jH8tTfsXi+iLUZhtzu8Un0ZOMmZ5VI76LaaihaorpFk7Is/pgHkREf+wq29WRM3EMSpFVyVDZ7rqEYhitnccCxndlEy57FOh+sjWzupejuJt6hJAV0idvTOYuuO8PliG7DEt81GDOlDLTXaF/JTsb85nnBA4HH8/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174298; c=relaxed/simple;
	bh=2Zf04SbpjMDAGrGmxh9Pl63ezSrofIbUjrJuZptVlkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dlNGgzzYdfDxZLljPtehdehArp/iXegIyErdpfRkVV0UaHhy3XbDyPlOYw9lNRoFKbsbh8NpSmGYSjM4ioBzBfwkgB5px/3Db8SfK1yJuOnb4cmRPw+eQTKa7acMz+E5PAlw2hPym4PtGoVl138dvNR3JzrqDBiyFfVnh40ndiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbRQv3HX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbRQv3HX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF02C4CEE3;
	Tue, 17 Jun 2025 15:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174297;
	bh=2Zf04SbpjMDAGrGmxh9Pl63ezSrofIbUjrJuZptVlkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbRQv3HXe30IHTiUL4V8LD17o9aYG3uc4cMH4f3TaprzxiJSwMIMN0D40QpXcASWc
	 pKOP2UmfYS88WglTXdtznM87Q1c3XDHHuNdfWD32SaPrQ/gu2lMgKZTb5WACCTCRtH
	 NFjQ+eiI5Bs0Zh0AL/9yVtO435HRQIiunkYXmHTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/356] tools/nolibc: fix integer overflow in i{64,}toa_r() and
Date: Tue, 17 Jun 2025 17:22:38 +0200
Message-ID: <20250617152339.965263645@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5be9d3c7435a8..6bf62f5048faa 100644
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



