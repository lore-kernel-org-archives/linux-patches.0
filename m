Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7A4342506;
	Tue, 16 Dec 2025 11:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884866; cv=none; b=UiO38vj8NrmDgYAImp3iNie82dJ1g88s6CsToiO6lbBwGTT2782kmwZ4ntAB9eCOdtc1TWHoRHBD7zF1vQQW7/4gnS6qPRDumjETUVD9c4fJohL6bsfj7kUo1DXggbLtwUckzmAUNlfHLbC2b9YnT0NvKap1jO6szcvVlH27dNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884866; c=relaxed/simple;
	bh=0zD8wkWbcnmyGTTC1ttsn64tgn+s5VKsFfG/WrGcTek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATFvKMUuCvARzMYQ6brNU1Y47cQB4MkoKduYi9Vfmsw3rQp0TCFeeUJidTiRD6mLj5oMTyJQZJrau8fo/5B3jMfBL9EgG44vgiLktemRTaA+HIZIorzMJa0KQJyr1FBCOMbbIyBL2IF1PwEuv7b5tr2OMxkHXYSUf7MmyXS1HjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5InvQup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5InvQup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4C0C4CEF1;
	Tue, 16 Dec 2025 11:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884865;
	bh=0zD8wkWbcnmyGTTC1ttsn64tgn+s5VKsFfG/WrGcTek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5InvQup9zNchImatmv0ch9dykDTFrxJEL0fbHb/C4aDhMtDjF6+obCfmk3GXVQOY
	 ya7pF5V4rhSfDsRdoxmEHIBs9s+MQzKHjmVFHw7ALRln4mH9hyAwhICEMuP61H4qNY
	 /YA7r+fxdBuj5Z+5tfrlD4x5rwm1Ed4WglTxFzF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/354] fs/nls: Fix inconsistency between utf8_to_utf32() and utf32_to_utf8()
Date: Tue, 16 Dec 2025 12:14:42 +0100
Message-ID: <20251216111332.323465799@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit c36f9d7b2869a003a2f7d6ff2c6bac9e62fd7d68 ]

After commit 25524b619029 ("fs/nls: Fix utf16 to utf8 conversion"),
the return values of utf8_to_utf32() and utf32_to_utf8() are
inconsistent when encountering an error: utf8_to_utf32() returns -1,
while utf32_to_utf8() returns errno codes. Fix this inconsistency
by modifying utf8_to_utf32() to return errno codes as well.

Fixes: 25524b619029 ("fs/nls: Fix utf16 to utf8 conversion")
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20251129111535.8984-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nls/nls_base.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index d434c4463a8f7..a5c3a9f1b8dc5 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -67,19 +67,22 @@ int utf8_to_utf32(const u8 *s, int inlen, unicode_t *pu)
 			l &= t->lmask;
 			if (l < t->lval || l > UNICODE_MAX ||
 					(l & SURROGATE_MASK) == SURROGATE_PAIR)
-				return -1;
+				return -EILSEQ;
+
 			*pu = (unicode_t) l;
 			return nc;
 		}
 		if (inlen <= nc)
-			return -1;
+			return -EOVERFLOW;
+
 		s++;
 		c = (*s ^ 0x80) & 0xFF;
 		if (c & 0xC0)
-			return -1;
+			return -EILSEQ;
+
 		l = (l << 6) | c;
 	}
-	return -1;
+	return -EILSEQ;
 }
 EXPORT_SYMBOL(utf8_to_utf32);
 
-- 
2.51.0



