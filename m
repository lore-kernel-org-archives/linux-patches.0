Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F352471413;
	Tue, 21 Jul 2026 22:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672379; cv=none; b=VA+zYSjqUSZgmUlHRlGSlYSiqDYhBTPUPJB7elyBUcOKRUZ65xluBsFBzzEyupB1edCvTJYbmfj08pUr1q8PTPnLQ8aJknmXQkjwhVhzhznrUTIg0vwkN8rsXVZAIDF/WqZhbOSQApDJiRqpqpj7/FWgEEFJIf9yK7uG9E20Yds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672379; c=relaxed/simple;
	bh=yYTx4yvvJjSoMKUNA6oe8TGIjZf6YYYJr88gEfnl9Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqYy+1AlQ51mCIOkYtvPU1JVhRBHuaeaHS0prKQvMO2DEFsfOSY6lo5/yhM3lghHf+pFXPhshV7pfrt9mzCEvk3kgNf3dz3xvu+5+M3aIaLa6/KeL/b+Tu05/el+fgLLiOqm9wfovuXNKk5EQPPxRVKHxbj7Eq9kD/SNwzE1Zgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVxokFQe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVxokFQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04231F000E9;
	Tue, 21 Jul 2026 22:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672378;
	bh=VtoK+Vrnp5h7nEJoR7lyiQkVaN8fNjKVl7AQRVmjbYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVxokFQelzPl9Qrj6wMqpgoMaz+f1vnrwv4cpdFVXD0ssqvD/bYDJXmyOBuOcUWW7
	 X1ueJ9CqbKMHW6Sqh6ukhUbxyB41dDelJznV0gcC1EllQpUWMGwtkZAex6n5mXVIK8
	 hBi/YqydEAuPyLD6BEga0RGt0A+XaxbU8DEp2Ihw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 5.15 603/843] nvdimm/btt: Free arena sub-allocations on discover_arenas() error path
Date: Tue, 21 Jul 2026 17:23:58 +0200
Message-ID: <20260721152419.616811668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 13fe4cd9ddd0aacb7777812328be525a11ea3fea upstream.

Memory allocated by btt_freelist_init(), btt_rtt_init(), and
btt_maplocks_init() is not freed on some discover_arenas() error
paths. This leaks memory when arena discovery fails.

Add the missing kfree() calls to release the allocations before
returning an error.

[ as: commit message and log edits ]

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260519-nvdimmleaks-v1-1-592300fb7a43@cse.iitm.ac.in
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/btt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -924,6 +924,9 @@ static int discover_arenas(struct btt *b
 	return ret;
 
  out:
+	kfree(arena->freelist);
+	kfree(arena->rtt);
+	kfree(arena->map_locks);
 	kfree(arena);
 	free_arenas(btt);
  out_super:


