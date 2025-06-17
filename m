Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B387F2ECEA2;
	Tue, 17 Jun 2025 15:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175191; cv=none; b=gouZHs2UI5HjsPArIt6AjAT8KXUUYS9X1e1MvmY8t8FPd2mTDMBoC+sUW4cCJRQQ6V4vFsBQ3sw2z+6O5sJeNl4uYMOUx6JxR/8V6tix4V7GNsJ7eYMeH6Zk2FxlIIHVc6v/ZEnabMpE5iKKS79i0fpc/6BqHhKh2rk8vF47Qjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175191; c=relaxed/simple;
	bh=uQL038PFPxYl4OWSa4RqO2DCTLQY8xDtHZEpll97eEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NYliydqGSAOCgvRexaSpdRtVrmC0pONzNU+u9ujbpM+XneWWlsqrCbX9Nx7ofAKqXNas7t7n8raZra3rAbvFu7isW2uch8xaBovAtAObTSzDa+X2KuopId5KzkQvpZNYfJ3kQVkZ0U4lvqKJUzf18k/24/xavG0RnjJ6GRV/rvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwbJWyF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwbJWyF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C45EC4CEE3;
	Tue, 17 Jun 2025 15:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175191;
	bh=uQL038PFPxYl4OWSa4RqO2DCTLQY8xDtHZEpll97eEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwbJWyF2+PRoS5jZykeTCgqerf/1ZOAPdNVtptUSWUtF1eW9ahXTE6LrwQVnUFe6A
	 rx8QWPFLX4XFaVz4aTMWKz+xVygt/M6wlR4RR+y3YJvgKiIW5cUY8hrYEDzsEYUYkO
	 fsX8PlWWp7q/42pcaAehRvbFr/+IDB6bc+DVH01M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 061/780] tools/nolibc: fix integer overflow in i{64,}toa_r() and
Date: Tue, 17 Jun 2025 17:16:09 +0200
Message-ID: <20250617152453.984157843@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86ad378ab1ea2..32b3038002c16 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -275,7 +275,7 @@ int itoa_r(long in, char *buffer)
 	int len = 0;
 
 	if (in < 0) {
-		in = -in;
+		in = -(unsigned long)in;
 		*(ptr++) = '-';
 		len++;
 	}
@@ -411,7 +411,7 @@ int i64toa_r(int64_t in, char *buffer)
 	int len = 0;
 
 	if (in < 0) {
-		in = -in;
+		in = -(uint64_t)in;
 		*(ptr++) = '-';
 		len++;
 	}
-- 
2.39.5



