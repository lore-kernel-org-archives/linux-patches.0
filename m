Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A947E43BDCD;
	Mon, 17 Aug 2026 14:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977985; cv=none; b=di7Uq1+xShSwsVpGYcB2/mMoqKD3jYfJYS1H4Xb2PWZL3wZoasknD5Ia9RslT84HMVvXBKKxHC5SJkWAr/3G5Xh6vQLf/aaCXr5raz6Lds+/B5KWwTrcKoK/FVazfDLZFiZWwTGba3gYfbSnwf1fiCRgnRmoCdtnYuYm78X8SXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977985; c=relaxed/simple;
	bh=yzTPwpZNZrj1xh4cQf9IJb1j3S5C99HyCJ/o9v3VMXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm4ImABnMTra3OasQ5o0/hRzhfhDB6zTWwCIS0SER+8LgF7IVSbs9qZ4bGJmFQ9SgRgRk3AQ5vtvqNzTW2WiS1nplnijZ81bthoDPoDbdB5YI8/sgmhRMoVqTXYkOmj0JHyz+cKjBo8b/2ycNMfsDfpw2B8l+sk6aMHmIYnv4dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3aycrrF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3aycrrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1661F000E9;
	Mon, 17 Aug 2026 14:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977984;
	bh=/REEpX2e5nQZA9bgzR0aBs3Lc0TKxQHTcSJnlefXn/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3aycrrFAv8jIkFu6eCHCaxWJ88py+nmNppLB7bec9GHadhRJuiH3cs7xpE9+5AJ5
	 4vhm+upEzCTVOH7npbpNv61yBPguVvDxSgD6uak+7HmAM2D9oqCYeHu+XvMPBHkbH9
	 FdNzWvgMCcafwMq8LL6X8dGuNTUlWPgJsOfT7EPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/181] tls: dont abort the connection on signal-interrupted sends
Date: Mon, 17 Aug 2026 15:32:35 +0200
Message-ID: <20260817132537.822170081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>

[ Upstream commit af0e5cdd031f4f4a8f6d4160bfbda4f36872b0ed ]

When a signal interrupts a blocking send, tls_tx_records() treats the
resulting -ERESTARTSYS as a transmission failure and marks the socket
errored via tls_err_abort() with the raw error code. Later syscalls
return the kernel-internal errno 512 (ERESTARTSYS) to userspace, as the
signal it stems from is no longer pending during syscall exit and thus
never translated.

An interrupted send is not a connection error: the partially sent record
stays queued and is resent later. Interrupt error codes are therefore
excluded from the abort in the same way as -EAGAIN.

Fixes: b341ca51d267 ("tls: Fix tls_sw_sendmsg error handling")
Signed-off-by: Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
Link: https://patch.msgid.link/20260805063109.1772314-1-maxbr@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2b875369d5232..137a7914c3044 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -458,7 +458,7 @@ int tls_tx_records(struct sock *sk, int flags)
 	}
 
 tx_err:
-	if (rc < 0 && rc != -EAGAIN)
+	if (rc < 0 && rc != -EAGAIN && rc != -EINTR && rc != -ERESTARTSYS)
 		tls_err_abort(sk, rc);
 
 	return rc;
-- 
2.53.0



