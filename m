Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12291519B4;
	Wed,  5 Feb 2025 15:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768404; cv=none; b=r45blWNoizdEuOAUgxeD0smxRSDr1RYk3r8s/WJ2SMUDxevn4xSXe7Wwzz1PsB08c7mtBTZuu9L2j4a5A/1+snZZXswJbSslyE9JBqGSTdCUGfCcHDCzAr2DPyXpo6hyouYHUS9V6p0CRmsgrfBCZo8VEjFqJ4EZAhMu0bDb0FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768404; c=relaxed/simple;
	bh=How6NudmAZ/CyHaxwBDOUC+cWH58cR3FhKErF1YRdgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQmikKgtSvczCMbgA0M9awNKW0f3EQ6WMaOKWN9RSMIgv+WB6dmcEONn17MvCfO/tf95AcU6ujcCol8IRezE0P/bZQG5kH/HdyF4wZlwLkehV6Kv/VoXtjI9BiHX/Iz0PAeoCkSqSkSZXEse9IAWP+aBFHcSRTaz/9SQRhCzcEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NOKeRC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NOKeRC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2C0C4CED1;
	Wed,  5 Feb 2025 15:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768404;
	bh=How6NudmAZ/CyHaxwBDOUC+cWH58cR3FhKErF1YRdgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NOKeRC9B8qgJ3q4lbSUVtQkucoKh4fzwfUF96FWrAFwnumjb2gDPlSOcWw6cE6qd
	 Ms+RCnKDb+2RTgPKXwwPbgb9awkxQXCwfXdefrUbcE5fjnaOnUGBw58YNl3E+8wg0c
	 6CFsTPMJHo9E+wGi/2kw6nNYscSufDsTg2ApIuCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 545/623] vsock: Allow retrying on connect() failure
Date: Wed,  5 Feb 2025 14:44:47 +0100
Message-ID: <20250205134517.072368206@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit aa388c72113b7458127b709bdd7d3628af26e9b4 ]

sk_err is set when a (connectible) connect() fails. Effectively, this makes
an otherwise still healthy SS_UNCONNECTED socket impossible to use for any
subsequent connection attempts.

Clear sk_err upon trying to establish a connection.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Link: https://patch.msgid.link/20250128-vsock-transport-vs-autobind-v3-2-1cf57065b770@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index cfe18bc8fdbe7..075695173648d 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1523,6 +1523,11 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 		if (err < 0)
 			goto out;
 
+		/* sk_err might have been set as a result of an earlier
+		 * (failed) connect attempt.
+		 */
+		sk->sk_err = 0;
+
 		/* Mark sock as connecting and set the error code to in
 		 * progress in case this is a non-blocking connect.
 		 */
-- 
2.39.5



