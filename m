Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BDA2C1594;
	Mon, 17 Aug 2026 14:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975484; cv=none; b=OTMK2Fcia2bvF4nz4nppaw3PNe2u1NxzLwuY5TtoYvdgyJHykuhpDcfjmOusDoxoppQk8OciTu2PCUst8ot0pyxgsFH2m5AN5ZoASUQj1xjZSsfiJWQqSI7eLvpo7/2yPZvEBTyb/PbZvo436U/TKKa4NFKFX3yrZHqMuSi0VqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975484; c=relaxed/simple;
	bh=qSWvQ7dpAu6TZwomEIzAtGvjmFehRYhMIES6SJeffKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0bg9ReyqBt9W5aytQFRZiUhx1MtaGDb265EAA02opceG1SMOc2fkMWqhp5VD4vlycyhfeP7dLEcKT5HymQjwdhUbs/NYNY9uWLcKMa8cLMWEi3BJA7a1QjGpUWCN2sKHWKiloES4W4bFWzj2zQEjeHBcX/Wm9vWFonbtJSqcYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXNELvRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXNELvRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995881F000E9;
	Mon, 17 Aug 2026 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975482;
	bh=dh7qRSnlUmuXYpGYIm6JjMm7iKqLPLg5t0wGdZbOFak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXNELvREQfuJzwxKBCgjq3dWCxZfBRhUeaf6KfEulwrA6+Z93tZ3G8+76b5QWHCaM
	 cAmQKXQIQEfqb+eKyx7BB3ErRDrfNxbfxKLCg6dKA2y5fVaSgO5DoERPMa/yJRggOT
	 GaGMIdPcqkrwy6KfUhKgjx3tIHImRrRzFgfgI5kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <dstsmallbird@foxmail.com>,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/389] sctp: fix auth_hmacs array size in struct sctp_cookie
Date: Mon, 17 Aug 2026 15:28:02 +0200
Message-ID: <20260817132540.683437267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit e0b5252a59383b77d1b8dbeda00b7184dd95f4d3 ]

The auth_hmacs array in struct sctp_cookie is supposed to store a complete
SCTP_AUTH_HMAC_ALGO parameter, which consists of a struct sctp_paramhdr
followed by N HMAC identifiers.

However, the array size was calculated using an extra 2 bytes instead of
sizeof(struct sctp_paramhdr), which is 4 bytes. When four HMAC identifiers
are configured, the HMAC-ALGO parameter stored in the endpoint is larger
than the auth_hmacs buffer in the cookie.

As a result, sctp_association_init() copies beyond the end of auth_hmacs
when initializing the association, corrupting the adjacent auth_chunks
field. This can lead to an invalid HMAC identifier being accepted and later
cause an out-of-bounds read in sctp_auth_get_hmac().

Fix the array size calculation by including the full SCTP parameter header
size.

Fixes: 1f485649f529 ("[SCTP]: Implement SCTP-AUTH internals")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <dstsmallbird@foxmail.com>
Reported-by: Zihan Xi <xizh2024@lzu.edu.cn>
Reported-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/634a0de0d5de29532915e6d47c92a0cbc206e03f.1783707155.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/structs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 8d058b50f1386b..85ed2b59ffe71d 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -318,7 +318,8 @@ struct sctp_cookie {
 
 	__u8 auth_random[sizeof(struct sctp_paramhdr) +
 			 SCTP_AUTH_RANDOM_LENGTH];
-	__u8 auth_hmacs[SCTP_AUTH_NUM_HMACS * sizeof(__u16) + 2];
+	__u8 auth_hmacs[sizeof(struct sctp_paramhdr) +
+			SCTP_AUTH_NUM_HMACS * sizeof(__u16)];
 	__u8 auth_chunks[sizeof(struct sctp_paramhdr) + SCTP_AUTH_MAX_CHUNKS];
 
 	/* This is a shim for my peer's INIT packet, followed by
-- 
2.53.0



