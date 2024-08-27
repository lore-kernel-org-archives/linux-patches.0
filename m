Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B501C9DF1;
	Tue, 27 Aug 2024 15:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770936; cv=none; b=q0EATypEqSrdTWss4DW5E24yVJaXk8TLrNtkstwaIn6ltUHTqy0s1a5zac7rnyxck0ZbMFV7pp4ZC+Q+Vlvbm2bZEtYRM8eOQYci+k6Yc45M1EwUjQmc2Kt5wGoIXuourMETaNNb/9MhiZSjn1OJuS9chpdz4+UBCaWV9E4/ADE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770936; c=relaxed/simple;
	bh=Mvuzoh5C3ZnMP+UwxMGabHp0rpX1efSkQquxDV7ms8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxpG/d8FIQjuinjnjRXsWsTkwJRZZgCnT6VB49zkDldohYgs+yV3HplZbgDsef5sdf0LZx7HY8eaes5OgVYQcSUadrvmEmCxnLdn+ZgSXL+wMKpZDjR7F4yHhmLeJm2AVegHXSIlgQcO1PJG8YpUbY/PEBefZ9Gb4kvWraDWqaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlctolpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlctolpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B516C4DDFC;
	Tue, 27 Aug 2024 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770935;
	bh=Mvuzoh5C3ZnMP+UwxMGabHp0rpX1efSkQquxDV7ms8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlctolpJOXgVJDy4cUIW48jDg2utiNqj/dwddI2vWT231NDdR2X7k4W4qX4JCRwS1
	 bro+Mol9au3KoDTaYHPC+uICry22eUrFQ/UJHyy1VDuqF8CNzZFa6dl0kNwObNqlUX
	 qbyxEsoTCooNNgk+9j9PL6mKWCdSRIUlRtmIcwHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.10 038/273] i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume
Date: Tue, 27 Aug 2024 16:36:02 +0200
Message-ID: <20240827143834.845491381@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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
@@ -986,8 +986,10 @@ static int __maybe_unused geni_i2c_runti
 		return ret;
 
 	ret = clk_prepare_enable(gi2c->core_clk);
-	if (ret)
+	if (ret) {
+		geni_icc_disable(&gi2c->se);
 		return ret;
+	}
 
 	ret = geni_se_resources_on(&gi2c->se);
 	if (ret) {


