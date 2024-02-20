Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC52F151CC4;
	Tue, 20 Feb 2024 21:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462813; cv=none; b=mKsxQ1VkqlPyJR/LfGHcwNGbaqk2Mpc50VWSJLfYvmqK9AYqN/TAsqE683w5B9ALr+AQ3N5UdDjzEzZMtPBWWYLNQS5FslvVSNmzPxRowcGKVCHVM24rX9ljWZsq2VVSDx8q23Ue3GLxxFcmsiVN7nJ30bpIBVtpigiFoG1Kc60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462813; c=relaxed/simple;
	bh=V+64sU6BFCb7hY5FKwGlt16KMRuYqOoUjBbEHlne6AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8iatzD7R2KFgOpC1HKfC14uk8wfZ1DOIZXnL6Z3jS7cNqH8F+bzPVJeWewo3NzcitEna9ofKqRZdIE6z6/UDjzRgle87UnoFA3RlBQq12UMzSJ0TEfRUHo7Zqvv02EtZOjL3eoGj3+Jx/X70/rzMQIGgQ1XE2k+AhA/YAY8NTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUzRGBki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUzRGBki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF998C433F1;
	Tue, 20 Feb 2024 21:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462813;
	bh=V+64sU6BFCb7hY5FKwGlt16KMRuYqOoUjBbEHlne6AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUzRGBkiu/cgr03JHkrQfP8kUwXdAt/UZ1ZItR51URBKXf7dcjLQfV0+ndgyENSFi
	 WxjRK/nxl5VlB3cZHvEtztWs8YdsNxPXvh/rIqZL6+bCq1mOBLuF821bzlY3aN2/XR
	 o1t9lwDt38kiGH5k2od+61HdmBKCirWBGvkzsyrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zach OKeefe <zokeefe@google.com>,
	Maxim Patlasov <MPatlasov@parallels.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 037/197] mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again
Date: Tue, 20 Feb 2024 21:49:56 +0100
Message-ID: <20240220204842.189076119@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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
@@ -1526,7 +1526,7 @@ static inline void wb_dirty_limits(struc
 	 */
 	dtc->wb_thresh = __wb_calc_thresh(dtc);
 	dtc->wb_bg_thresh = dtc->thresh ?
-		div_u64((u64)dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
+		div64_u64(dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need


