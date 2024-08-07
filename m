Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFA523CE;
	Wed,  7 Aug 2024 15:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042896; cv=none; b=p4Ut9vP012Va0QlQc1RUwL/oNtCzZboFqycs4nFG2D53RUfyhvouItkCCiLonKV3gojHrZWhRgZF6S4b7IF5+2P501RkQPj67GARrZGVwU5UVAmQ1d4KImlXX95lhbQtA0+mvQaa3cI8OKXdDv0o73m1FgqMxXuH8S19oVeGpgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042896; c=relaxed/simple;
	bh=JnqNFOxnnR9RBAcljlJINsSUjXDn41Yln6NQTsUs66g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KF4KcwrlV6nWc/WhcSOU8TOCp/Olpb38A99J9sf6PSFOiaeeXKxysv0onnaxqxyE7LdrJT+BRiavp4ANmOGfPU9jo6zWrAGo1PQSKD5XYnf1pGIKUjk68xwSswNMUHIfTtGtR1Cs+70vwVMibEsOk7bJ7d9r18F+2aYOASgz6mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1KyXJWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1KyXJWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11721C32781;
	Wed,  7 Aug 2024 15:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042896;
	bh=JnqNFOxnnR9RBAcljlJINsSUjXDn41Yln6NQTsUs66g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1KyXJWD6SDlTZfHQLa6Qes4mGfPEu0sK/M7R4BarWqzd8lb4VITLBrzsFdroqJE7
	 k9zz+46PLFe7FAMV+BYknEpgazRX3pV79eq3rVuZ3vcI7Q+EpbPqdpI7e/FHWB+uF8
	 n5Z+tA8n6RStWzirvX50qqWjPa+y4qoBOYCXlk3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 016/123] ARM: 9406/1: Fix callchain_trace() return value
Date: Wed,  7 Aug 2024 16:58:55 +0200
Message-ID: <20240807150021.349469367@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 4e7b4ff2dcaed228cb2fb7bfe720262c98ec1bb9 ]

perf_callchain_store() return 0 on success, -1 otherwise, fix
callchain_trace() to return correct bool value. So walk_stackframe() can
have a chance to stop walking the stack ahead.

Fixes: 70ccc7c0667b ("ARM: 9258/1: stacktrace: Make stack walk callback consistent with generic code")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/perf_callchain.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/kernel/perf_callchain.c b/arch/arm/kernel/perf_callchain.c
index 7147edbe56c67..1d230ac9d0eb5 100644
--- a/arch/arm/kernel/perf_callchain.c
+++ b/arch/arm/kernel/perf_callchain.c
@@ -85,8 +85,7 @@ static bool
 callchain_trace(void *data, unsigned long pc)
 {
 	struct perf_callchain_entry_ctx *entry = data;
-	perf_callchain_store(entry, pc);
-	return true;
+	return perf_callchain_store(entry, pc) == 0;
 }
 
 void
-- 
2.43.0



