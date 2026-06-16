Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EB33A16AC;
	Tue, 16 Jun 2026 16:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626131; cv=none; b=BkuLdsPRCMyoUyo1dmJH5nziju6Oa4gcSciHauD2o68d0w5JQTyRArNFcUvosaTO2Si3Du7g1X7BNrOCX06J5qAdb5YBWL0wj+pHGqbvGsOoKKwXzWrXqv6gMn9/FCvySwwLnl8FJUC+ufbEiGOxXDwDLZj/9rFEDk+NcSFOy/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626131; c=relaxed/simple;
	bh=4S6QPfxsabWBRmExlZKjxlJTMHF91jwU8MmXMYIxSKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHVaI/+IgwPBWry5locDfieS7PL2trGa1ZsKZuKqDmgKfJGjW4Yc91iFAXbXj3jmwamUioS8LccpKMfug8P5c9COA6LLHj5o1QDbetLL47KYiZFpPmjK7H3ejWaGlrbB6bltVwcZDXeuqZV4sR+e/SVL1v5UD4qiewg3xaqXDfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLY00wyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLY00wyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7AF1F000E9;
	Tue, 16 Jun 2026 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626129;
	bh=UDFzujRvQqALFGstzATz6DN9/j7W9yyAGjTg8G2FV50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLY00wyWKC8mO2SzNfh0HLN0iqT1/P4w6JbwI8He6yvhV8lqjTFheyrA8Rn5JuYMG
	 zMZEZ9xNiiHGRGxn3OIOlSvNggtLfMrE6yTESF3c5rLPlglWza6uykOOU6uf2FNwHT
	 CeXBIzAGj7mZyvq+7XMuQZVJiPaK8KOi1aTv6d/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 269/325] thunderbolt: Reject zero-length property entries in validator
Date: Tue, 16 Jun 2026 20:31:05 +0530
Message-ID: <20260616145112.052494926@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit cff8eb65d1eafe7793e54b4d0cf6bf831644630b upstream.

tb_property_entry_valid() accepts entries with length == 0 for
DIRECTORY, DATA, and TEXT types.  A zero-length TEXT entry passes
validation but causes an underflow in the null-termination logic:

  property->value.text[property->length * 4 - 1] = '\0';

When property->length is 0 this writes to offset -1 relative to
the allocation.

Reject zero-length entries early in the validator since they have no
valid representation in the XDomain property protocol.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/property.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -60,6 +60,8 @@ static bool tb_property_entry_valid(cons
 	case TB_PROPERTY_TYPE_DIRECTORY:
 	case TB_PROPERTY_TYPE_DATA:
 	case TB_PROPERTY_TYPE_TEXT:
+		if (!entry->length)
+			return false;
 		if (entry->length > block_len)
 			return false;
 		if (check_add_overflow(entry->value, entry->length, &end) ||


