Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B8444CAE6;
	Tue, 16 Jun 2026 15:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624356; cv=none; b=KeXrzmPGbVLafdFHIoEXpFQqyHqcuG6KmYae65IbWM0hf36cORV5w90egWa+8FVGvBOfjME/gr8Xkx7Q3IqhJpDN8gydHazesmLCGW77pWUoRRARbMskTwsfsr+Qfp6FrdNlXKZPs99NZByX9KWNtzTIc+ex8js7O7SHSLlJXj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624356; c=relaxed/simple;
	bh=ZJRFeh8qFIvdPf0JGbaBoPdQvOTfZdSOyl9yuXThNOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKgWvY4N1fQOgUI8IvVd4n21HUr41HyOXu8moRe8mc37nGTzaA4OHSizzeTTXQ1xAkkGCMsnJEA4BlTA1HPtO5RbGWUPWMGLjTk4QsEYfidZ64lt1K02jwY+FCx59CIcRBymIkohP2xqNt7tKDWQa3o9INURVPpGdsWsM7A6foo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIeMJf6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIeMJf6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1FE1F000E9;
	Tue, 16 Jun 2026 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624355;
	bh=YGuLDHactLS0tlS49ml3TIFbS+z0xWh6PdHv4hd72zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIeMJf6bg0Dlg55rOOkkp6dG5go1JX4q7c1xdH83qfj4kn710J8nBLsSfVEp/wb00
	 x+9g82C7HYM0CliXlAIdjVcKWmdNrCC3zbvStpxqpECFIDrSws6cL22wrZIgnftj9V
	 ZKAgWFQQ2y/+/bFYt30QPz3qN/sIUidChm9TZbsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.0 320/378] thunderbolt: Reject zero-length property entries in validator
Date: Tue, 16 Jun 2026 20:29:11 +0530
Message-ID: <20260616145127.092456847@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


