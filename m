Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDAE1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BD4C433D2;
	Mon, 20 Mar 2023 15:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325948;
	bh=7NBaoj5epw2EWaCt3Ia8FlZOBg2J+aRdzIyMQe5D3gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvu8JozPhLD82ODlt3sNHXdWNlFYTAiMjMff26N06CuTCyxRB5keF5AufTxLCXOCN
	 wAccH+I+2d9JtbGKrN3vAJ56HXGAXrENCWYEdbHO5EXKcwdNFihdFtcKn3i0fQTRe8
	 CvsgJ8wrlx0ahE49D26ItvCz/I74LJ//WGxVUgUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.2 130/211] interconnect: fix icc_provider_del() error handling
Date: Mon, 20 Mar 2023 15:54:25 +0100
Message-Id: <20230320145518.856678151@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit e0e7089bf9a87bc5e3997422e4e24563424f9018 upstream.

The interconnect framework currently expects that providers are only
removed when there are no users and after all nodes have been removed.

There is currently nothing that guarantees this to be the case and the
framework does not do any reference counting, but refusing to remove the
provider is never correct as that would leave a dangling pointer to a
resource that is about to be released in the global provider list (e.g.
accessible through debugfs).

Replace the current sanity checks with WARN_ON() so that the provider is
always removed.

Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
Cc: stable@vger.kernel.org      # 5.1: 680f8666baf6: interconnect: Make icc_provider_del() return void
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # i.MX8MP MSC SM2-MB-EP1 Board
Link: https://lore.kernel.org/r/20230306075651.2449-3-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/core.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1061,18 +1061,8 @@ EXPORT_SYMBOL_GPL(icc_provider_add);
 void icc_provider_del(struct icc_provider *provider)
 {
 	mutex_lock(&icc_lock);
-	if (provider->users) {
-		pr_warn("interconnect provider still has %d users\n",
-			provider->users);
-		mutex_unlock(&icc_lock);
-		return;
-	}
-
-	if (!list_empty(&provider->nodes)) {
-		pr_warn("interconnect provider still has nodes\n");
-		mutex_unlock(&icc_lock);
-		return;
-	}
+	WARN_ON(provider->users);
+	WARN_ON(!list_empty(&provider->nodes));
 
 	list_del(&provider->provider_list);
 	mutex_unlock(&icc_lock);


