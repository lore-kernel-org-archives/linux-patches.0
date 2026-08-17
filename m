Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7583DAACA;
	Mon, 17 Aug 2026 14:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977129; cv=none; b=ZellQrKGeZO1i10VFwYh/IBK4URLD9/F7vJyBIdoib8wIhHpOOkZPCKI7LHYXXRpgxxCWNMfkNoyBuPmcs7crmg5nklnr6snByATiQ+8fvk6jOgq+hLFYHdZF3aPy/d9KnCW5h0Awl9Jigxl2P5d7X2V4oDnJNM8+iPJM+wvNI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977129; c=relaxed/simple;
	bh=zkSsWYSHeRxG9D9/dGLwQipeCQD1FaqigcdRkbZqLfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=La4qLRWS0H+HnnRnIXz86EMzkM9UGsRd+NVY7MMtp1llhL8pqrLLecu0HSPuPNYg5NWzG+TJ6Y3bGxre4rC5DjRQVm4+Zc/FItPrpbh0jKtIv3skxhTOdrN1RJ7cQ9pFr9VReGTGP8+MvOjVHSwJ4bvomYZ732Fxg3GcQt14pbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=157WCGIh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="157WCGIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1BD1F000E9;
	Mon, 17 Aug 2026 14:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977128;
	bh=J2eGI0bU2V8SLP8nuw9WljxKH8cjXij8TF3QDA5+Ml0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=157WCGIh/Ot1K9v4SnDO5MHvy8lAKd9JhWT3SEieDHXgnt+JaZOdUMhNSF3a5jjF8
	 bMF2Slwm8R3SRsMMXnBrHWUrBqDpeGen0iu8qTh4QIQnyD1Iif7I5dV6Rwrf6SHD6x
	 YtsKXSpJgiIXapH2UGwyoqhu8LWVpZunW7mlUrjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Temerkhanov <sergey.temerkhanov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 5.15 221/456] ice: use READ_ONCE() to access cached PHC time
Date: Mon, 17 Aug 2026 15:30:11 +0200
Message-ID: <20260817132548.819371280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Temerkhanov <sergey.temerkhanov@intel.com>

commit 2915681b89f817677ab9f1166d95b595bc144f5f upstream.

ptp.cached_phc_time is a 64-bit value updated by a periodic work item
on one CPU and read locklessly on another.  On 32-bit or non-atomic
architectures this can result in a torn read.  Use READ_ONCE() to
enforce a single atomic load.

Fixes: 77a781155a65 ("ice: enable receive hardware timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260717185340.3595286-9-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -391,7 +391,7 @@ static u64 ice_ptp_extend_40b_ts(struct
 {
 	const u64 mask = GENMASK_ULL(31, 0);
 
-	return ice_ptp_extend_32b_ts(pf->ptp.cached_phc_time,
+	return ice_ptp_extend_32b_ts(READ_ONCE(pf->ptp.cached_phc_time),
 				     (in_tstamp >> 8) & mask);
 }
 


