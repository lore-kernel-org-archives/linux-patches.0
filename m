Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F14D3D3326;
	Wed, 30 Sep 2026 19:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795857; cv=none; b=L9ot3cw0sEBVgst1rP4+w3hP/uOesnGZPja0GvLNiLAZG0kO2WV71zeH60J7w0E+lSctGw+e9pzaMbEUs3t7HB6opjz45a7aUXlpCcViIVoz120QCUyTfIwTdSzKXQ8d0TryOS34ySbd27s6iOE+k9x4lc31ujYD2FpX4hsBCAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795857; c=relaxed/simple;
	bh=nQLS6dmOX+wNRsWzSzNjgBPK3mmznbbz5Wo3prFpJOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a92QBmLRUYCrvDnaHWe9tqcNYjKXAu1Dr2V/RYXewGMug7hvtSTWSW8eKjb/sbJ9dm7/ussa+jpmEpDn1USUtUZQYHhA3kU75rgooux0WQLePx7uR4KOl7duRAe3wc/qcqu4F8aKujWOI8gnGyCScMQ5oJ2LDKM8jwAdUJaxUGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RF/KuC0E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RF/KuC0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8D91F000FF;
	Wed, 30 Sep 2026 19:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795856;
	bh=H7f5407weUq2MlR9HA+/2roFWJ5fZVzGwhGQHuPI1SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RF/KuC0EWZI6WXM1QbLprTBvTgreFN3K+0+bSLhlrsteqQ6R9a/M6U2+6Ayg1eYKA
	 KlIIwjMXdzw3Yd5cZBXiISLgvtsKz2kndPDFEbywNcQrGbH67EPZKsst0QZ2+AagLh
	 QopZNLT6up3pmh0di49jrpN2ni7193+O+bHc2duA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0706/1193] mptcp: fix bad accounting in __mptcp_subflow_push_pending()
Date: Wed, 30 Sep 2026 17:23:10 +0200
Message-ID: <20260930152449.935276327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit f3ef03357396d4b147d8e76c75fb612c2f264ffc upstream.

If __subflow_push_pending() errors out we should avoid updating the
copied byte counters, to avoid mismatch push call later on.

Fixes: 0fa1b3783a17 ("mptcp: use get_send wrapper")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260917-net-mptcp-misc-fixes-7-3-rc4-v2-3-0cf5c72667c8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1748,7 +1748,8 @@ static void __mptcp_subflow_push_pending
 			ret = __subflow_push_pending(sk, ssk, &info);
 			if (ret <= 0)
 				keep_pushing = false;
-			copied += ret;
+			else
+				copied += ret;
 		}
 
 		mptcp_for_each_subflow(msk, subflow) {


