Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600B01C4EEA;
	Tue, 27 Aug 2024 15:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771790; cv=none; b=QfbR6Ry56FxXavClA5naUEs8d7D/suHv432ZzNmVyF4aRDnDroCXhKbVjGIbNNIgxq6szDdSpnlucFW09WfXQMM2cPxdM9AB5vg+Vmsv/wecT9OG5VD/z/gNyjPgTv7FGwFq0QcfC9aLJo96pYv1kEhqEL3KlbYwgsIq//Nlcb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771790; c=relaxed/simple;
	bh=loFSn5+7Ie3T8VGMLxhoivz1l6l7uBgc/fY39ay9EbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULA4mXqq9Th1bodYXvc14JIcMwHQuW+UadvFf/4ms2iGxph7harsmalDNSAoDhl3RbdL9mT7qV2uRi6FMv/rwVwRAPivxbNza+NdvfIE6d2yfxRwWrQkfwXYnm5mdmyLBvvmTeHLlZ/mgsDwK3c+b07FTA4Iw+mN8k4dpmMBO9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCsdwD8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCsdwD8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F82C4DE10;
	Tue, 27 Aug 2024 15:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771790;
	bh=loFSn5+7Ie3T8VGMLxhoivz1l6l7uBgc/fY39ay9EbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCsdwD8fuUYSA07MDfoxhwMvam4oggYEzOAyGABuI44ap1PfepQxlkR+0EF+tXw2j
	 ZdIefCwxo1/R3Wn3YZefh+ldXlOCfbhOn8uq2VpmsOzSoOVi4QtBtvXkU2zSM5fom9
	 2R9NuM31wBPRKvQ9hCb0n/ykf81gnReFLloNL+AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 021/321] i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume
Date: Tue, 27 Aug 2024 16:35:29 +0200
Message-ID: <20240827143839.017273039@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Shyti <andi.shyti@kernel.org>

commit 4e91fa1ef3ce6290b4c598e54b5eb6cf134fbec8 upstream.

Add the missing geni_icc_disable() call before returning in the
geni_i2c_runtime_resume() function.

Commit 9ba48db9f77c ("i2c: qcom-geni: Add missing
geni_icc_disable in geni_i2c_runtime_resume") by Gaosheng missed
disabling the interconnect in one case.

Fixes: bf225ed357c6 ("i2c: i2c-qcom-geni: Add interconnect support")
Cc: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -990,8 +990,10 @@ static int __maybe_unused geni_i2c_runti
 		return ret;
 
 	ret = clk_prepare_enable(gi2c->core_clk);
-	if (ret)
+	if (ret) {
+		geni_icc_disable(&gi2c->se);
 		return ret;
+	}
 
 	ret = geni_se_resources_on(&gi2c->se);
 	if (ret) {


