Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEBD3A5E91;
	Tue, 16 Jun 2026 17:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631931; cv=none; b=Ymh5cYRHYpu+PjWcImPZweHfenZHEkD+R3sByBTSiU6pl2j5ctUCtfHXsvA0slwCKRb/Q3ArD3mmSp6kbts3xGTTVL69QW8piU6rWeZuzdRFdMeVjcfOaDqX4wUrU8cqFKRLcAYs3PAVZEwyDa0EtttQNeINwwItBCe7/QB2LlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631931; c=relaxed/simple;
	bh=QMnOL/sTsvix33QqFEYG4XujlZZBH+8J6evCZO5JvaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maEn6OB6YzI4HVp+hSqZdbpKb/+NCdU1M2CN1vE+LXupEfRo7Evpz19s7bbg1apFg+QTShviLTMqBJ8sEuqD/MjJCI6839jqnwpeLiAwmW57yJDIKqy7GXtobVQOFNcUhtimgysmRACdkXKb4f3mAegMKu5WwgB3+UcYLb7bUKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MA+Rn9Qb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MA+Rn9Qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8041F000E9;
	Tue, 16 Jun 2026 17:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631930;
	bh=t7vRQqh9BFbrici1yzMlcXHDY1SXeUVo6oyxoEDgVKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MA+Rn9QbtbLNepOAvvdMqn5YBTARi1HHdC60JZAv7Vo8LayObBw8UvKuHa1BkqvWW
	 IAAc5mT3LGNg3h+HuAmasd1GC7omLVitqyq6quGtC18KCVB1gwwoK4sp5Z00vrgKx8
	 AgqyylPPy0SygqaYhU1UND+eMaacLlSVpVA64DsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 315/522] thunderbolt: Reject zero-length property entries in validator
Date: Tue, 16 Jun 2026 20:27:42 +0530
Message-ID: <20260616145140.600842268@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


