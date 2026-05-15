Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931D83FD967;
	Fri, 15 May 2026 16:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861371; cv=none; b=IVba0KGgLmlv6FFhCHlEviiD/AojCSi4L/deMz4LGxPWD9TKnOwJVwXQ2xvB4Q5ppt/Gaq/NgEjRNOYESLEcqK1Nfk4me9/wOz6gz5jiFfJrHVSMdBdMma+oCDu1Cp+gubFdrW/MOMDI+qmOdBiwgMD895JroxOs5h8+68PjonU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861371; c=relaxed/simple;
	bh=bSU5O849j4jTSH07EohFnTL8rm+xg7ZIt1WaFTTmTJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbQb95A2QrbYgE8/Jy4Tw7fyUStx/KL21LjlZtA4i4q78OKG1Om/IdZqR8nijzikK8SD+i55bFwBAv/pPhN44f5jirqDcb4lAXlX7rHRvRtHBjZp8aH0JtPPOlG+BIEhIRxLE5igDZ3lUDNeiAON7FF74fgsFGE+aud2sItP0Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IN8uuXu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IN8uuXu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D19FC2BCB0;
	Fri, 15 May 2026 16:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861371;
	bh=bSU5O849j4jTSH07EohFnTL8rm+xg7ZIt1WaFTTmTJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IN8uuXu0b+9GK4BKH9UXHo0zb76atF9CM+vfflStWhUODR1qY+U2rpdumM0ohYrwT
	 v5Oi3gdaOnpbUavopi7SxXqgml/w6QQx4NtPeJ+hzV8hGQyiPQvYgLwE9cz9hUjb7J
	 qut4K7hKuXgVZDix/wHhjZWeqkCWWzCVadx4GV0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 304/474] regulator: max77650: fix OF node reference imbalance
Date: Fri, 15 May 2026 17:46:53 +0200
Message-ID: <20260515154721.583025408@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 2edaf5f7ada0ab5c9ec1f0836bd19779a8d85262 upstream.

The driver reuses the OF node of the parent multi-function device but
fails to take another reference to balance the one dropped by the
platform bus code when unbinding the MFD and deregistering the child
devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: bcc61f1c44fd ("regulator: max77650: add regulator support")
Cc: stable@vger.kernel.org	# 5.1
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260408073055.5183-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/max77650-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max77650-regulator.c
+++ b/drivers/regulator/max77650-regulator.c
@@ -339,7 +339,7 @@ static int max77650_regulator_probe(stru
 	parent = dev->parent;
 
 	if (!dev->of_node)
-		dev->of_node = parent->of_node;
+		device_set_of_node_from_dev(dev, parent);
 
 	rdescs = devm_kcalloc(dev, MAX77650_REGULATOR_NUM_REGULATORS,
 			      sizeof(*rdescs), GFP_KERNEL);


