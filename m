Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45191A9B46;
	Mon, 13 Oct 2025 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368743; cv=none; b=Q6knH4ZmDcZ7QHbKepfzvOs6Z8Rx0E2VejgkRoA38WUSIZgtl3BYIyEZHJeT9ttvPwHZUktUydHq6pH1ViOyLdUnn3XxUIzYwSotuGYDe4Vnl70Q36k7DoWkDr6uz5h4oK3BLUCGkNJEtd0QXbfKcnWyhEFdzUz4BZBwMVRlt+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368743; c=relaxed/simple;
	bh=je06jWST3nUjqb9QTTaoW4abR2Asd5vf0MxWv/DSTH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HftZEkDZMUYYk6iuzyIpZiZSzCeDGr3qcP++qSr+1VrJ39cYtKT6RZhO+koir4G01gyj+RfWKI9d+1nNWkCdGeu81KPaJPF6RC9S3C7HSA8cudWZyYRNoC4yeDodFtOeTj8UV2YJ7pkpZYumOL9GEG6cLmOak1Hz5QDdh62h0OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+wO4+HU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+wO4+HU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602D9C4CEE7;
	Mon, 13 Oct 2025 15:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368743;
	bh=je06jWST3nUjqb9QTTaoW4abR2Asd5vf0MxWv/DSTH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+wO4+HUSiQ2xH2Mkx7ZFiz3/j/qVJ28Am4oM5M5xnSTdIiLK7Bj7o0S4t30gaMLk
	 ZAai/OhKdBC8Mqu9lL6/EcY+ponIz3cibS4I6lEkJ2fHH7qVhCkv8UWX7SuMJhvxtl
	 EvPSuEU/9ZQWKWWJnXKzFJVdPAIInsroSjE9g5nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Lei Lu <llfamsec@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 253/262] sunrpc: fix null pointer dereference on zero-length checksum
Date: Mon, 13 Oct 2025 16:46:35 +0200
Message-ID: <20251013144335.347280381@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Lu <llfamsec@gmail.com>

commit 6df164e29bd4e6505c5a2e0e5f1e1f6957a16a42 upstream.

In xdr_stream_decode_opaque_auth(), zero-length checksum.len causes
checksum.data to be set to NULL. This triggers a NPD when accessing
checksum.data in gss_krb5_verify_mic_v2(). This patch ensures that
the value of checksum.len is not less than XDR_UNIT.

Fixes: 0653028e8f1c ("SUNRPC: Convert gss_verify_header() to use xdr_stream")
Cc: stable@kernel.org
Signed-off-by: Lei Lu <llfamsec@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -724,7 +724,7 @@ svcauth_gss_verify_header(struct svc_rqs
 		rqstp->rq_auth_stat = rpc_autherr_badverf;
 		return SVC_DENIED;
 	}
-	if (flavor != RPC_AUTH_GSS) {
+	if (flavor != RPC_AUTH_GSS || checksum.len < XDR_UNIT) {
 		rqstp->rq_auth_stat = rpc_autherr_badverf;
 		return SVC_DENIED;
 	}


