Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BE81D1E98;
	Wed,  2 Oct 2024 14:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878858; cv=none; b=cu7g13xOKe9TrYLlD4mfZsU9o+OABswUm2BqJQtm8eKJzIz2qOKOSWbH5OdTwwsFodhSkbbJ78KQ0dAdiPH5N+Wr06HrL0uLdWRgerjp3MyuUKuihPxC7RaHo7Qil0BB0jSOHrpiMA3LTRaQNnJQShI3ngjCInBzmmT0QgsaD/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878858; c=relaxed/simple;
	bh=rfRJnGAajvbk2RAYz3TwezmoWFwp7AX6iTv0veb01uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8TWckE+Dc49YLm8GvLvCaYeQBj/qJVXIh0RW1DIHaK4kqNioUP5BRWV8FjEPoUIb9yakI8kDT9DJFRvv02f9AqTFWj4XHyY/sUXcqSLQDiemstMsEx4+jEYb8TrbjOJ9/V+m6Rl3pmXNCR7xYNp8YVHKk6o8y+tQ2I5kUGLMLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ok9bq3o/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ok9bq3o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36810C4CEC5;
	Wed,  2 Oct 2024 14:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878858;
	bh=rfRJnGAajvbk2RAYz3TwezmoWFwp7AX6iTv0veb01uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ok9bq3o/PtwbuB24+pANauEM81wZUbCTMJeE1EAWyJjrWZnPEQuTyiIvoG5U+BJfk
	 HJalxUyCDA26+Dxm5W3yz0wtpSjhhZfbz/W9oEmGDlRrvwcfldHU4M/NgH1Rdx6Vpw
	 IJoi7A3AbTANF4dXArg0nq6Ceq5q4OfmP63hcb0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 539/634] drbd: Add NULL check for net_conf to prevent dereference in state validation
Date: Wed,  2 Oct 2024 15:00:39 +0200
Message-ID: <20241002125832.383658078@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Lobanov <m.lobanov@rosalinux.ru>

commit a5e61b50c9f44c5edb6e134ede6fee8806ffafa9 upstream.

If the net_conf pointer is NULL and the code attempts to access its
fields without a check, it will lead to a null pointer dereference.
Add a NULL check before dereferencing the pointer.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 44ed167da748 ("drbd: rcu_read_lock() and rcu_dereference() for tconn->net_conf")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Link: https://lore.kernel.org/r/20240909133740.84297-1-m.lobanov@rosalinux.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/drbd/drbd_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -876,7 +876,7 @@ is_valid_state(struct drbd_device *devic
 		  ns.disk == D_OUTDATED)
 		rv = SS_CONNECTED_OUTDATES;
 
-	else if ((ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
+	else if (nc && (ns.conn == C_VERIFY_S || ns.conn == C_VERIFY_T) &&
 		 (nc->verify_alg[0] == 0))
 		rv = SS_NO_VERIFY_ALG;
 


