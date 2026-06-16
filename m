Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6DA47A0C4;
	Tue, 16 Jun 2026 17:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632797; cv=none; b=Tf2vZ9/TpHBM4Iz/4qbhSHpov69IQLJ9UJYR8e13uWfvMYIi782b57ZbKmwJAaeU2O+7rH/SABuLctAwUPFyEtPDj5Q/VUtJ5A1RC+e5IOJm1hEwN0P/VvrtK0dI6ovYbTXcIQedoGhTysoXijI2ZbqJReJwY7mh4RTsIUMBkVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632797; c=relaxed/simple;
	bh=u30bAr68YazL4kksi/PvpaqEuJLcn8oGG2q4jY4McQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLs0AQ7bq5qjYfsSPHs5koJZs3kBh4qZJ+UUWYg+O5sW3+Zc6upy6JhnYGsydWehPY/IUl3CjNlCxy+1sMYj7b07xFkx3fK/YBctLwzSy6cJgxoctCo6Z+WVrUJj+4/6H149mcqYUPHfzbdu8FkXve1obUaY8YjQ4V6S8pP5RtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZ3y6Tga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZ3y6Tga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E641F000E9;
	Tue, 16 Jun 2026 17:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632796;
	bh=bnSLC+T69UoKQxQjPZrWDz93/RG34F42rjByou6ddUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZ3y6TgaY0T6iv8MS5UQjIwM+SZF5dWHF5XuqmotwVvL4NsxCtxmSKX+0sM5IZfBs
	 oMVuBTiSzmel4dgsqvHIAgDlq3+fnW1Of30fMnJPUXJybzu2/PbPxzOo4NQA4jzAG1
	 eMUCphNWGy4zGF1XRjPGR8Sgm55Nxi2woD98Auk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 445/522] mptcp: reset rcv wnd on disconnect
Date: Tue, 16 Jun 2026 20:29:52 +0530
Message-ID: <20260616145146.750284026@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 0981f90e1a05773a4c29c6e720f5ea1e3c8f1876 ]

If the MPTCP socket fallback to TCP before the MP handshake completion,
the IASN remain 0, and the rcv_wnd_sent field is not explicitly
initialized, just incremented over time with the data transfer.

At disconnect time such value is not cleared. If the next connection falls
back to TCP before the MP handshake completion, the data transfer will
keep incrementing the receive window end sequence starting from the last
value used in the previous connection: the announced window will be
unrelated from the actual receiver buffer size and likely too big.

Address the issue zeroing the field at disconnect time.

Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260515-net-mptcp-misc-fixes-7-1-rc4-v2-4-701e96419f2f@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3298,6 +3298,7 @@ static int mptcp_disconnect(struct sock
 	mptcp_pm_data_reset(msk);
 	mptcp_ca_reset(sk);
 	msk->fastclosing = 0;
+	atomic64_set(&msk->rcv_wnd_sent, 0);
 
 	WRITE_ONCE(sk->sk_shutdown, 0);
 	sk_error_report(sk);


