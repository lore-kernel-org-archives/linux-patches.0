Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABE51A76B4;
	Tue, 30 Jul 2024 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360363; cv=none; b=IfgHypgyH0l5JOiaTZbuPMlsyXAbstvFR4OcWzTYxVjejuEqfub9+SihFAmL6KhVO/BY1VaX3ZoOzYHYoEoC26zA08web72XEfGpNZguIFlo6LCafSUTvnTUVjXIIGmIYawSb0fclOyCXR05TR3dGGxS2e/CcUTFjO0k0N20f6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360363; c=relaxed/simple;
	bh=6D4gTQXbLee/VikLGjTd9GLI+CgP8shYVGX2obqWX1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/NC++8FQvfDllWztAaoE3etnpDnU6zfyh1Pz6LVseoqsIgBkh44LBPor8MoX0PfVSOPlU6clf7cFMx4m0MtZ5YnRSRgs5kOA5puniNl0wWZJunTAGHiwmh0EC4U+I+m940vT7wT23cu17+BIXEd89I63sUTyXGBzpv06voLKaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/XuaCKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/XuaCKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A750DC32782;
	Tue, 30 Jul 2024 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360363;
	bh=6D4gTQXbLee/VikLGjTd9GLI+CgP8shYVGX2obqWX1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/XuaCKMYlbD5bcoqdlSHC/rG3rjljpWC+u//eklIQkHSAyuLuWNmREUl6aQqkTWn
	 gPfutQG4qOB45nODpmLANBIvXDEERHGBtKPUZhOeKMdU5kLS6naQNrnEDMHj0MNRHH
	 aKlP/tFfbPOjWsV7KcrbKybWaWqq/2y3L+djj97Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.10 676/809] devres: Fix memory leakage caused by driver API devm_free_percpu()
Date: Tue, 30 Jul 2024 17:49:12 +0200
Message-ID: <20240730151751.603986620@linuxfoundation.org>
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit bd50a974097bb82d52a458bd3ee39fb723129a0c upstream.

It will cause memory leakage when use driver API devm_free_percpu()
to free memory allocated by devm_alloc_percpu(), fixed by using
devres_release() instead of devres_destroy() within devm_free_percpu().

Fixes: ff86aae3b411 ("devres: add devm_alloc_percpu()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-3-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/devres.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -1225,7 +1225,11 @@ EXPORT_SYMBOL_GPL(__devm_alloc_percpu);
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


