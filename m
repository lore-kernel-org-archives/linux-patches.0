Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D9A344DB5;
	Thu, 12 Mar 2026 20:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346913; cv=none; b=uEq3bTJhswuBaSs3cnM03v0eSCySqFL3gmsbMoy7yJGkuow6o7PjiQnOGsIAzwob208JVibdjhahbiH0P7qYCiRw8v28WdPaX5lOmIT8U7/Cf6YwmpvCybtsJxosdMdlwx7asDjYqLCc/1j3/45gmilVx3z7XfeiGYOF/I+899Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346913; c=relaxed/simple;
	bh=Ai/t0Bv/oNdPYeTBnbqy4VGSiCGlAZWcvnWf/CeYrNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3p0t6WiywAj5lcrSB8EQNgmmo8h9uG+/X06RE9xYEKRJBNc7QVpj8Hz+Yy78CsX7a1ma2fY/gq1ShVce19aJIcA+Gr/zqnbQLFbhSL8YKzU46ADjRn2yKfumDRA1/KhyyBjIFeLk1oLv89u5C/gTEMxr1Nb65niH2Ljyy+Wa1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skgwVr32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skgwVr32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17406C4CEF7;
	Thu, 12 Mar 2026 20:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346913;
	bh=Ai/t0Bv/oNdPYeTBnbqy4VGSiCGlAZWcvnWf/CeYrNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skgwVr32rV6NbPkB0NNjruzMqPW/+yY7oH3yfnuGHo15Vv0pgIftM7fSwhTGxabLr
	 fadXlVf+Qn2la/AUXE7EsraE9oQwRTYbOear/aOdxJIySrqE4Nv3gmwDxquVmd/7ie
	 YASEzUGXqaOAskU3xAqZpS5U84jn69g4sfircXik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 126/265] eventpoll: Fix integer overflow in ep_loop_check_proc()
Date: Thu, 12 Mar 2026 21:08:33 +0100
Message-ID: <20260312201022.801155269@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit fdcfce93073d990ed4b71752e31ad1c1d6e9d58b upstream.

If a recursive call to ep_loop_check_proc() hits the `result = INT_MAX`,
an integer overflow will occur in the calling ep_loop_check_proc() at
`result = max(result, ep_loop_check_proc(ep_tovisit, depth + 1) + 1)`,
breaking the recursion depth check.

Fix it by using a different placeholder value that can't lead to an
overflow.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: f2e467a48287 ("eventpoll: Fix semi-unbounded recursion")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://patch.msgid.link/20260223-epoll-int-overflow-v1-1-452f35132224@google.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2012,7 +2012,8 @@ static int ep_poll(struct eventpoll *ep,
  * @ep: the &struct eventpoll to be currently checked.
  * @depth: Current depth of the path being checked.
  *
- * Return: depth of the subtree, or INT_MAX if we found a loop or went too deep.
+ * Return: depth of the subtree, or a value bigger than EP_MAX_NESTS if we found
+ * a loop or went too deep.
  */
 static int ep_loop_check_proc(struct eventpoll *ep, int depth)
 {
@@ -2031,7 +2032,7 @@ static int ep_loop_check_proc(struct eve
 			struct eventpoll *ep_tovisit;
 			ep_tovisit = epi->ffd.file->private_data;
 			if (ep_tovisit == inserting_into || depth > EP_MAX_NESTS)
-				result = INT_MAX;
+				result = EP_MAX_NESTS+1;
 			else
 				result = max(result, ep_loop_check_proc(ep_tovisit, depth + 1) + 1);
 			if (result > EP_MAX_NESTS)


