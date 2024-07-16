Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4B91DDCE;
	Tue, 16 Jul 2024 16:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145833; cv=none; b=tu8rwsSG6n8/q9j1YhuOLwf1L/Q6MdaEChfiJz3b6bOe5qsvGBuJWGC4kn7JxwV56YI6LfA6o0krJmFnjEieyBUV3lzOOf9JK8XFQaY2qq1Z3smnlKGXcLwQAz9mw+lkljvAHlEFjWZbTwOgsbMJe10T6cF+v4f3JqU7apsCn7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145833; c=relaxed/simple;
	bh=171rOtgENj18iS9+9amY7cmvJriutIRoiexCQpvO4aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZerpYW6gF2jmFsQWVS67D1XT0vQI56ZHNKt7eAGS6p2LNHpIRo1+Uh5zfyGpt/1g4tAeekzMM9SBAPngyWvH6z2Y9L03Zd8FDUqtjWfZQHw65pjTo1WFSSQBV4LUNx1OQxT8WCWWTtwPcpYUDzoNlyQ4Y3HsC8ch5kIg0V0/r10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrXmCIqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrXmCIqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E66EC4AF11;
	Tue, 16 Jul 2024 16:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145833;
	bh=171rOtgENj18iS9+9amY7cmvJriutIRoiexCQpvO4aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrXmCIqW/hdDsdQZSowMKCtIYKzhpkzqVUh2QxUkg8Lf1WkYgvmOcZEu6mlG3a/96
	 Z1jvmCaAQzJWQUrL9Avc6cqcqD+bvA+aDvg+wM/NbUmgUucdDPw4rPfly+C24KalW7
	 kv/F7Ndm0Q9TOhbXT/qpk4+7y4kPb2AICQsME9NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 100/121] misc: fastrpc: Fix memory leak in audio daemon attach operation
Date: Tue, 16 Jul 2024 17:32:42 +0200
Message-ID: <20240716152755.176186703@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit ad0bd973a033003ca578c42a760d1dc77aeea15e upstream.

Audio PD daemon send the name as part of the init IOCTL call. This
name needs to be copied to kernel for which memory is allocated.
This memory is never freed which might result in memory leak. Free
the memory when it is not needed.

Fixes: 0871561055e6 ("misc: fastrpc: Add support for audiopd")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628114501.14310-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1320,6 +1320,7 @@ static int fastrpc_init_create_static_pr
 		goto err_invoke;
 
 	kfree(args);
+	kfree(name);
 
 	return 0;
 err_invoke:


