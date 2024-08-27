Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695391494AC;
	Tue, 27 Aug 2024 14:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769770; cv=none; b=FQuX/QHJlCTquRBgaDGUcxbpjFCD5cAPeTmPxBENMWUdxsjOg46GHWqQR92AiOPLYYu+56oy40kem3XE/azSWwxBd2IVMxhEK/u84+T5+g/Wi6Y4g5hhppdQCcRxClo3YaxhYX9Yx9XgsoT209K4PgpBOE73ZvC0KaRFG8e3jc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769770; c=relaxed/simple;
	bh=tnQ/QmdoiQiWqjSyFi81vBCNn/mGFAQ5w07ebe1pfN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoA9Utj8kUl+XfPHiGEsflZ/2SUDeodqtZVt6kWzAVblSwjkKSbeYfpRKAhgqLz3gTcVmGcUQNFqpZVLRPwBPpItf1Jmc+dHTTs4mRH/7tsWQS8JhFGT9w9677E8pJ0HXWvC8DTM5ygiQ+FIxfE3N9Tr9RCaeSLBnDcaf5uRkuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyQ8FOcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyQ8FOcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92495C61043;
	Tue, 27 Aug 2024 14:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769770;
	bh=tnQ/QmdoiQiWqjSyFi81vBCNn/mGFAQ5w07ebe1pfN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyQ8FOcXKocByc/nWiSp81ZbrMx/LJBmRidgTTsT/TrXgXPOwXAzFJ9Z3JGYhHa0r
	 24pQdeI5Xb+Dr42tjsZdA8/Vb9swOaWx3K00aZ/4XDSmzVPWHKaeuK1IVDiqB8X8gG
	 2AYz57NkBusuuddvagDdf6FCCQKUG2CUrFGBecrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 031/341] i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume
Date: Tue, 27 Aug 2024 16:34:22 +0200
Message-ID: <20240827143844.594310252@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
@@ -987,8 +987,10 @@ static int __maybe_unused geni_i2c_runti
 		return ret;
 
 	ret = clk_prepare_enable(gi2c->core_clk);
-	if (ret)
+	if (ret) {
+		geni_icc_disable(&gi2c->se);
 		return ret;
+	}
 
 	ret = geni_se_resources_on(&gi2c->se);
 	if (ret) {


