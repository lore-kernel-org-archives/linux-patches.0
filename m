Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927B61A0728;
	Thu, 15 Aug 2024 13:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728898; cv=none; b=CsHa8s7Mt4ObpelLbTOl34a6sNrPmyhb4KzW4fy5/Dtbt0VGRCslew2elwu81nyI6d2bOEAMKHlHNkW7CzfTD1772FSlqBuAIxLDTzGgHT4F5HW9Y2F8bAMuXGQmnq/WuHSMKZjweg73snGunx4ysWUTOqV9NwLVSCiSZZLKZTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728898; c=relaxed/simple;
	bh=miY0GHj5BYNyJp+9IUHkOud7TZET83tk1tLrK+qQnTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nd0PYMh3P0gVZQ0jfNC53gvJXZ0OStkNmkMfPTSdsZpPiLiL5SDx+RT1etWZcvHmGB9rEiZcPJGl8u/JPMGcrKcP6lLxdYSHIocrsKn/7aVvrZ8NSWV6lG3PT2bWD5lsN4iI1C25SH0bWjj8OaYSAANDnoiRPbGhEEehUpg5/+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNb/eTTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNb/eTTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18565C4AF0A;
	Thu, 15 Aug 2024 13:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728898;
	bh=miY0GHj5BYNyJp+9IUHkOud7TZET83tk1tLrK+qQnTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNb/eTTY+ec8O+X2VoqcBNpXBxjgHLB6H5swKTBLlyE/DN26GPfNjjlcPzBJAQYId
	 r42hB2yGHMGcW+0Soa4SgMJnDJOW1ucr2AuJU9SkqvEdkfUct1NckOfeFfvDkUWg/F
	 sRyFNWNw+ZCTPK4lOqU0yQAY1g//0omxcUi0PwTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/196] devres: Fix memory leakage caused by driver API devm_free_percpu()
Date: Thu, 15 Aug 2024 15:23:51 +0200
Message-ID: <20240815131856.441160322@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit bd50a974097bb82d52a458bd3ee39fb723129a0c ]

It will cause memory leakage when use driver API devm_free_percpu()
to free memory allocated by devm_alloc_percpu(), fixed by using
devres_release() instead of devres_destroy() within devm_free_percpu().

Fixes: ff86aae3b411 ("devres: add devm_alloc_percpu()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-3-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 7b4346798d5fb..a64f70a62e28f 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -1057,7 +1057,11 @@ EXPORT_SYMBOL_GPL(__devm_alloc_percpu);
  */
 void devm_free_percpu(struct device *dev, void __percpu *pdata)
 {
-	WARN_ON(devres_destroy(dev, devm_percpu_release, devm_percpu_match,
+	/*
+	 * Use devres_release() to prevent memory leakage as
+	 * devm_free_pages() does.
+	 */
+	WARN_ON(devres_release(dev, devm_percpu_release, devm_percpu_match,
 			       (__force void *)pdata));
 }
 EXPORT_SYMBOL_GPL(devm_free_percpu);
-- 
2.43.0



