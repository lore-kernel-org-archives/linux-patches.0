Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3091A76AE;
	Tue, 30 Jul 2024 17:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360089; cv=none; b=suqMTVn9mPFZd1K/oaFs5iNm4Nl3ASdWa1bFxB/5n/wcQZUapTZL0hgntjxUEmZZNHOjVgUoB522l6swDWD1//8ZPgx1JzfnIM1Ous7jlXY8NjwkLBRKI9CFl6y83MHCfoo0ntVtUw/4vm1uR7bTKss1pOoYv9Cwj9DSQcGXwn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360089; c=relaxed/simple;
	bh=qvqIuwkDNBL42UZZteZ4KJ3diOM8D1IDPdP2oqzOx7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYrxDfg/QwBlsytqg9y6MHTevneoLzPCgV6g93P8NKxAg3Q8WXnafbFyyUrgTdRaiOEej7tq/vJgg87LhRQBbj5B9RfvbqxfzQ4osiQM0K6mNGapksNNNQIuMc2DrG8KlaKZ+iIj9ENPfFps+/0G65IbxWi+IY27p31ODAaHqT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0sejVra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0sejVra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2165CC4AF0A;
	Tue, 30 Jul 2024 17:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360089;
	bh=qvqIuwkDNBL42UZZteZ4KJ3diOM8D1IDPdP2oqzOx7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0sejVraLnzrzV4vrmLv+ai72ihO6Ek8K247Gso0tP8wiaeNb21FzFuuXjAlxM74H
	 99SNIxhyZaeorSB4jVWsM8jnukUndd7FrWYaKgIo/JAg1vSxFGlNk8I84jz8xnSy7n
	 w+whpphjdNZN8f3FbxCUiwIQnqtUTzUGRLaj7ekc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.10 563/809] media: stm32: dcmipp: correct error handling in dcmipp_create_subdevs
Date: Tue, 30 Jul 2024 17:47:19 +0200
Message-ID: <20240730151747.003602205@linuxfoundation.org>
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

From: Alain Volmat <alain.volmat@foss.st.com>

commit a7351f0d3668b449fdc2cfd90403b1cb1f03ed6d upstream.

Correct error handling within the dcmipp_create_subdevs by properly
decrementing the i counter when releasing the subdevs.

Fixes: 28e0f3772296 ("media: stm32-dcmipp: STM32 DCMIPP camera interface driver")
Cc: stable@vger.kernel.org
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
[hverkuil: correct the indices: it's [i], not [i - 1].]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-core.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmipp/dcmipp-core.c
@@ -202,8 +202,8 @@ static int dcmipp_create_subdevs(struct
 	return 0;
 
 err_init_entity:
-	while (i > 0)
-		dcmipp->pipe_cfg->ents[i - 1].release(dcmipp->entity[i - 1]);
+	while (i-- > 0)
+		dcmipp->pipe_cfg->ents[i].release(dcmipp->entity[i]);
 	return ret;
 }
 


