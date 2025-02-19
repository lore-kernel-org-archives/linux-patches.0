Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB7C1CC8B0;
	Wed, 19 Feb 2025 09:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957172; cv=none; b=ROo42/eC6WkOWVSzfrBYHU4uN1slwZ49Rj1uRfOaeU2ylV9y3GG9uKJmQCo7sQnZ/ddLAATiV9NadQ4H675UXoRSv3iVKRH2FN7PGneZ3ba71dp2CGCapk8Iq95Pg0bDwk35R2/1XbIuOISCaUbFn7fI4LbmtiJsfC1nZ/td8wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957172; c=relaxed/simple;
	bh=OoIRtXZDJrgax9ynYiDrODbUYfkqZwqNbI/ezlgxFsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unSNxnXQu3xgZYosGRLxPnlPBnpoT8ZgH1l/HvQH0JonO36hn+Xm7l58OxgaZpM3YRCKm19FL/+S3c7Jnadv0cmi+BYx0QG7gS6lEKuJCEqFQ80jDm4owD9AkVMD9ofEVNUsqhtC2hBEUoIETtkCL//yCr2JkdqkksOVJtOiqsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6FXY1LB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6FXY1LB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A03C4CED1;
	Wed, 19 Feb 2025 09:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957172;
	bh=OoIRtXZDJrgax9ynYiDrODbUYfkqZwqNbI/ezlgxFsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6FXY1LBdE3at5eBBsXgiyKq0z+AoW7gMC6rAIkea4m/6xoPovmMktW6gb258Gt8W
	 g8J//COsg5lRyGu1yxpzGPjRs3IBIzRGgqg5Tc6ouXbHg9TibiRvkUdWQKvM902pZW
	 IhjkVbEkQU6v7bBsdRgzFlpuxGLdZjOE+R1+2UEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Anandu Krishnan E <quic_anane@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 434/578] misc: fastrpc: Deregister device nodes properly in error scenarios
Date: Wed, 19 Feb 2025 09:27:18 +0100
Message-ID: <20250219082710.082758493@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2119,7 +2119,7 @@ static int fastrpc_rpmsg_probe(struct rp
 
 		err = fastrpc_device_register(rdev, data, false, domains[domain_id]);
 		if (err)
-			goto fdev_error;
+			goto populate_error;
 		break;
 	default:
 		err = -EINVAL;


