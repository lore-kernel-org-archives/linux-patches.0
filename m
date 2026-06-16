Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A76466B5E;
	Tue, 16 Jun 2026 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634285; cv=none; b=DWKoARFej0pg+snH+xTqXSpvctn9jD66qqJBhT4cx3hExUqi+77zh/h/yGEr6zQYFtiM7HRorQpwRaHMjB0RsJC1Kt/Uz4vhSLTK+Ap6I83EK6C15BTLxy74QBHDUx2ZwVCn+l59otY6uH3w0vrZ84pYqHi3TSQDSoCbgjuiJfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634285; c=relaxed/simple;
	bh=GM57RWNmYl3mRUe/WWW8d29c7+I+xWIqWsdeemkI2Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2+/Q+qxYUiivdm3apYRQEtcG3Ws2TxrH0+yQuWtQ+R6zrgPR1DIQNRhfRNxGtCguM+r553M7Om5c9rQj/HtMiagQUKXSETv8Rvsabl0BdCwU8qvNRBdn+fA6EZM6iu+mdFrryL2rPmKl4scOi0UGawTpexek8B5Yfd50/76C70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQVS2w+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQVS2w+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B151F000E9;
	Tue, 16 Jun 2026 18:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634284;
	bh=aP5FVIaSqofRs/jnw+5pCloYQs+VJgrKb2KFV95PTL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQVS2w+Cvr9RtuDpPe9XZVP/4OZ9aKUlGKqGQY2qhRotU3PQFCO8ljc7ueTSX+/0N
	 ZwiwCQwNOsg0gj0EIW3qpn86U9+BqGtmkh4v4H3JRDU7BvaAKtZCz1obQVemX4J97c
	 yzTpZA4oyHL03dC/1rNhUCeerp3Mw2imtD9wxNSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 237/411] thunderbolt: Reject zero-length property entries in validator
Date: Tue, 16 Jun 2026 20:27:55 +0530
Message-ID: <20260616145113.442865629@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
@@ -59,6 +59,8 @@ static bool tb_property_entry_valid(cons
 	case TB_PROPERTY_TYPE_DIRECTORY:
 	case TB_PROPERTY_TYPE_DATA:
 	case TB_PROPERTY_TYPE_TEXT:
+		if (!entry->length)
+			return false;
 		if (entry->length > block_len)
 			return false;
 		if (check_add_overflow(entry->value, entry->length, &end) ||


