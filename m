Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418A41A0733;
	Thu, 15 Aug 2024 13:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729975; cv=none; b=EvOvDgjsSKoGzdvvpgIP9Th+/n6MsHgEvppK6cRV4I1wgTv7iyni1QZjB8Nyf1zX9KvR7iarmMP3KAYq90RFQAL3RJKtNO2Eqyj8taOYzy/7935Z+5dyvLSnZeCssb8AY5u0dDl3ufhJ88C9afl7hJwO4jQ7hSBcq7D9XRmtrQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729975; c=relaxed/simple;
	bh=cOCamALYCh7n7arrB/2srFbrPuBhjrjGPsd2T+Z9CT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1zeQHXde9Eknyi/ovr7LIz1IbKw6+6x732WageRdGGXHt2tKa+596YQhqoGNwNeudQTJ4gwz4Zz1/kXTKszZvpq6l3TSAoZhzOg9gAS3PD83/63wOGxa1xWaukOGhG6LFC5ixM0zOwZ5RPseWE2xdjCV/SGfIn7SfwK9NhJm7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTTquKId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTTquKId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1509C32786;
	Thu, 15 Aug 2024 13:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729975;
	bh=cOCamALYCh7n7arrB/2srFbrPuBhjrjGPsd2T+Z9CT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTTquKIdE5duqdI0Pt30NRzJXGTEW4c1fHv8tl3K5HK8NJSsxkmP1fvdbwZC9WsC2
	 PNrHoanC8xysTWSKJEWxh89hwUoTBjG67s63/NRIQ5wMMhB8cYtDdO4yg7iKmsLsRq
	 RQQ+anCbKSfI+i5KdBYZY8qh6Td418pLv5q0vf7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 234/484] perf/x86/intel/pt: Fix a topa_entry base address calculation
Date: Thu, 15 Aug 2024 15:21:32 +0200
Message-ID: <20240815131950.443851445@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

commit ad97196379d0b8cb24ef3d5006978a6554e6467f upstream.

topa_entry->base is a bit-field. Bit-fields are not promoted to a 64-bit
type, even if the underlying type is 64-bit, and so, if necessary, must
be cast to a larger type when calculations are done.

Fix a topa_entry->base address calculation by adding a cast.

Without the cast, the address was limited to 36-bits i.e. 64GiB.

The address calculation is used on systems that do not support Multiple
Entry ToPA (only Broadwell), and affects physical addresses on or above
64GiB. Instead of writing to the correct address, the address comprising
the first 36 bits would be written to.

Intel PT snapshot and sampling modes are not affected.

Fixes: 52ca9ced3f70 ("perf/x86/intel/pt: Add Intel PT PMU driver")
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240624201101.60186-3-adrian.hunter@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -861,7 +861,7 @@ static void pt_update_head(struct pt *pt
  */
 static void *pt_buffer_region(struct pt_buffer *buf)
 {
-	return phys_to_virt(TOPA_ENTRY(buf->cur, buf->cur_idx)->base << TOPA_SHIFT);
+	return phys_to_virt((phys_addr_t)TOPA_ENTRY(buf->cur, buf->cur_idx)->base << TOPA_SHIFT);
 }
 
 /**


