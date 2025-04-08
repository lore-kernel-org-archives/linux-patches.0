Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814DD269894;
	Tue,  8 Apr 2025 10:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109864; cv=none; b=iiAuN4oOTXKa+jYG7fXNNdFzm4fh4JQusyLh+i0deDHOIblXuZbu/JK4PXQ1y1nsLYSSBufnh8m4trz4D/EhOlnK/WeoTpFf8r7vA98DyS7c/Dsic+XmAukEcnSiSXeYMN0E4bKqaeQaWMNu4jWc0XgkDFZ1EG3DKzHbIJqPS84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109864; c=relaxed/simple;
	bh=bH5iIdobNNUDFIvXeNOMJM6WmN/vkFFiEvQAdPmSmuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3WxjULajtpgADZsZp7pqRn5PrhQPpBy0N5ke4sbp3YD0j9u7x7YaqKmKi7lul2frZ4nXV76u6sGNmG5pQyCeZNT6v7ZecQaWlj9GluGQj9UODSRUOdZuDaXyzEfam27qaIk0v+TgYIRilQRGn5EDObzGd4ihvg25tUj/g3RCjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqlfa6dN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqlfa6dN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA14C4CEE5;
	Tue,  8 Apr 2025 10:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109864;
	bh=bH5iIdobNNUDFIvXeNOMJM6WmN/vkFFiEvQAdPmSmuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqlfa6dN+smntDZ5ai1RtKgPSF0cw/eCrK5MfOidDvcYvK97xbwNErMvMFq7v/5go
	 2aolFabMNeOZPwWlPVtwXnYpH4LaUECweswfB7CUSvUjo98iQFKry4i6D6KHPM6YbL
	 dqdChT2vSfaYJOXaXY/HWO09ua/csAFndggIQMiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/227] mptcp: safety check before fallback
Date: Tue,  8 Apr 2025 12:47:02 +0200
Message-ID: <20250408104821.722442509@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit db75a16813aabae3b78c06b1b99f5e314c1f55d3 ]

Recently, some fallback have been initiated, while the connection was
not supposed to fallback.

Add a safety check with a warning to detect when an wrong attempt to
fallback is being done. This should help detecting any future issues
quicker.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250224-net-mptcp-misc-fixes-v1-3-f550f636b435@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 2330140d6b1cc..f5aeb3061408a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -530,6 +530,8 @@ static inline void __mptcp_do_fallback(struct mptcp_sock *msk)
 		pr_debug("TCP fallback already done (msk=%p)\n", msk);
 		return;
 	}
+	if (WARN_ON_ONCE(!READ_ONCE(msk->allow_infinite_fallback)))
+		return;
 	set_bit(MPTCP_FALLBACK_DONE, &msk->flags);
 }
 
-- 
2.39.5



