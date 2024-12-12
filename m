Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D981B226529;
	Thu, 12 Dec 2024 16:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019909; cv=none; b=rNwC9rwKjeEqWI0Ogxwue2f8kG11MytUdg6M8OBS0QAYHkp04EJ/t2Gsp39X8O0bPGJxwDiCJjF6HEv/eWwHngPGLLH4QizPyMnIDf/0XMO0pAPpkkDoiv4v99yHkMSAmxbJzdmYq1e8yPcTl3kot82+JfsWLEKKv/41CMeTo58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019909; c=relaxed/simple;
	bh=DcWbna3D0VC8VAwXOdYn7UER6b65lecXKeKa1n1vEJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgKEEtTdluIRk7u8AkdlIvT5kRDlgujk+gzltUWm68YcW99kUJ1ndtiFusUeFNCoLetRzNycMXRqr4NHpHfb1m/U6zuhqqHOyN8bSU5G3ucpeMzI6qyDdlsRwYFM5Sxl6vuXp+aOIwK/LBWIyW989YpHDFElN+00UCO8hmhJ4d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSu3s883; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSu3s883"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB12C4CECE;
	Thu, 12 Dec 2024 16:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019909;
	bh=DcWbna3D0VC8VAwXOdYn7UER6b65lecXKeKa1n1vEJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSu3s883V1oONot4FSicSer9QaDX+KiiH41vA9EBuvfxnpBPNKa8YPPvmrLIGKy8B
	 Baba0aJDiMdPh/xWJfdyDRagc8A8O7oAF+bdPlXuBTyKhKXlJCx/5S9gAS+3fwwfn9
	 StZ/4Tr5Lb2sOq18np/QX6uy/4TmU+26fO8bmRTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Michal Luczaj <mhal@rbox.co>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 321/772] llc: Improve setsockopt() handling of malformed user input
Date: Thu, 12 Dec 2024 15:54:26 +0100
Message-ID: <20241212144403.161991861@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 1465036b10be4b8b00eb31c879e86de633ad74c1 ]

copy_from_sockptr() is used incorrectly: return value is the number of
bytes that could not be copied. Since it's deprecated, switch to
copy_safe_from_sockptr().

Note: Keeping the `optlen != sizeof(int)` check as copy_safe_from_sockptr()
by itself would also accept optlen > sizeof(int). Which would allow a more
lenient handling of inputs.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: David Wei <dw@davidwei.uk>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/llc/af_llc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 8e3be0009f609..447031c5eac4d 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -1099,7 +1099,7 @@ static int llc_ui_setsockopt(struct socket *sock, int level, int optname,
 	lock_sock(sk);
 	if (unlikely(level != SOL_LLC || optlen != sizeof(int)))
 		goto out;
-	rc = copy_from_sockptr(&opt, optval, sizeof(opt));
+	rc = copy_safe_from_sockptr(&opt, sizeof(opt), optval, optlen);
 	if (rc)
 		goto out;
 	rc = -EINVAL;
-- 
2.43.0



