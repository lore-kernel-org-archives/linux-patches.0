Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE95184;
	Tue, 13 Oct 2026 12:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895047; cv=none; b=lCxNhaEGIVZwNdPjrx6JCM3cWu0qpDP0RjZbKZ2fExROJK3HH7AzVhjBvI/9z436o8X5AU9SIwO6oAbDVI3jmOEGpmBIoxeApYJoN4/DSQNvYRUtqwLVDdMMOSsCTRAkNxKb03cnHcOu8lofaPtNqEOR4eLKoLvnb6R6zSKQZIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895047; c=relaxed/simple;
	bh=s2lN3J9AXmOPVzYAjP59N5A/Lj7ykDImOMjY4frpMVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yt6s0cSmr+q2EUgkHsmmlBAeeT1lrqGnGebTwzVcyWEEq2gtE4IbOb7l225cGphMEVZpzjS/+opNRzZ+vqI7LZN2Q4VjGMs035L5FIfSOtyjcQe+LYQmgS97vOdW+/1NQ5tyLqBNp9Igj6k8JrJnbeg+rhg4v5/rZEeJtIbJZys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIr24WKC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIr24WKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F25B1F000FF;
	Tue, 13 Oct 2026 12:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895045;
	bh=iUxavweJYM+rEZHDjQp8qiFQ1k88XEhpyEsRpt2/Kf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIr24WKCyytMg9ZTvJti23V54HErwuzjKZ0n0lvCDCKOtO7pjZt76y3EzU1PdINBF
	 4KSY4mcYUE5vOjQgW9gbjJlmCBMdrNMDxAH83NJC5ak1+gXtMLt11zUVEoOWEn5fH/
	 nF1XruwlFCAsYQI1iADwQaa3ZuPJ8ttpECd/hC3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 144/497] usb: typec: anx7411 - stop the IRQ before destroying the workqueue
Date: Tue, 13 Oct 2026 13:35:11 +0200
Message-ID: <20261013112911.305489395@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 469600d5d292b1482c90dd6853555821d11b8c5f upstream.

The IRQ is devm-managed, so it can still queue plat->work while
remove() is tearing the queue down. Disable it first.

Fixes: fe6d8a9c8e64 ("usb: typec: anx7411: Add Analogix PD ANX7411 support")
Cc: stable <stable@kernel.org>
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260910011150.2966843-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/anx7411.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -1567,8 +1567,11 @@ static void anx7411_i2c_remove(struct i2
 	anx7411_partner_unregister_altmode(plat);
 	anx7411_unregister_partner(plat);
 
-	if (plat->workqueue)
+	if (plat->workqueue) {
+		disable_irq(plat->intp_irq);
+		cancel_work_sync(&plat->work);
 		destroy_workqueue(plat->workqueue);
+	}
 
 	i2c_unregister_device(plat->spi_client);
 


