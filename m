Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A182FD1C5;
	Tue, 12 Aug 2025 18:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023399; cv=none; b=ncaDY1NFf1Nb6kR7gfpqb+jEPoszV0I59JN8ksLz1aqE+sVwI+/bBItaOC7kKoFwkZojHzhvj928XKzCZ+upMTSCJDUf9GqsKf/jDJYzXCDtvk9kYUy2UJ7IVZ/n6Xvdb5Fm0UHCdzNwoTSZQyzVQIyoWRcKOXzA3YKLK5AzZDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023399; c=relaxed/simple;
	bh=yAET7+pTvC/UkuE/O/F/2clUjXnBDzDvTN582lD3OZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCmQ1EC5gmnXJPou/wQ7OO50Q8h0zd3nHW4bSSFqRDTpB1vwGv6sWY7/djbr9wFpDWRXXakHFahUf7AjhL8pwsYTcsZLf1JIfXqDTsnOWcIXyQPxFnZuqVKiTjTx0Hb3n/aolFBJRWl+i2YIlMlBSFAQ6oHUKsm/v1UCfABkeT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ro5VyD5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ro5VyD5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F280BC4CEF0;
	Tue, 12 Aug 2025 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023399;
	bh=yAET7+pTvC/UkuE/O/F/2clUjXnBDzDvTN582lD3OZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ro5VyD5BR2Brp5MHNcmstFoT6wZ5GcQUhCpGki+WURrm4M4c+o2VdM0CSl3ZmRVyQ
	 EsOUIi97y3LFBLacegICkaetFeSEGOgpGZFd0h4i6Fd9iUa4UPiLLvPJ11MhRCviP4
	 s/aHHyi7xkhDyaTBRH6Xs4Y2mU/o+g2XCQ8wSe3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 069/627] mei: vsc: Unset the event callback on remove and probe errors
Date: Tue, 12 Aug 2025 19:26:04 +0200
Message-ID: <20250812173421.942629968@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 6175c6974095f8ca7e5f8d593171512f3e5bd453 ]

Make mei_vsc_remove() properly unset the callback to avoid a dead callback
sticking around after probe errors or unbinding of the platform driver.

Fixes: 386a766c4169 ("mei: Add MEI hardware support for IVSC device")
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250623085052.12347-8-hansg@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/platform-vsc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/mei/platform-vsc.c b/drivers/misc/mei/platform-vsc.c
index 1ac85f0251c5..b2b5a20ae3fa 100644
--- a/drivers/misc/mei/platform-vsc.c
+++ b/drivers/misc/mei/platform-vsc.c
@@ -380,6 +380,8 @@ static int mei_vsc_probe(struct platform_device *pdev)
 err_cancel:
 	mei_cancel_work(mei_dev);
 
+	vsc_tp_register_event_cb(tp, NULL, NULL);
+
 	mei_disable_interrupts(mei_dev);
 
 	return ret;
@@ -388,11 +390,14 @@ static int mei_vsc_probe(struct platform_device *pdev)
 static void mei_vsc_remove(struct platform_device *pdev)
 {
 	struct mei_device *mei_dev = platform_get_drvdata(pdev);
+	struct mei_vsc_hw *hw = mei_dev_to_vsc_hw(mei_dev);
 
 	pm_runtime_disable(mei_dev->dev);
 
 	mei_stop(mei_dev);
 
+	vsc_tp_register_event_cb(hw->tp, NULL, NULL);
+
 	mei_disable_interrupts(mei_dev);
 
 	mei_deregister(mei_dev);
-- 
2.39.5



