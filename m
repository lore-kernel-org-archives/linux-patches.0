Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EB628135D;
	Thu, 27 Nov 2025 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255748; cv=none; b=n/pxZzmvuYtC/rZJ62fSDMulwkG3qr2FMUmkp4HD6oNxifegEuABp6yzxoEfHdyDyRIxaKYuLsRLVdhXwfy3hZYH3cmMLLwVhFAFM5CC63q3TeUb41id+lCcfRAgV23kUIML0SI6C18BDqLaH7i36CwiSnbZEEu8trse9xnErpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255748; c=relaxed/simple;
	bh=1IF2XWPrp7XqJhRALUTRRRTJ3K84zi2HMXPzeqRr46c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kO29Q9Na1yEpk7WA3MgjrIqEeKPMWh0KYE67W8WbZHF3GN7Qkn1qbDWz30qwk9YHV5QXmfg4jei4okOZ5/pplVt6XYXbF0C+BkX4E/jApnmERxs8GbPnoi/oKGEOwR9Jo7BLHwwLFPFHe6ak97SZuu9ZyXRJ5Xz6alFv9UCuoBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H363d4XU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H363d4XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EDAC4CEF8;
	Thu, 27 Nov 2025 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255748;
	bh=1IF2XWPrp7XqJhRALUTRRRTJ3K84zi2HMXPzeqRr46c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H363d4XU32wPcHKz0yNHZ3YZOivG8pkxE8yVCRUgtc5PkPj6KaOgp9bcztqJZ7hVL
	 HufPVjjfgzFZ6GaotQDhHTpLCYwER596LSJyPvznMywafHTmK8joGO6eFspajhUZOK
	 scEb3Py8MlIwzIWY/Ear5111jajLGjYpyWuIaq0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 067/175] mptcp: do not fallback when OoO is present
Date: Thu, 27 Nov 2025 15:45:20 +0100
Message-ID: <20251127144045.414470862@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 1bba3f219c5e8c29e63afa3c1fc24f875ebec119 upstream.

In case of DSS corruption, the MPTCP protocol tries to avoid the subflow
reset if fallback is possible. Such corruptions happen in the receive
path; to ensure fallback is possible the stack additionally needs to
check for OoO data, otherwise the fallback will break the data stream.

Fixes: e32d262c89e2 ("mptcp: handle consistently DSS corruption")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/598
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-4-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -77,6 +77,13 @@ bool __mptcp_try_fallback(struct mptcp_s
 	if (__mptcp_check_fallback(msk))
 		return true;
 
+	/* The caller possibly is not holding the msk socket lock, but
+	 * in the fallback case only the current subflow is touching
+	 * the OoO queue.
+	 */
+	if (!RB_EMPTY_ROOT(&msk->out_of_order_queue))
+		return false;
+
 	spin_lock_bh(&msk->fallback_lock);
 	if (!msk->allow_infinite_fallback) {
 		spin_unlock_bh(&msk->fallback_lock);


