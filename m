Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDA0271284;
	Thu, 13 Feb 2025 14:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457883; cv=none; b=AuZzTCPpOPIE+RLKGkJN8LpvcfW4FlEGLssahDJkIUs77JTLxDGzFKqtpsH9LrZnZZmsf/oxORksQKlbO4sqooFn1BAZn6gsuTI416rxJAN3sGzy/Rg8N3W8k8wVNKw2V0C9yKcfLdfdXAkmHjvIwSRJNXMUt00XJ8JHg6dizDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457883; c=relaxed/simple;
	bh=sWjBNdSNTa9mF3gbFgkwEpnSIWUqx7Mx7yIZP3wq9gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQdkVQ3fMXpp/hegnKnJF1Fs63Fr8bFIa8XHvc/cWxDSGPcxKn+m+MV/BX/MQlMQOQV/OuhaSLoe8VOWoDZe4zQqEFPEaOWsssnAiRqTSCNzmoa7BzGd/sAB8xbZCJR4kMdQ71Li2D1yLKdCCbYS+WsbH3pLA1WvmoNwlnZVzik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ulhz8cKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ulhz8cKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8632DC4CEE9;
	Thu, 13 Feb 2025 14:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457883;
	bh=sWjBNdSNTa9mF3gbFgkwEpnSIWUqx7Mx7yIZP3wq9gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ulhz8cKYGBabp+YM3YRcaLP/Hsg6N8BmMUBpP1W2KRc5VCLf+RRux98tHYGsjCIxL
	 ab9K46BhRF6KVEc4Rrj+nUoOTXsCQzupR1dngCZgdC9eY5etZpG7+xRs40Ih0ZszF3
	 I/Pa6JYsyatYDa5bMGiYeHdhQleeFgCg1MaaA6Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 241/422] firmware: qcom: scm: Fix missing read barrier in qcom_scm_get_tzmem_pool()
Date: Thu, 13 Feb 2025 15:26:30 +0100
Message-ID: <20250213142445.836605414@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit b628510397b5cafa1f5d3e848a28affd1c635302 upstream.

Commit 2e4955167ec5 ("firmware: qcom: scm: Fix __scm and waitq
completion variable initialization") introduced a write barrier in probe
function to store global '__scm' variable.  We all known barriers are
paired (see memory-barriers.txt: "Note that write barriers should
normally be paired with read or address-dependency barriers"), therefore
accessing it from concurrent contexts requires read barrier.  Previous
commit added such barrier in qcom_scm_is_available(), so let's use that
directly.

Lack of this read barrier can result in fetching stale '__scm' variable
value, NULL, and dereferencing it.

Note that barrier in qcom_scm_is_available() satisfies here the control
dependency.

Fixes: ca61d6836e6f ("firmware: qcom: scm: fix a NULL-pointer dereference")
Fixes: 449d0d84bcd8 ("firmware: qcom: scm: smc: switch to using the SCM allocator")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241209-qcom-scm-missing-barriers-and-all-sort-of-srap-v2-2-9061013c8d92@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qcom/qcom_scm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index cde60566c793..4a1c05a7bf20 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -217,7 +217,10 @@ static DEFINE_SPINLOCK(scm_query_lock);
 
 struct qcom_tzmem_pool *qcom_scm_get_tzmem_pool(void)
 {
-	return __scm ? __scm->mempool : NULL;
+	if (!qcom_scm_is_available())
+		return NULL;
+
+	return __scm->mempool;
 }
 
 static enum qcom_scm_convention __get_convention(void)
-- 
2.48.1



