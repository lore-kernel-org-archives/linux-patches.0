Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FAD1465A8;
	Tue, 25 Jun 2024 09:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308718; cv=none; b=rM+LMx0gwKZn5X2WIFL6+ZHrZqCxv+ScnhpE+X0dQhdfEb/p0hTKlgbyy2eGoC6Thu9wndD0VjEJkFj5Wrc93eSrPTvEP//XJRoehj8eiPxY9yPXrHYI5aVwOgtpSvdgJvDK7DskUOhy0/5+51o+jFKa9h/rRM6gsCBjduBTOfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308718; c=relaxed/simple;
	bh=kM2snx0QuGWc7q5HseWJ/jns7Yvc1lremqp0zrsFXLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3fTks+lehyouawtYENGqzfPIZu6OoBEJc1oPPwoNmer0qRbB2RRswOUEoETfuMjfUe97vUjVHqSDyIa+vKvRIrM/aRXCzCKm8kD7aSdKBgXfrPhSrrJ3XE62j5tSSEAmT4OKm6BQ+4lcTLnhFcpK8zXsk82AQidQN5oPMFC3p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6pMFSmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6pMFSmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8EEC32781;
	Tue, 25 Jun 2024 09:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308718;
	bh=kM2snx0QuGWc7q5HseWJ/jns7Yvc1lremqp0zrsFXLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6pMFSmXrpsrFw+uaIevhprdiPkDqtHLR0im3+ZccmG+Hj5vn0ihndhCqsAWXDkCv
	 BaPj3I61Dd0bofVSw9lBgIxVQgGAIemn9iCDas0iLMjGhy7IJzUWvn0oTqCgffjILu
	 SMweGT6GBv7z6JqjjQawUOwTWh8O/v5nIuroFXJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Dumazet <edumazet@google.com>
Subject: [PATCH 6.9 216/250] net/tcp_ao: Dont leak ao_info on error-path
Date: Tue, 25 Jun 2024 11:32:54 +0200
Message-ID: <20240625085556.344414413@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <0x7f454c46@gmail.com>

commit f9ae848904289ddb16c7c9e4553ed4c64300de49 upstream.

It seems I introduced it together with TCP_AO_CMDF_AO_REQUIRED, on
version 5 [1] of TCP-AO patches. Quite frustrative that having all these
selftests that I've written, running kmemtest & kcov was always in todo.

[1]: https://lore.kernel.org/netdev/20230215183335.800122-5-dima@arista.com/

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20240617072451.1403e1d2@kernel.org/
Fixes: 0aadc73995d0 ("net/tcp: Prevent TCP-MD5 with TCP-AO being set")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240619-tcp-ao-required-leak-v1-1-6408f3c94247@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ao.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 37c42b63ff99..09c0fa6756b7 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1968,8 +1968,10 @@ static int tcp_ao_info_cmd(struct sock *sk, unsigned short int family,
 		first = true;
 	}
 
-	if (cmd.ao_required && tcp_ao_required_verify(sk))
-		return -EKEYREJECTED;
+	if (cmd.ao_required && tcp_ao_required_verify(sk)) {
+		err = -EKEYREJECTED;
+		goto out;
+	}
 
 	/* For sockets in TCP_CLOSED it's possible set keys that aren't
 	 * matching the future peer (address/port/VRF/etc),
-- 
2.45.2



