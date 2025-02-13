Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6150D26B0BC;
	Thu, 13 Feb 2025 15:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460005; cv=none; b=UIe1njMMehKsfW69Y1emZ+3a3XgMuRS7HiN5FpDsRDjbUVxP+HBNpoVsCO7oDzILykUxoKtQdrrlsQw8Ry+ALqWIMbd4ZYtMOsTlrQLZaxtDUubVoPRTNfBpXiNizGPIjTxpu8rH8hjEfneYhIezpzeQZzzZwxaaoAfNXtBZoIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460005; c=relaxed/simple;
	bh=Gd2IoymuJ0rtVSPZDia3F20SawnmvvwO071og4lKTm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QasYtpU8HBcS9ZYYhJyDDT0VSZh7+DtSEIx37j/S6ebUc7UtM9OlbB1KiuqPql05qVNjEZdX0bFC69XyJG0XQnN7/0ypxdtOiaecOOWLCvjMVzBRLBv10QWMdhkq2Esz91PW9ZPFcDr6MzY+9odoNwz2HDGIW6gzlcS3/VuIkPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvMsTPRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvMsTPRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA942C4CEE5;
	Thu, 13 Feb 2025 15:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460005;
	bh=Gd2IoymuJ0rtVSPZDia3F20SawnmvvwO071og4lKTm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvMsTPRQgkF+9Q7FD4F8Aav8bMlxsXWj3stCNdlDBnzPt0HJKYhrKw/kfpLIu2/PR
	 LKZ+qKjoFgZQhwV0F/87Gc0rUeXid2WjAJ6qmO9B1G757tCvrXPOuJQ2PwSZ/1j1lO
	 DZ1OWlJTWfDCeK2BofM/pW6AYtSab5l7ql4pdBUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Anandu Krishnan E <quic_anane@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.13 412/443] misc: fastrpc: Deregister device nodes properly in error scenarios
Date: Thu, 13 Feb 2025 15:29:37 +0100
Message-ID: <20250213142456.507770058@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


