Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2D86FB1;
	Tue,  5 Dec 2023 03:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdAU+wBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44B3C433C7;
	Tue,  5 Dec 2023 03:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747454;
	bh=ckAc4kizIOiwaVBKu2Se9JfmL1Go4gGcvc30iMWvxxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdAU+wBfNDPLJ6advWh6GRn04VnNtKDwNTQ0xumOn5Be2RKNrCMqEkf2fisaRZTf1
	 Nc0BYtMPNN3cDz6oZzPlnokPM6Lvd7DXkjxsBwdmu13+xR5GmAAK0hALmcw83dD/nj
	 7scmkqjmckv9xiaAR0hr0a/5jSgrXGjPj8T0KNwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coly Li <colyli@suse.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 058/135] bcache: check return value from btree_node_alloc_replacement()
Date: Tue,  5 Dec 2023 12:16:19 +0900
Message-ID: <20231205031534.102278741@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Coly Li <colyli@suse.de>

commit 777967e7e9f6f5f3e153abffb562bffaf4430d26 upstream.

In btree_gc_rewrite_node(), pointer 'n' is not checked after it returns
from btree_gc_rewrite_node(). There is potential possibility that 'n' is
a non NULL ERR_PTR(), referencing such error code is not permitted in
following code. Therefore a return value checking is necessary after 'n'
is back from btree_node_alloc_replacement().

Signed-off-by: Coly Li <colyli@suse.de>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc:  <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231120052503.6122-3-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/btree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1506,6 +1506,8 @@ static int btree_gc_rewrite_node(struct
 		return 0;
 
 	n = btree_node_alloc_replacement(replace, NULL);
+	if (IS_ERR(n))
+		return 0;
 
 	/* recheck reserve after allocating replacement node */
 	if (btree_check_reserve(b, NULL)) {


