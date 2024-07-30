Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCF41A76BE;
	Tue, 30 Jul 2024 17:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360359; cv=none; b=GwW3zPM4f0hTiFLD8W/LDLaisgQoHZ5IJjxxpD7bApVqnXA2dUl2X/DT591LlWr/Ub10wLhXFfaOrxhkJnvWurvBGkVkyx5/0/h1TZLl9ijdk18MoGiPSWqHyIB4Jx4sNpIwCNeiED4TGViL/Y34ieEv+2fjvW9E5Oe0T2uTQ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360359; c=relaxed/simple;
	bh=FhJutoYo2QFB6ZhkAsU+lE2nF4uar8WZvbd/8adiP+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bB3rLI6mEe26jlDPJYrbUz0ssR75v2WsGMEvhlb/S1cd5iQpTskarZ2GKyr7DQkX58uu/HHjb33/jPgWlW50mfKqbmNJ4cPue3AgSEbBo1qQ+OAXgxo9h55oHeBrSNlry5T62++xplktx7swzKvAkWz+BOdR68OqRPXiFTciMLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKSUsxMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKSUsxMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D2EC4AF15;
	Tue, 30 Jul 2024 17:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360359;
	bh=FhJutoYo2QFB6ZhkAsU+lE2nF4uar8WZvbd/8adiP+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKSUsxMQjE/nHv2Y/3Ru107CjNn/qqULO1EG0Gyj8Y5q9Iv7BYt60Gre9W2vIppry
	 Vjpc9E3drXka3FHCU9Y5h/AN1T88mSudODm0A/FvZoSOx8faOTqWlzaiuop+pMctZ2
	 7H54a4yFvZR7rPSHo2kmZmedZ3BqZq/8gM/mHPxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.10 675/809] devres: Fix devm_krealloc() wasting memory
Date: Tue, 30 Jul 2024 17:49:11 +0200
Message-ID: <20240730151751.563473640@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit c884e3249f753dcef7a2b2023541ac1dc46b318e upstream.

Driver API devm_krealloc() calls alloc_dr() with wrong argument
@total_new_size, so causes more memory to be allocated than required
fix this memory waste by using @new_size as the argument for alloc_dr().

Fixes: f82485722e5d ("devres: provide devm_krealloc()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-2-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/devres.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -896,9 +896,12 @@ void *devm_krealloc(struct device *dev,
 	/*
 	 * Otherwise: allocate new, larger chunk. We need to allocate before
 	 * taking the lock as most probably the caller uses GFP_KERNEL.
+	 * alloc_dr() will call check_dr_size() to reserve extra memory
+	 * for struct devres automatically, so size @new_size user request
+	 * is delivered to it directly as devm_kmalloc() does.
 	 */
 	new_dr = alloc_dr(devm_kmalloc_release,
-			  total_new_size, gfp, dev_to_node(dev));
+			  new_size, gfp, dev_to_node(dev));
 	if (!new_dr)
 		return NULL;
 


