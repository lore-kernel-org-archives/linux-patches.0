Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD6E3CFF55;
	Tue, 16 Jun 2026 18:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635642; cv=none; b=jcwNzr8x8ktwDHkwoOhPAKxaIBTM5/5glUyiqCPZLQCjQzKZ+HrVsq+kDq/apGY1EKf8D3MWrfudlql69RBYNaJ2Xecjs0tQJiKzQ3BlPbuygEwMYzaqttkUNDtRL8M2B/2WJJLQUEg7v8Q2XkQBcbzsoiAc0Jp4rEXOtfewrOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635642; c=relaxed/simple;
	bh=KUix29Z6hNvdqnDIwc05XX4xjxqLQ2VcSV3yS8Zuwek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqhCPjjCA1cGf60dmwxRJJ5hfwQGnglFhYDLoYQ8PyT34Uo9kC+1ioiIb2CADNd63tmn97jsvcnv7AYbV8o709PbYGvXMZxOvmcADOLQfWM3kAnz75JFnMWCXcg01oCa7mi1fG6CM0qZ7ySfYpItY1VnBU1UggH/4/bHq/MLCxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxunxbXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxunxbXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65171F000E9;
	Tue, 16 Jun 2026 18:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635641;
	bh=BByAJDEXE7Q/24PMvGE5XCrnbO30VGclSGVEj+k/9ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FxunxbXcr4d4gVEa6THw7gixwMGMsLIPx0We1hdg9UZ7JQzAPRyl3pOAk8F76PrVi
	 NdFLmCHvbKRcPmF5WwzoIibbzIOXNKUDA3je0ykq8FyGSjI1xCOpzYO+1NIL9kZUAW
	 GaWaerycurjBbEONjgX3jv06gLd8MMgfgsvCwhHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 054/342] Bluetooth: L2CAP: fix chan ref leak in l2cap_chan_timeout() on !conn
Date: Tue, 16 Jun 2026 20:25:50 +0530
Message-ID: <20260616145050.774745312@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 9dbd84990394c51f5cee1e8871bb5ff8af5ed939 upstream.

__set_chan_timer() takes a l2cap_chan reference via l2cap_chan_hold()
before scheduling the delayed work.  The normal path in
l2cap_chan_timeout() drops this reference with l2cap_chan_put() at the
end, but the early return when chan->conn is NULL skips the put,
leaking the reference.

Add the missing l2cap_chan_put() before the early return.

Fixes: adf0398cee86 ("Bluetooth: l2cap: fix null-ptr-deref in l2cap_chan_timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -435,8 +435,10 @@ static void l2cap_chan_timeout(struct wo
 
 	BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
 
-	if (!conn)
+	if (!conn) {
+		l2cap_chan_put(chan);
 		return;
+	}
 
 	mutex_lock(&conn->chan_lock);
 	/* __set_chan_timer() calls l2cap_chan_hold(chan) while scheduling


