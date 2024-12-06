Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F713207E19;
	Fri,  6 Dec 2024 15:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497987; cv=none; b=Yrp7kGUNc6IEiY/YZbjQFSPs+acqfi+RCt4rrPUdNCelBgSai+w/PeCpVF0K2RoKnrKZi+4y9fTW2nQo8sE1OZaQHMPMnGCUl7CCv5aq52UXns+XYPRfL+6qtPJD7Gh9F/oA57wOW7lmEOIyuy9h90KCEL0LA34qX4uh3W/zdVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497987; c=relaxed/simple;
	bh=ugZ0gHhv8NweBhHcLgrIbCOpj/Mg4p68pjsnfrQfeIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uv2hQ6VIFEb2UtXwD136qJg8eNTkb09QPYAyuA50HZwNvsKhYifH0wBBXD6L7nbs/sYwpqX4C99tPqGJBHzjD+iF8x0ebteLbqza0nQx90qB3G8AnEOinv45ceVSRVzGk5CNTqOzz6iMDv+ds8PkThN1gJtr+rgnYqtmEz/mzXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7OBzL4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7OBzL4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52FBC4CED1;
	Fri,  6 Dec 2024 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497987;
	bh=ugZ0gHhv8NweBhHcLgrIbCOpj/Mg4p68pjsnfrQfeIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7OBzL4MhMFvEo4Zt2Xl4wy9r6cOcTZzWruXpLhpAZ95H6XHvr/yOxxcqXUOflTBA
	 QeZnux+5U/Qz2MnnQPS9GIuqRdHX9Xai7mVRahCdexr4qHLTVwhQ4HXaXb+ew9bqF4
	 ot6/6nvS4BNHn775Dd+jtzqrxAf0ZMLTgSTMwcoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Michal Luczaj <mhal@rbox.co>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 421/676] llc: Improve setsockopt() handling of malformed user input
Date: Fri,  6 Dec 2024 15:34:00 +0100
Message-ID: <20241206143709.791711803@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fde1140d899ef..cc25fec44f850 100644
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



