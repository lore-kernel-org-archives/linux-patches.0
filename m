Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5940B18C900;
	Thu, 13 Feb 2025 14:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458465; cv=none; b=oF5P+7HDR9lgg+IEs5ro+Wez5rtj0iZWuvqaXsyUJhOjYpTGu3Ib0GMM3g2VIkIAByLeYHJbRu6x2GCGrKdLXVA+H25g22Qz1uqwbKKPBGApz53Bvv20RCvI/HHdzvtYxDkLikgEKRqNq9qhKnwiQNS4MibZMuqtIHHTfDdK830=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458465; c=relaxed/simple;
	bh=c+3nPC2+Eo4ZngAnkrCo/jIdO1nP2bjNyXfjbIuDL0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvmmWi5o0mc/yGebsZG++N/CktzmoXo00xRyrkgovolic8A8s9LAji5zs/pw970xoqQ9GsRJX4v1u/h11XY6ooDJG5nveRJ9rrMEiYF1HPuCD5pD31NIF+Q/C9YvTO7W0i1HbzaRFSJHMMdc2OkXyJf20Ul0SzId4tev5mtJjaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODCMhEeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODCMhEeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473D3C4CED1;
	Thu, 13 Feb 2025 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458464;
	bh=c+3nPC2+Eo4ZngAnkrCo/jIdO1nP2bjNyXfjbIuDL0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODCMhEeYvu7mgllZ8Ve1hZtb3XgDUrthqsRCDxBan50gEe+2Sk/lrDiWxPUfmzc5C
	 HM2H4AJxGL9VtYzqtGJL+SP4GINKPXkvhFCttQXisnmCrawADiW1g7cvFv0iqdfojG
	 lBOgQRoKRlX0xktMvOKrykb9SxZkukm+Ii9bl/sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Anandu Krishnan E <quic_anane@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.12 375/422] misc: fastrpc: Deregister device nodes properly in error scenarios
Date: Thu, 13 Feb 2025 15:28:44 +0100
Message-ID: <20250213142451.018884090@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anandu Krishnan E <quic_anane@quicinc.com>

commit 637c20002dc8c347001292664055bfbf56544ec6 upstream.

During fastrpc_rpmsg_probe, if secure device node registration
succeeds but non-secure device node registration fails, the secure
device node deregister is not called during error cleanup. Add proper
exit paths to ensure proper cleanup in case of error.

Fixes: 3abe3ab3cdab ("misc: fastrpc: add secure domain support")
Cc: stable@kernel.org
Signed-off-by: Anandu Krishnan E <quic_anane@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20250110134239.123603-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -2344,7 +2344,7 @@ static int fastrpc_rpmsg_probe(struct rp
 
 		err = fastrpc_device_register(rdev, data, false, domains[domain_id]);
 		if (err)
-			goto fdev_error;
+			goto populate_error;
 		break;
 	default:
 		err = -EINVAL;


