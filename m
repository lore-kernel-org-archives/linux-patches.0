Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F2F1E102E;
	Wed, 19 Feb 2025 09:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957118; cv=none; b=RSwVM75VKTjh8Dstl2Iqwz8gU6J2Zc8GDDwlb2LqPqiK21CdTl4l5udKeATR450xS+kTEbi4PZK+RxGWmc8Qk8Ye/C+SnmA0l3e6kqbOi5Dd47Xnc33ODGDOxxXqirvGkkjZliEfz/TA3SeohS7Juid7UimjeQ2tlV5potostBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957118; c=relaxed/simple;
	bh=CwyKDsm+gckUUioNUAMef+MLL8Zjcpwb08dKJSpsqBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvDIAWIYX05LNDQU1SGfEhgg8LnJTyl/0/J4SMC7W+BHUOtDmTJVpKhJS9cTJtZFl3NPymn2mlfwNwVec9WfGoNiF8JjopRgipZ08PuZwqhJXoh44mybmENn6pRzbNGWK/YSDYS/4LDRL6CvZJipeWE9aAI69VE9jM5ku3u60vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgTLP4YC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgTLP4YC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B7CC4CED1;
	Wed, 19 Feb 2025 09:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957117;
	bh=CwyKDsm+gckUUioNUAMef+MLL8Zjcpwb08dKJSpsqBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgTLP4YCg7nWrdge0sv/7G8dCU+/jqSAOHk/lpBqqaoCNiaIZQjlnqgtRwMHAy0qO
	 h4PQ7FYf1aEHWTxgyDyOuT//MO/Xv2Xu/yW25m456qLB9/qqjobZrGzOsxZ6Ta//MF
	 jgKvg8G7XarHinxv+99Ws6/sU08MvNOSyOaAoER4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 413/578] media: ccs: Fix cleanup order in ccs_probe()
Date: Wed, 19 Feb 2025 09:26:57 +0100
Message-ID: <20250219082709.267488093@linuxfoundation.org>
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

From: Mehdi Djait <mehdi.djait@linux.intel.com>

commit 6fdbff0f54786e94f0f630ff200ec1d666b1633e upstream.

ccs_limits is allocated in ccs_read_all_limits() after the allocation of
mdata.backing. Ensure that resources are freed in the reverse order of
their allocation by moving out_free_ccs_limits up.

Fixes: a11d3d6891f0 ("media: ccs: Read CCS static data from firmware binaries")
Cc: stable@vger.kernel.org
Signed-off-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3649,15 +3649,15 @@ out_media_entity_cleanup:
 out_cleanup:
 	ccs_cleanup(sensor);
 
+out_free_ccs_limits:
+	kfree(sensor->ccs_limits);
+
 out_release_mdata:
 	kvfree(sensor->mdata.backing);
 
 out_release_sdata:
 	kvfree(sensor->sdata.backing);
 
-out_free_ccs_limits:
-	kfree(sensor->ccs_limits);
-
 out_power_off:
 	ccs_power_off(&client->dev);
 	mutex_destroy(&sensor->mutex);


