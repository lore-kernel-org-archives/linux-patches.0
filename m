Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27611A6166;
	Tue, 30 Jul 2024 16:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357950; cv=none; b=r8Nt/aMKTYxIUoQ6upjRn3ojuJJXMv9Yl7vFvYrDggrcfJRQM7OxhjzNdisz6wEHbBwtvu0/Mrk/qNxkv1FdHj7UKaNc0ZRg3sYcMNm/YBzy0M43vk+0mag4PeVsknU8Moxtg/Fs2V42r4vlT+OLNyAMMr8Rf1pGkfQjNdrb9q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357950; c=relaxed/simple;
	bh=/qUSFuzHKsntY1NmORap4DX9PS3fQMh7iJ6dnJve9TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIiX3ai1uV6ZVLoFQgCprzdm0+Wfd5i8n9zLRc8KitnL8psdXtNpd9NGacvxPKD8o9vwuhOgegXPQ3YPt2dpCtsnUo/J/EOGzl4rdXmUsh1RrGzxb+SrbyRH4Igq74DKgxCEBbfWRGc4FNmvOoM4SpunQKHvm7iYSrDPtJbl8Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8NstoJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8NstoJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62820C32782;
	Tue, 30 Jul 2024 16:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357949;
	bh=/qUSFuzHKsntY1NmORap4DX9PS3fQMh7iJ6dnJve9TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8NstoJnDOaUKgeOeSBJ1C99T18phS6gGxDyPt8NpssD64zBB27eeUo4h5K/l/9PU
	 +1TtfsW4EicqV9SvxczPmHYjNVNlgpnFI0fTI5T/RgF6P+ihwu6Ex3bBC2D0bbJOx4
	 ijnY2blK0gCRakbNySRm9iG9UIwooVwCehMhSmlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.1 342/440] devres: Fix memory leakage caused by driver API devm_free_percpu()
Date: Tue, 30 Jul 2024 17:49:35 +0200
Message-ID: <20240730151629.171543883@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
@@ -1221,7 +1221,11 @@ EXPORT_SYMBOL_GPL(__devm_alloc_percpu);
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


