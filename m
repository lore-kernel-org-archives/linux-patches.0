Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2C821B191;
	Sat, 30 May 2026 17:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163027; cv=none; b=a/YkS+k6KVegneNcra/g0kHNmNitvKEE4DL9WggAzq5TnPCN4hmbzMYyWTRnakSYl2z90kpYln6hL4hmEtFR9A/Ks4oaZMvtnJNLme23Q3ZcRrHNGxbqU/p2YDAY+X6xVBROEx/dBknLRZtSw+AeJFLPWyDfyyfQ3krvdtMvwnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163027; c=relaxed/simple;
	bh=UbX4B+EbSCXXQLpLpdFrvfJMMq3DP9Pd8jYV0dtFKyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qF7qt+AAlx48O/OGQXRQrq0D1sLwk/2nA9iwonr9jtyEgG4UCaoSXgiXjOMj1aLiIqHyencDomhm2yLxDx6/nQHF4lYfHmA9kFqXr0C31g2UsM6Vn0rPkcP2MzgydOTWJW5H6qvnzEWBz4hx1FVFBDvjEIU8JH++5dlGzlZZzyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/rIFaot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/rIFaot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747341F00893;
	Sat, 30 May 2026 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163026;
	bh=tmQc7zeNW/glCCOhzNcjgpc2Bt3YEskeVH/M52fvEWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/rIFaotl+RfbEXGaomaiH8BzyM90C2T9G8YmNIK6wHenS4JSeEH6/lMoRxfiiiqR
	 khGgnxXX/kv6f3ilj5rVl5XNs53uFuLiJTMJDY5emOd7Htc3ehfhktvYSs0dESEYEW
	 +aHpdRLH397hC5HhCOXISkIdhjvLgAc9t4c3Ygbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-kernel@vger.kernel.org, sashal@kernel.org,  Joonwon Kang" <joonwonkang@google.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Joonwon Kang <joonwonkang@google.com>
Subject: [PATCH 5.15 134/776] mailbox: Prevent out-of-bounds access in of_mbox_index_xlate()
Date: Sat, 30 May 2026 17:57:28 +0200
Message-ID: <20260530160243.866012566@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -468,12 +468,10 @@ static struct mbox_chan *
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


