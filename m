Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A6F4086A;
	Tue, 11 Nov 2025 00:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822498; cv=none; b=AeA4Mt7EwsbB42riqxPwgGBYbslte6HxTkJZJddTECLb5rTGLAU7drctLdHUPoZ4Wh7tJ6V8JL/YIjitAPJMN23IDoz13zDS4qeKNIXy5zE9cRQ3E04oXqrn6usbpjoL6kHl1AZ+pmx3CvMgiDjrYV7/vbau7b+AxQYxyKxG/Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822498; c=relaxed/simple;
	bh=kzdVJdgG2fFbeVp91iB3InyHSdyG2c0tn8/wcyA9RHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRl0N9PeW64LH9gJXNSyKS6vnDVRpf0cXeCF3TukzI380W/wWBG2vi0GWVJ5/zsI0gibqM4yKBnChDDcX8DjXegwSTfU89k6rnQwwqp5NK5WNg/bZzLpMqQUC32+qINeqHRV2jPIDS1zNJ0IMBXdLY7LB6/YSmOFYn1ec9LEXvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLW6BGN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLW6BGN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8943C113D0;
	Tue, 11 Nov 2025 00:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822498;
	bh=kzdVJdgG2fFbeVp91iB3InyHSdyG2c0tn8/wcyA9RHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLW6BGN80b6AZXo184NjwzuG7VBr7FDPpP6Dq66JoZm7qq88jb5RIJW//oP5KgN4g
	 LMancgxPb5QX7OTkbAgXMq5tC+VHN2o4Q8HcpfsFnunY3ZQnaFlUMVMkVMwNVbkwuv
	 bvvTH+UKL0ZNWJve3FfrisbBbsbjIjGBj4kS2EL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 119/849] firmware: qcom: scm: preserve assign_mem() error return value
Date: Tue, 11 Nov 2025 09:34:49 +0900
Message-ID: <20251111004539.275120412@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 121fcf3c871181edce0708a49d2397cedd6ad21f ]

When qcom_scm_assign_mem() fails, the error value is currently being
overwritten after it is logged, resulting in the loss of the original
error code. Fix this by retaining and returning the original error value
as intended.

Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250807124451.2623019-1-mukesh.ojha@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 26cd0458aacd6..5243d5abbbe99 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1119,7 +1119,7 @@ int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 	if (ret) {
 		dev_err(__scm->dev,
 			"Assign memory protection call failed %d\n", ret);
-		return -EINVAL;
+		return ret;
 	}
 
 	*srcvm = next_vm;
-- 
2.51.0



