Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BEE261573;
	Tue, 11 Nov 2025 01:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824594; cv=none; b=X9LpOo2UqVclxuPfOxUJmTaR082Rg9sP2qeMu/31TbTtj0XF7SETNn8xQP491O09BVU10T9pKTeEnltOsMreyKo8ctRxxhyT/t8+FdM+GBC+kDRB+oTl9mxP4nERi/eLYiYY04kiyg20avtVatfHNIHb9tuUCf8WMFrJNZyOOU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824594; c=relaxed/simple;
	bh=FkpWNA4YnmDg//sMAnbQWI6bH15ZoaLi8Jcou8mSh2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/UKAvNAO3vnPmsvTLm97Se0cg2qvT6JXNEtB+qnEX3emqjRnNnrQBMjihXdAPnSUfEJM4HWIrlmxRqMZw3UBMkqSuFnNC31s++3SFwW4x3QvCVhPPfPt9FmJBKwtqCxxlunV7HMQJ2tFFIAEgKJHgY057bwplWLW/tKFZfm4iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVLWWtfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVLWWtfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CADC116B1;
	Tue, 11 Nov 2025 01:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824593;
	bh=FkpWNA4YnmDg//sMAnbQWI6bH15ZoaLi8Jcou8mSh2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVLWWtfwSKEhAOqQZF+45Sx2g+VM9Ln8mpfSBcxvxn1qbJm2+AV0U1VhSRD5NtUCr
	 FYjGhieSOuS97BiEI4TWZXidWAi4uaSuP5uxFH+RJV6hB2iMN/VLbSTDBT/iFx3iKJ
	 13j28wmPxGsyRt53rhzTk1jCel6yL430bbGEfsZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <ysk@kzalloc.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH 6.17 530/849] crypto: ccp - Fix incorrect payload size calculation in psp_poulate_hsti()
Date: Tue, 11 Nov 2025 09:41:40 +0900
Message-ID: <20251111004549.231745616@linuxfoundation.org>
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

From: Yunseong Kim <ysk@kzalloc.com>

[ Upstream commit 2b0dc40ac6ca16ee0c489927f4856cf9cd3874c7 ]

payload_size field of the request header is incorrectly calculated using
sizeof(req). Since 'req' is a pointer (struct hsti_request *), sizeof(req)
returns the size of the pointer itself (e.g., 8 bytes on a 64-bit system),
rather than the size of the structure it points to. This leads to an
incorrect payload size being sent to the Platform Security Processor (PSP),
potentially causing the HSTI query command to fail.

Fix this by using sizeof(*req) to correctly calculate the size of the
struct hsti_request.

Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>> ---
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/hsti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
index 1b39a4fb55c06..0e6b73b55dbf7 100644
--- a/drivers/crypto/ccp/hsti.c
+++ b/drivers/crypto/ccp/hsti.c
@@ -88,7 +88,7 @@ static int psp_poulate_hsti(struct psp_device *psp)
 	if (!req)
 		return -ENOMEM;
 
-	req->header.payload_size = sizeof(req);
+	req->header.payload_size = sizeof(*req);
 
 	ret = psp_send_platform_access_msg(PSP_CMD_HSTI_QUERY, (struct psp_request *)req);
 	if (ret)
-- 
2.51.0



