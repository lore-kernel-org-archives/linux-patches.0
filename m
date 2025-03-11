Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A93C1C3BEB;
	Tue, 11 Mar 2025 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706237; cv=none; b=rd4lIiovCj/4smG8dKf2qhV5fI0ZOaQovJdCYnOXEvmBUm1bOqEuyCCpIxNsZlW7CSSm7cfvYlhUP7k/itVziuM2O4EmRG+Q6wirvUx393BrIkiDfmAI11nW09PMalmNIXJ8l2LGKd/qhyqSMkHUwe2mAt3U+eyhuwR0Uo71vg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706237; c=relaxed/simple;
	bh=GNLwTXT4kFEVzQ5TN+NQ+/XRxlYl33TvqYkddaUoA1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbT0gbTcnWeglsn2B87nfrDuB9mPfcnQgpoidW/1KXtLUz32lZNlmf6cq+S0lOJTkWTbuoRgabZQf2VQgqMM+7527EqVUrCBdKrMbk0XIw0pyNlzpj7Ukic73oKF42J9bUuqJNh7s7aRFKquwaMfnWniUBUfq0KIvOAUUAyISsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0hOkyTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0hOkyTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A4FC4CEE9;
	Tue, 11 Mar 2025 15:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706237;
	bh=GNLwTXT4kFEVzQ5TN+NQ+/XRxlYl33TvqYkddaUoA1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0hOkyTbe3XCKDBsDFe95V8ijudMlMqYbc8mSR3CctahPFh3ubRmgmEhfmdOw/7f2
	 16Hl3np0tBJXpBBlh1+eZ/fhpqkpgceMlNcManTrYD5wQ+D09EqpopAOWPWgU3J+ju
	 vxFxjDVyLp53LwCPUZjzbN2EiugD6X6fthTiY6tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 290/328] rapidio: add check for rio_add_net() in rio_scan_alloc_net()
Date: Tue, 11 Mar 2025 16:01:00 +0100
Message-ID: <20250311145726.437458509@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit e842f9a1edf306bf36fe2a4d847a0b0d458770de upstream.

The return value of rio_add_net() should be checked.  If it fails,
put_device() should be called to free the memory and give up the reference
initialized in rio_add_net().

Link: https://lkml.kernel.org/r/20250227041131.3680761-1-haoxiang_li2024@163.com
Fixes: e6b585ca6e81 ("rapidio: move net allocation into core code")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio-scan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -873,7 +873,10 @@ static struct rio_net *rio_scan_alloc_ne
 		dev_set_name(&net->dev, "rnet_%d", net->id);
 		net->dev.parent = &mport->dev;
 		net->dev.release = rio_scan_release_dev;
-		rio_add_net(net);
+		if (rio_add_net(net)) {
+			put_device(&net->dev);
+			net = NULL;
+		}
 	}
 
 	return net;


