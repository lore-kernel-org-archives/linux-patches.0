Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D7D29D291;
	Tue, 26 Aug 2025 13:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215891; cv=none; b=UZtl5E/xca2VlY50hGeOvErNWMue05h1VO5MdH36B9fl46bjVzP7Yh8YZ1irJ7HS5ym4BWpNiGksYpzX/gTaVB8dh3hebIlmy6ty4d6Sc3+v01CWgYkw8hCU08isGvOBLOEED7yIBKB686KVlUR3x0GzCcucaNtDTp9XyDMJi9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215891; c=relaxed/simple;
	bh=jxgV2qE2Whl36b6Y6BE9hnnmsrClCA01fYycblVtCHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ceOfmC4+erxya9Hq2+E/Jo9JFsBXcIWxJiBQ3gDvIHJEQ2lF+Bvp1gjh8zRzQLJDI8XwT9h5j8Os9Z9GoxbZbq+vHg76cE/uO2CIrowAeisuFUw379Y4USs37O1hPwxSQrwHPETyi8mtWsDIkx/OR4Hy598GtlFU/Gjbp/jrmVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV4mo+Ig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV4mo+Ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BCFC116B1;
	Tue, 26 Aug 2025 13:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215891;
	bh=jxgV2qE2Whl36b6Y6BE9hnnmsrClCA01fYycblVtCHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV4mo+Ig+7DXdhM1WALIHqdev91UwHTrf9Y2or0/QxgTI7mxuPiK/T4vjzkoDt/T7
	 9dcRozviLn8edxY9SNBl22izgHw3BquyZ9nFC5y7l5cJEA7pYjA52OfNYaReeh0CKL
	 /CsdWWNtsh926iB4yM8WnBaqVz/N6ighyRndQWpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	MengEn Sun <mengensun@tencent.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/644] ucount: fix atomic_long_inc_below() argument type
Date: Tue, 26 Aug 2025 13:04:57 +0200
Message-ID: <20250826110951.538064140@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit f8cd9193b62e92ad25def5370ca8ea2bc7585381 ]

The type of u argument of atomic_long_inc_below() should be long to avoid
unwanted truncation to int.

The patch fixes the wrong argument type of an internal function to
prevent unwanted argument truncation.  It fixes an internal locking
primitive; it should not have any direct effect on userspace.

Mark said

: AFAICT there's no problem in practice because atomic_long_inc_below()
: is only used by inc_ucount(), and it looks like the value is
: constrained between 0 and INT_MAX.
:
: In inc_ucount() the limit value is taken from
: user_namespace::ucount_max[], and AFAICT that's only written by
: sysctls, to the table setup by setup_userns_sysctls(), where
: UCOUNT_ENTRY() limits the value between 0 and INT_MAX.
:
: This is certainly a cleanup, but there might be no functional issue in
: practice as above.

Link: https://lkml.kernel.org/r/20250721174610.28361-1-ubizjak@gmail.com
Fixes: f9c82a4ea89c ("Increase size of ucounts to atomic_long_t")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: MengEn Sun <mengensun@tencent.com>
Cc: "Thomas Weißschuh" <linux@weissschuh.net>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index 85d7c19b0b80..8c21398f7b4f 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -210,7 +210,7 @@ void put_ucounts(struct ucounts *ucounts)
 	}
 }
 
-static inline bool atomic_long_inc_below(atomic_long_t *v, int u)
+static inline bool atomic_long_inc_below(atomic_long_t *v, long u)
 {
 	long c, old;
 	c = atomic_long_read(v);
-- 
2.39.5



