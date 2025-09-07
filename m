Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F085F1A0BFD;
	Sun,  7 Sep 2025 20:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277214; cv=none; b=HVaf4aOpEtOuM4h/w6LOtTAWDWYnMMovByk2sziqNx353GSHCnEGoF1m7rbJ7alFWctuHiOORYO8/hPOyJ3Xxi+R1VksK+DoW3YINxehhpgi6JifaRNNuc+RGs/SBgvT5gG1v2RkF6f+KmMLTmij5/6flhbVctuZZTio/tkaWDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277214; c=relaxed/simple;
	bh=wrFCrBoYG6pryKCORuPjJRLfkdlQaRNMoeBvaHfHA5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iv48D9gQScNl48ru2IolCGN7CK7usx3WNxRwA8VWAPZ/dRMhLTOs9zOeYigv9s1iohhvpCQZIXkpgTcJ37+cC83r42eriw2WGMRtqdZT/IL9seVgYl0CXo+zr750+afnWg2EBpHXplSluGZmlWNhl1POH/hlVMCU+kwxzDtqfw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fny99jMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fny99jMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700C9C4CEF0;
	Sun,  7 Sep 2025 20:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277213;
	bh=wrFCrBoYG6pryKCORuPjJRLfkdlQaRNMoeBvaHfHA5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fny99jMj9TlkCc7O1lAHZ12UZZqDmZrvfB4UmBuyCybo+dK5wXyQ4N3zNSLbtSSCX
	 pUa8k00/U8oRYDwUjsyoY6KVIJGjWCRnJHfq+L3amUzPQwUXB1fW2NtrlF77W1mqYh
	 aCxQULHG03SOJaB3ZAyxAZoRDMP51n4+nTaaYLZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/175] mctp: return -ENOPROTOOPT for unknown getsockopt options
Date: Sun,  7 Sep 2025 21:57:59 +0200
Message-ID: <20250907195616.824062477@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit a125c8fb9ddbcb0602103a50727a476fd30dec01 ]

In mctp_getsockopt(), unrecognized options currently return -EINVAL.
In contrast, mctp_setsockopt() returns -ENOPROTOOPT for unknown
options.

Update mctp_getsockopt() to also return -ENOPROTOOPT for unknown
options. This aligns the behavior of getsockopt() and setsockopt(),
and matches the standard kernel socket API convention for handling
unsupported options.

Fixes: 99ce45d5e7db ("mctp: Implement extended addressing")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250902102059.1370008-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/af_mctp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 70aeebfc4182e..9a552569143bb 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -346,7 +346,7 @@ static int mctp_getsockopt(struct socket *sock, int level, int optname,
 		return 0;
 	}
 
-	return -EINVAL;
+	return -ENOPROTOOPT;
 }
 
 /* helpers for reading/writing the tag ioc, handling compatibility across the
-- 
2.50.1



