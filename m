Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A582846D0A1;
	Tue, 21 Jul 2026 17:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655299; cv=none; b=LU4GYB5zOwASiCFhISpxqkHuH4n56hrobjMCNwNday1m4MYAdp+R8vaujWx7ThFOINa4pOcFiZRZemrcmZU9Ih6djIFbW8d8+uHVLFQYJ28Haycv6Myz26HTcdeqb9C3bJKjV0plNiNvM7GKlzXw6TwoB88qCPGWrtYHjV3iYZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655299; c=relaxed/simple;
	bh=yI7kYsCeraIgQPDfO7ys0JlJ+ROklhQThc2k5PW+u5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H028xDHqowMFZzcweWd2FIhLW++fQFrXMwvJSdSOeQxkXmw/Xna9JHZrhNhts4xwmxOFNdOo0IzRvpUc7MVIQIeBd5DKf/MaMHvBVDwNzBYYN22e1nXkLYm7eLvHf13yvKYfibPjErwywem48I6WSgxtgXWmBhA1gp4BAIUSwoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpnVBAqJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpnVBAqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1750C1F000E9;
	Tue, 21 Jul 2026 17:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655298;
	bh=LUVDyC+ljRBYAGA+fT/xkd7fNd1vBocYdFT4QmFmiXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpnVBAqJCTBT1MLZRUhkkrZqleD7u8+6b3uot0xPJQ/WHa5nL4Ne7vCcs2Tenforj
	 cbY+Serczjrdipr4YltA2MGjqEntSGKieA7NdqZULay3ItFzDNNNbDJximEDA+TusE
	 Ih/s676lSlKBgE8Nj+qyQnu8/L7BTW0eO/oWqEPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Crystal Wood <crwood@redhat.com>
Subject: [PATCH 7.1 1989/2077] tracing/osnoise: Call synchronize_rcu() when unregistering
Date: Tue, 21 Jul 2026 17:27:42 +0200
Message-ID: <20260721152639.625726447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Crystal Wood <crwood@redhat.com>

commit fe58f457ad8d0a2bef4e053cfecca4b5cd266b1a upstream.

This ensures that any RCU readers traversing the instance list
have finished, before releasing the reference on the tracer that
the instance points to.

Cc: stable@vger.kernel.org
Fixes: a6ed2aee54644 ("tracing: Switch to kvfree_rcu() API")
Link: https://patch.msgid.link/20260609045430.1589786-1-crwood@redhat.com
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Crystal Wood <crwood@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -162,7 +162,9 @@ static void osnoise_unregister_instance(
 	if (!found)
 		return;
 
-	kvfree_rcu_mightsleep(inst);
+	/* Do a full sync to ensure that tr remains valid, not just inst */
+	synchronize_rcu();
+	kvfree(inst);
 }
 
 /*


