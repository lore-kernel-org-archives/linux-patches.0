Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1357A221710;
	Thu, 13 Feb 2025 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458305; cv=none; b=vCOgIeJnoO1HTehkH+8c1EU4u+c4aOaOXpHSPVbYDs4mWWPKqt+u9cZUAR1SN8Qofk3LAivE3r0lenRx1qRVybMMgBIvHhOmUT3NdDVBxc+yVWlx8jktj6P/mrqoPLZMXTWIDc9dKXTud6ZoqEq8zJGX02wZMzS6aicdJFrfzqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458305; c=relaxed/simple;
	bh=88niFh5+YPUIlzKdGRBn2tmw1HL0km4+K9rBJdHNH1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+i50GNVahokKg4f7v8NOrtAR1OMX3l6IrkBxaiRlNuC7qraGgW/2I6GauofHe+bWXNnn6efApuKONKWroa7ukFl5Fv6Azhu53BJ1OlK4eDZg3GhQVAO0Vp6S9afN/zZUSDAjqF7nKvYdmNtT7DTwtNVoIj91Cj/Ix/5j/f80u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8vFkaIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8vFkaIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B7EC4CED1;
	Thu, 13 Feb 2025 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458304;
	bh=88niFh5+YPUIlzKdGRBn2tmw1HL0km4+K9rBJdHNH1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8vFkaItd0hDEaFx6RYynwhQ1n73lHyKO2sOSPfVb77VU26JZqafmLL6Kg35jCnOV
	 VNB9Me8KHy1TaVzxPKn9Km+5bsp3PECqgwhe+0jXvgl0S6N7m4iOKhssv/0PljgOdj
	 +kJs4Ni48IqQMiJvp+pheRlQiqXcz6Af/M9BRpHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 360/422] selftests: mptcp: connect: -f: no reconnect
Date: Thu, 13 Feb 2025 15:28:29 +0100
Message-ID: <20250213142450.443681183@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 5368a67307b3b2c347dc8965ac55b888be665934 upstream.

The '-f' parameter is there to force the kernel to emit MPTCP FASTCLOSE
by closing the connection with unread bytes in the receive queue.

The xdisconnect() helper was used to stop the connection, but it does
more than that: it will shut it down, then wait before reconnecting to
the same address. This causes the mptcp_join's "fastclose test" to fail
all the time.

This failure is due to a recent change, with commit 218cc166321f
("selftests: mptcp: avoid spurious errors on disconnect"), but that went
unnoticed because the test is currently ignored. The recent modification
only shown an existing issue: xdisconnect() doesn't need to be used
here, only the shutdown() part is needed.

Fixes: 6bf41020b72b ("selftests: mptcp: update and extend fastclose test-cases")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250204-net-mptcp-sft-conn-f-v1-1-6b470c72fffa@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1302,7 +1302,7 @@ again:
 		return ret;
 
 	if (cfg_truncate > 0) {
-		xdisconnect(fd);
+		shutdown(fd, SHUT_WR);
 	} else if (--cfg_repeat > 0) {
 		xdisconnect(fd);
 


