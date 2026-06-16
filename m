Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443033CEBBD;
	Tue, 16 Jun 2026 18:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636274; cv=none; b=mPR7a5o78JktsYniR21e/2zc6JsOcH7SXkrfMAzmu0CxgujHVsaelzPBh65H8HVWd26Caxff2EE/yyAcPf0zp9vfJluqR/YmDeKtEaLkD7LriTWJ/uw0r/gqTHF7nwJr0XQNypQ51hDz5adXdMGB89upWwhmgx6Hg7SXCICylkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636274; c=relaxed/simple;
	bh=NgcaKUP7sR6olnuj/krCprQzwRNIf0X4fVHK2+9LYsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KusSRhMxAlUN375Fc2csGiRzmeti3P/H3OGnmpIKGj+2uO2/gH/FVvc52vIKkfWPu+JZjwW7dpS1u8zeUash+VAi26itgrLwBRAEYOT5qS3QllWBukAYjWK1ITLuoVvr0OlwdRJFNtr0Ri+wLq+KDElY2aSnY9dgs1eGqyfyR8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tceWapCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tceWapCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C0D1F000E9;
	Tue, 16 Jun 2026 18:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636272;
	bh=JIPiivryfcDqjbKSIMWVB4yGYQ0ygh2cUqERnMqdzt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tceWapCRwnwqqW7ppPN7byXkjIlKrTaQPXCNwZTlisRq+qeaA/pWHPY9+/X3KrV4N
	 b+lPQaL2+x9iRhkaL1Y/DMJUsxc/drfdl4dM8fvWuln7saCMwDenc4G884Oqz/ti17
	 DysXP+vIWzMFPCdjYRfDxLpYh43L8onSrlBy0fWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 207/342] thunderbolt: Reject zero-length property entries in validator
Date: Tue, 16 Jun 2026 20:28:23 +0530
Message-ID: <20260616145057.825536683@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


