Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48CD305678;
	Fri, 15 May 2026 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860666; cv=none; b=FOpQIJ0BshQ09GGgxY2njbBYIxtRYfHsjCZ3yybhNs/gE8ciDeiwyVWVXDsl0hz5YG3xy3kw4p+EJY4OEdbrNY8It5dT48fvO6BMXdx2I2OaWAJ/r98Ya37o+VOpRRJCBogklQGawQSZRribKNdJU9SDML7W1+Gbm0UiQjPSfaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860666; c=relaxed/simple;
	bh=ZluO+xdthIdaJPjpoRk+MPKtEZyz054+LCYYyxvO3hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ya3FmdmhifKZGzhJmcz2a7yjaaImsq19fs7mserQnopAXOGGZaHJTRZoiHPIk0GnIAyyLM+Ahrmo2fXugjxWclNMYlLu49CNS0z3Y2wxfc9Ug0YokRY7km77DlZsaoBk5PXCT3ubZFq4Vy6bWCsusqfk1B30kku4m8d5o9q2LBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyenUTur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyenUTur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2B7C2BCB3;
	Fri, 15 May 2026 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860665;
	bh=ZluO+xdthIdaJPjpoRk+MPKtEZyz054+LCYYyxvO3hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyenUTurHQk5cy85plac55Pkbg4qAjood5sQ46UxBkgFJSaehX9L/185fOuJGSyG+
	 HQWlwgbwI19ljUIa1Ve8AIfam8mMm5rOmi87VVz47HlKE/zWDVjI+RQSNQPVxm7r8e
	 BFbDEIgbBCE4IoCwbsAGmoozmQ3hoCwAeqizS0Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 033/474] net: caif: clear client service pointer on teardown
Date: Fri, 15 May 2026 17:42:22 +0200
Message-ID: <20260515154715.766071621@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchuan Liang <zcliangcn@gmail.com>

commit f7cf8ece8cee3c1ee361991470cdb1eb65ab02e8 upstream.

`caif_connect()` can tear down an existing client after remote shutdown by
calling `caif_disconnect_client()` followed by `caif_free_client()`.
`caif_free_client()` releases the service layer referenced by
`adap_layer->dn`, but leaves that pointer stale.

When the socket is later destroyed, `caif_sock_destructor()` calls
`caif_free_client()` again and dereferences the freed service pointer.

Clear the client/service links before releasing the service object so
repeated teardown becomes harmless.

Fixes: 43e369210108 ("caif: Move refcount from service layer to sock and dev.")
Cc: stable@kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/9f3d37847c0037568aae698ca23cd47c6691acb0.1775897577.git.zcliangcn@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/caif/cfsrvl.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/net/caif/cfsrvl.c
+++ b/net/caif/cfsrvl.c
@@ -197,10 +197,20 @@ bool cfsrvl_phyid_match(struct cflayer *
 
 void caif_free_client(struct cflayer *adap_layer)
 {
+	struct cflayer *serv_layer;
 	struct cfsrvl *servl;
-	if (adap_layer == NULL || adap_layer->dn == NULL)
+
+	if (!adap_layer)
+		return;
+
+	serv_layer = adap_layer->dn;
+	if (!serv_layer)
 		return;
-	servl = container_obj(adap_layer->dn);
+
+	layer_set_dn(adap_layer, NULL);
+	layer_set_up(serv_layer, NULL);
+
+	servl = container_obj(serv_layer);
 	servl->release(&servl->layer);
 }
 EXPORT_SYMBOL(caif_free_client);


