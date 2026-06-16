Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DEC449EA8;
	Tue, 16 Jun 2026 17:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629793; cv=none; b=AizuMuVMhBuOUJQj0XEElhW6Z6wKbdVt4P3qld3U1sXDYF0PUu0S/JQffV24/WaKzjGJpi5alB32NUl3q43E0akVYRy7AIb45iFKMSEmbIgpcZi4TQBBKKoVtxiHfB5dtgh0AWn1VAVVifyEayt7QyG5tuGi7LOiYurExfI42HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629793; c=relaxed/simple;
	bh=CbTdQqpZQ5EDnhxAB/L8GMTOCgpetWO25XMmbyJdd1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkgTqzmK59cvy5T+4oNlYXXus5rPGbJuWriayry3asdLEm0n9RkhyWWLGOvTMqhWfSbRxDhcIlQ7IGiOFvG0WAxl3RzE2fog0HmWsQ04A464kSjUt+UD4vqCnO0Rm3CB6ftDRrxYGH8bTS6uwEGgan21a5Otqp9Qw4lNoy9tQR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akYuV5F2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akYuV5F2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7616B1F000E9;
	Tue, 16 Jun 2026 17:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629792;
	bh=UymSEn4PTHCEJIwsxUHj8xD5/LQMleziPtWsyPPQbNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=akYuV5F2ytpbMtcd61hYpzjOkV/tjXVN4c7Dh+h4M++cS5up7Gii+CHCj5WHnsgsq
	 ZM33/iP7L4KoIwUlW3xSM9oRvW1HYLfjg/TS5iWAVcHV/TB0y0FmrZQj5HTljEz/VU
	 dBp7NpnZdZZKK+agCMk/eWSDjXlrhC7OVqNzazao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 354/452] thunderbolt: Reject zero-length property entries in validator
Date: Tue, 16 Jun 2026 20:29:41 +0530
Message-ID: <20260616145135.770331268@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


