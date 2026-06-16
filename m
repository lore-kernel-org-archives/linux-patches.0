Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F53046AF3C;
	Tue, 16 Jun 2026 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627637; cv=none; b=TPj3F1lT0KtnDjMcJna26Zv4HGN3egsNruT57Uc3CZzk3fQkHfh5uVlFeJy97e/QHj06jowyhh1pjZJTojnqcrE7CrxvlmD9jHOx0fWXRGUjJ3wsMUyv3kVgqQOXt3kef5pT2T/P8EwPKi1MeqcDyqu8PkPRPK2xXhK8rrw/5XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627637; c=relaxed/simple;
	bh=cPHEhziBTErVOfFPLu+08+1KGq9HLu86gn3Qopj3smo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxmYZWGIquVFGm/JmHkKehQqem6W3+ILM3aOduLMhen8Ps7dexnCmHgDin6f6eUPETeG9LB898QpdPUK8GclIVYUAMc83F/yt/SVyn3iVwApasdviKTQ5+w182pzH+Q97pLAR0ZJCWMUHMhjRsMH7eYdwEk0dWen7mT/BXsRn40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MF1KTEGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MF1KTEGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7152B1F000E9;
	Tue, 16 Jun 2026 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627636;
	bh=aM+SPBPQSVpqYHsyySMRoRYxoXlW1mZdtM36nVyIGsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MF1KTEGHdF128svEy6H1ou2sY3167UWYZYEnrU+h6V8cMOET6Jm7Rs+gkBWjV/EYA
	 uaaFm3RvocqSrjcYJ7FuSabPaaEXArjSPqvR3D5t6sLoEVOSJ5UWF8+qbd03ZGj7bA
	 XRozeXmLTkPsMv19qBL+x0mnr7Y05VPzUXOsFiOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 202/261] thunderbolt: Reject zero-length property entries in validator
Date: Tue, 16 Jun 2026 20:30:40 +0530
Message-ID: <20260616145054.412825431@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


