Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40584F4D0A;
	Tue, 13 Oct 2026 12:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895887; cv=none; b=IC4NNdLRpYrppK/b1X+d01SVPgJsr/oylsfybncldaV5SON3o37IVNeNCbUVJF7m4lpaeABNEtXKsUJiyD3M267zuWLUQF1QlhFu9KRNvZcx9Q/ZpA4otWAYBZDzhEI7F7dMfmYnKE8iD9REmcl21ckhG5IjxDZG9kNCMzSb6lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895887; c=relaxed/simple;
	bh=HKJXs9Qk1wW+QqeOHm5hIa+ocX9TB7S01PO5rcSRml4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/pqSk8LA3luJmkHb7MKi5PZe5gWnF76U3mPxz0fzWO4J9cqEEB/NQCIHq2BSOfxlmU/YcDN6qnE9kPgkyH1BRg5F8yyCsBQbmk4DIZ9G54JU//Nw0fkHVd4IO/rspR9YgbIH6vDXxNvqeFjQwOq1ib3ZDjbRxxKDoMjlo1GUPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=penhFU16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="penhFU16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDCF1F000FF;
	Tue, 13 Oct 2026 12:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895886;
	bh=m60IGOoMB4kq1garOP2RGF7BWxx58CctEVkfKYpvqW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=penhFU16I5DIkJjfx5L7qRuldMXeyiCZg9T8JFxCsxCcf32tGfzJ6engBB3vw4kxD
	 5PJQwuZyunlImDn/DNRtK+qWeC4YIpjx3JJ79HVaXcn75T1FRv4b8+/XywwLZ+Qcda
	 x92Z0K8nHjK2cJPoHhiDXYWAzIzbgqK9VjAZ6dkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 6.12 427/497] drm/gud: dont keep a connector without a CRTC as connector_state
Date: Tue, 13 Oct 2026 13:39:54 +0200
Message-ID: <20261013112918.021819765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Sajal Gupta <sajal2005gupta@gmail.com>

commit 71ec70ea26e399eb8371fe9d2d5bf5dab09570fb upstream.

If the 'for_each_new_connector_in_state()' loop finishes without
hitting the break, connector_state is left pointing at the last
connector visited, which has no CRTC, instead of
staying NULL.

That skips the "if (!connector_state)" fallback below the loop, which
looks up the active connector when the state contains none. The
function then carries on with a connector that is not driven.

Fix by resetting connector_state to NULL for each connector visited that
has no CRTC, so that it is NULL when none was found and the fallback runs.

Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260902123254.36987-1-sajal2005gupta@gmail.com?part=1
Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
Acked-by: Ruben Wauters <rubenru09@aol.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260922084026.15481-1-sajal2005gupta@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_pipe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -486,6 +486,7 @@ int gud_pipe_check(struct drm_simple_dis
 	for_each_new_connector_in_state(state, connector, connector_state, i) {
 		if (connector_state->crtc)
 			break;
+		connector_state = NULL;
 	}
 
 	/*


