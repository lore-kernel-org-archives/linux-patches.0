Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389603B38A4;
	Mon, 23 Mar 2026 16:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283213; cv=none; b=bP7KKx+lXrW7FqA6KIVWe5BWeLfRlnrtaQvYCAbOXjgEh6p5TKzgHd1Uu3YH4PjB6TuxfeTzbH6+BveeT+AIhPGW5VIKUgF4mRSe/YVsk0B5rh7XbhO+FFo32Ah6YVO/5PyuVqpqjRTFi9bQhbehAPUTmUmsKVNA4daPg/jDEmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283213; c=relaxed/simple;
	bh=JG30R03fY80P14Zx/2LrxZidCgWZ8h9EXjdJsnBYeHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ou3phhDz4mbqLe6vnyDnCnQNPUyOi++QGvjXrTFa5KXpkAqe4i0bP1ygWrk07xIaFzdlhZUV9k6Yk2HGVa1NjUDyvy3aJLyqJuu2HeArpgDRfp0+bjw56bxF6fO3ZgC38oqZzK03MeiGmQ+d9aRB+jndOTBZJTzrYqGW4Hv+VPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htS4+GFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htS4+GFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C99C4CEF7;
	Mon, 23 Mar 2026 16:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283213;
	bh=JG30R03fY80P14Zx/2LrxZidCgWZ8h9EXjdJsnBYeHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htS4+GFjKRuVJnDtmBq3jYsL0rskUIYBUal0Fg7PyqRfNgZzBZMwMvlSSGSGFWGVQ
	 nJ4v43AKn5yCdr6lPXvQ+UES5K0giM/tZ2RLErAb9j5ofk1pNSiqmzEBeRkPTPCBiN
	 +0ZKgCuT3+NLsbS+nRZhg9K+GzzK5MDZARTCZwcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-kernel@vger.kernel.org, sashal@kernel.org,  Joonwon Kang" <joonwonkang@google.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Joonwon Kang <joonwonkang@google.com>
Subject: [PATCH 6.1 444/481] mailbox: Prevent out-of-bounds access in of_mbox_index_xlate()
Date: Mon, 23 Mar 2026 14:47:06 +0100
Message-ID: <20260323134536.034942422@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonwon Kang <joonwonkang@google.com>

[ Upstream commit fcd7f96c783626c07ee3ed75fa3739a8a2052310 ]

Although it is guided that `#mbox-cells` must be at least 1, there are
many instances of `#mbox-cells = <0>;` in the device tree. If that is
the case and the corresponding mailbox controller does not provide
`fw_xlate` and of_xlate` function pointers, `of_mbox_index_xlate()` will
be used by default and out-of-bounds accesses could occur due to lack of
bounds check in that function.

Cc: stable@vger.kernel.org
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
[ changed sp->nargs to sp->args_count in the code and
fw_mbox_index_xlate() to of_mbox_index_xlate() in the commit message. ]
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/mailbox.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -508,12 +508,10 @@ static struct mbox_chan *
 of_mbox_index_xlate(struct mbox_controller *mbox,
 		    const struct of_phandle_args *sp)
 {
-	int ind = sp->args[0];
-
-	if (ind >= mbox->num_chans)
+	if (sp->args_count < 1 || sp->args[0] >= mbox->num_chans)
 		return ERR_PTR(-EINVAL);
 
-	return &mbox->chans[ind];
+	return &mbox->chans[sp->args[0]];
 }
 
 /**


