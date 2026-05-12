Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A17636C5A1;
	Tue, 12 May 2026 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609610; cv=none; b=tlkqQdRu5kKRVImzcwNrTFcONMyFJsOLj73fEasApThhryCt5WY43hNW/8twx1CnHvMKoHp8XWOmCXvM23mblKX1jzO0W7reSHDZbnsuPtAUaIVla/HMLJDub4vhNOXU9WwcQ9+Yx48rS4nMrWlA4UMj6dVHTJH90o/gDTCIZ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609610; c=relaxed/simple;
	bh=hUot0dTvA3/bbzyLNaeLvsWvUb2ydi7Hg+mazhJymmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upYKonzMv/t9sfJuOtJi+8kVbm8EUona/GYg6zXbYL2aTRKARehb1YcUMx5gUy/lpKC0lltowGWuVPKOWcxLeD6PuJnTKhQtGN0sSIeffweR09Lr9bbZCd7n0UcvE8EdsZBGPt8nA/iXAfkGNPxWoWLOvj7rMCsPYF/HQ0BWDlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3YINYiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3YINYiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66C2C2BCB0;
	Tue, 12 May 2026 18:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609610;
	bh=hUot0dTvA3/bbzyLNaeLvsWvUb2ydi7Hg+mazhJymmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3YINYiLpB0nKCrDUQe8ChzKivAqCRTUbz7ygfwwqFszcujjBRkmvbq/jdDaJJY3J
	 b+Z8Epu3QN8KbU5/YLHEg74GNBsBQVP9dKb2EnaPUlESwdf6NW5Esydhpk3VbbiClw
	 2j5NAjlteiAQKcvK2ysARXYNIg9YtaNcnolWB7YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 263/307] mptcp: pm: ADD_ADDR rtx: always decrease sk refcount
Date: Tue, 12 May 2026 19:40:58 +0200
Message-ID: <20260512173945.679894197@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 9634cb35af17019baec21ca648516ce376fa10e6 upstream.

When an ADD_ADDR is retransmitted, the sk is held in sk_reset_timer().
It should then be released in all cases at the end.

Some (unlikely) checks were returning directly instead of calling
sock_put() to decrease the refcount. Jump to a new 'exit' label to call
__sock_put() (which will become sock_put() in the next commit) to fix
this potential leak.

While at it, drop the '!msk' check which cannot happen because it is
never reset, and explicitly mark the remaining one as "unlikely".

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-4-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -344,11 +344,8 @@ static void mptcp_pm_add_timer(struct ti
 
 	pr_debug("msk=%p\n", msk);
 
-	if (!msk)
-		return;
-
-	if (inet_sk_state_load(sk) == TCP_CLOSE)
-		return;
+	if (unlikely(inet_sk_state_load(sk) == TCP_CLOSE))
+		goto exit;
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk)) {
@@ -386,6 +383,7 @@ static void mptcp_pm_add_timer(struct ti
 
 out:
 	bh_unlock_sock(sk);
+exit:
 	__sock_put(sk);
 }
 


