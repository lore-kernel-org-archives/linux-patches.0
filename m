Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5E82397B6;
	Thu, 12 Dec 2024 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020645; cv=none; b=kFuTj/NBoMX05pILMYtExUW/zkLcG/kfA+zqN5AEOVqhQemAhnLsV8I7wTwOFBRdV5afJax4xV9lWzmodSAkZz6oKKdESsIHmjTCO41UrRkosRxP0ypmnuhf+3FnN4hUxvcSee/94ZUWCIeyte/uGBdz1jlUYmhig0qvSUyDiBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020645; c=relaxed/simple;
	bh=/9qnkpbRaXj7E/n0SYvhJGh5NfMmsZsbsMCFyLG0wt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1UYbksnfhTAITcRr+EmapvEIiy6+O12aHkQfony3buZcfK5rKghSK6F75+HFVuDsamP8R2e1imDryn7AXpl9jgNJ5r14jNscRhSUR76CaR1vQ84G6SI9r9P+eyrXRz1qIh2TR/wWpgFoAC1yMIuE3LKIC1BR6wwMfY5MvCMdcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHtMulbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHtMulbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87FEC4CECE;
	Thu, 12 Dec 2024 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020645;
	bh=/9qnkpbRaXj7E/n0SYvhJGh5NfMmsZsbsMCFyLG0wt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHtMulbgBmJRPbWDqDdOG1tpjmjxVM7YNMhvB1KUB48BVr5/pwYm7DHYmQfSot5AB
	 tJooFPWs4WyocEu+Q52plU72GxQ2l9GZuyZvoW9+4AkwJ2jBeWm663nFOJtK4b1awu
	 5gMqwFvAg+8epR0pNP4iyjwGXWiCBMD/olp2cx2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 493/772] dm thin: Add missing destroy_work_on_stack()
Date: Thu, 12 Dec 2024 15:57:18 +0100
Message-ID: <20241212144410.324011728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

commit e74fa2447bf9ed03d085b6d91f0256cc1b53f1a8 upstream.

This commit add missed destroy_work_on_stack() operations for pw->worker in
pool_work_wait().

Fixes: e7a3e871d895 ("dm thin: cleanup noflush_work to use a proper completion")
Cc: stable@vger.kernel.org
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2457,6 +2457,7 @@ static void pool_work_wait(struct pool_w
 	init_completion(&pw->complete);
 	queue_work(pool->wq, &pw->worker);
 	wait_for_completion(&pw->complete);
+	destroy_work_on_stack(&pw->worker);
 }
 
 /*----------------------------------------------------------------*/


