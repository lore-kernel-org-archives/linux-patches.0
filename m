Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602F9FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49E9C433D2;
	Mon, 15 May 2023 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170463;
	bh=c/O0qV31ZKfDuQtGjvdPfrfaJpo9rVqHAzIqawCN0mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaFvM89wBwy4oYA7zblLrDYgD/iJLBdRI8dpcLe7fzOSL+lg/gZGpT9Whp0ZsIl2n
	 DiKOhRx3JG6KozC3Qz1qXW4e+JPnVtOI6UPrm7AKABcVyJcfQLvttuRMvsOwmE5MfL
	 EeXPrmAByodN4VRuN+at7IGzyJkiuxNP8KJG+4QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Subject: [PATCH 6.1 138/239] remoteproc: st: Call of_node_put() on iteration error
Date: Mon, 15 May 2023 18:26:41 +0200
Message-Id: <20230515161725.832909659@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathieu Poirier <mathieu.poirier@linaro.org>

commit 8a74918948b40317a5b5bab9739d13dcb5de2784 upstream.

Function of_phandle_iterator_next() calls of_node_put() on the last
device_node it iterated over, but when the loop exits prematurely it has
to be called explicitly.

Fixes: 3df52ed7f269 ("remoteproc: st: add reserved memory support")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Link: https://lore.kernel.org/r/20230320221826.2728078-3-mathieu.poirier@linaro.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/st_remoteproc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/st_remoteproc.c
+++ b/drivers/remoteproc/st_remoteproc.c
@@ -129,6 +129,7 @@ static int st_rproc_parse_fw(struct rpro
 	while (of_phandle_iterator_next(&it) == 0) {
 		rmem = of_reserved_mem_lookup(it.node);
 		if (!rmem) {
+			of_node_put(it.node);
 			dev_err(dev, "unable to acquire memory-region\n");
 			return -EINVAL;
 		}
@@ -150,8 +151,10 @@ static int st_rproc_parse_fw(struct rpro
 							   it.node->name);
 		}
 
-		if (!mem)
+		if (!mem) {
+			of_node_put(it.node);
 			return -ENOMEM;
+		}
 
 		rproc_add_carveout(rproc, mem);
 		index++;


