Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5223C2F;
	Wed, 21 Feb 2024 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523243; cv=none; b=fPwuQ17+vKIgBbe6XKplwcn/Tj5kJ0d1LvhWHsCXH1DLG7VLcZWL35Qbhc7/HtQLIi3rsx+r3cbwOXZ6tmyOdPemRI+tpkQxwqy/DWlGBS2UCAF3JLGaXc1gsV01IpUbinC1oDaqAzfhjAS4BQMgyF9ZTyVcZV6T3Jc9zRFnDgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523243; c=relaxed/simple;
	bh=UQqFvO/tquahAwYJqVp8OAh1gIbit83RxfJ5C6ymB3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BC+8vI6WwGJHieGkUH+PyZWikct5RjtJbxql3WytsO6mUw94MmWBFOEUlBy0apC3EUOGKdj5QsXn+jRu2S57Ej+8PLTopC0SG48MWAuzG3Zsg28ZACBEPcXjqml25FRsb4u9w5N5btIaiD5pZ1w6pkvkiaW7eIcdIBaL+EvAh9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jN01MN//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jN01MN//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8187DC433F1;
	Wed, 21 Feb 2024 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523243;
	bh=UQqFvO/tquahAwYJqVp8OAh1gIbit83RxfJ5C6ymB3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jN01MN//zKdJBuU33JqQkH/KSkgVOiCJLT7N84CNQV4LClV2aRkDzyvGsXdzb4J1k
	 gn7EE6/oNJcwFfiP1suPq3Ej8o+ZnA+CLsp8q+X8jS4PoI4QxGaesWAaTVR3OuD2Qc
	 2VSlklESj+yWeY7xqXR/9wZCsjU8PzGqjCQTkAI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zach OKeefe <zokeefe@google.com>,
	Maxim Patlasov <MPatlasov@parallels.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 358/476] mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again
Date: Wed, 21 Feb 2024 14:06:49 +0100
Message-ID: <20240221130021.231294642@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zach O'Keefe <zokeefe@google.com>

commit 9319b647902cbd5cc884ac08a8a6d54ce111fc78 upstream.

(struct dirty_throttle_control *)->thresh is an unsigned long, but is
passed as the u32 divisor argument to div_u64().  On architectures where
unsigned long is 64 bytes, the argument will be implicitly truncated.

Use div64_u64() instead of div_u64() so that the value used in the "is
this a safe division" check is the same as the divisor.

Also, remove redundant cast of the numerator to u64, as that should happen
implicitly.

This would be difficult to exploit in memcg domain, given the ratio-based
arithmetic domain_drity_limits() uses, but is much easier in global
writeback domain with a BDI_CAP_STRICTLIMIT-backing device, using e.g.
vm.dirty_bytes=(1<<32)*PAGE_SIZE so that dtc->thresh == (1<<32)

Link: https://lkml.kernel.org/r/20240118181954.1415197-1-zokeefe@google.com
Fixes: f6789593d5ce ("mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Maxim Patlasov <MPatlasov@parallels.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1529,7 +1529,7 @@ static inline void wb_dirty_limits(struc
 	 */
 	dtc->wb_thresh = __wb_calc_thresh(dtc);
 	dtc->wb_bg_thresh = dtc->thresh ?
-		div_u64((u64)dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
+		div64_u64(dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need


