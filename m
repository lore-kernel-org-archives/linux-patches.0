Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4991CF5C6;
	Wed,  2 Oct 2024 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877062; cv=none; b=JTsR8sq2iVe7g0ovOfRley0ixYcn3t+wkVBJ7OpoT3HCuLyyKP4CQsAhNtUFpKjBWW83toXkvXaP+Oku11oH7H1ReVf4nPpspvLtzrqtlv+dtVjt1W6y6/Bfi/PvGe+hapjEK06m8zSAsZsJY1m8V+EDI2Nb3wsGR3h2zbbdg9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877062; c=relaxed/simple;
	bh=DY3nRYjgibTO2ilP0o/Bta3AlJqaf5jSR5lK4+n8qMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RS5c+/G+SsL2EMJ7rgBciBCLdOLPuilHaxeAZL2vYAQBfEOdckz1DZAyOq9KAbTXGFnHzbpXrhoK05IojPU0K66bfJfiQc+d5dP9VqIcJvFcaQ8EJu+v8Rmj0LFm4BIWUe3I2FDJhjaTdFTXpR/QUcgh2scEW7YhdzRqaNUVpSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYoxEgCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYoxEgCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8732C4CEC2;
	Wed,  2 Oct 2024 13:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877062;
	bh=DY3nRYjgibTO2ilP0o/Bta3AlJqaf5jSR5lK4+n8qMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYoxEgCJw+0knJ8IfrpKC+BSMvMk3PBkt80HFER4mkNNv8yiaMBMW0QnZG6TPWjNp
	 yl3sfXyly4HleYmAa/iGM8t97KBLytsLacLTWD6Tfcq7WAP0d9Oy4mfHI4tAK9GKZp
	 owPKMRZKWAfHT9e9tuR/W3YkNJ7m1BCmLX/uNL6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Karsten <mkarsten@uwaterloo.ca>,
	Joe Damato <jdamato@fastly.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.11 651/695] eventpoll: Annotate data-race of busy_poll_usecs
Date: Wed,  2 Oct 2024 15:00:49 +0200
Message-ID: <20241002125848.497838622@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Karsten <mkarsten@uwaterloo.ca>

commit b9ca079dd6b09e08863aa998edf5c47597806c05 upstream.

A struct eventpoll's busy_poll_usecs field can be modified via a user
ioctl at any time. All reads of this field should be annotated with
READ_ONCE.

Fixes: 85455c795c07 ("eventpoll: support busy poll per epoll instance")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Karsten <mkarsten@uwaterloo.ca>
Link: https://lore.kernel.org/r/20240806123301.167557-1-jdamato@fastly.com
Reviewed-by: Joe Damato <jdamato@fastly.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -420,7 +420,7 @@ static bool busy_loop_ep_timeout(unsigne
 
 static bool ep_busy_loop_on(struct eventpoll *ep)
 {
-	return !!ep->busy_poll_usecs || net_busy_loop_on();
+	return !!READ_ONCE(ep->busy_poll_usecs) || net_busy_loop_on();
 }
 
 static bool ep_busy_loop_end(void *p, unsigned long start_time)


