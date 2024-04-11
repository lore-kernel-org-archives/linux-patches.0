Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C441B146A8D;
	Thu, 11 Apr 2024 10:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831178; cv=none; b=RRuUioqi+XDdJEQaCRgAiw8kWjcGX7IdXRASwIKLDxIgsDKZsUZa9Ic6Jvnh1R83HuU8Zc9Zmse3n9/iUnf9hEjV5obR1MWBzKQ2n0fPfzlwUhP8i4tWaZdlTToQl8hW6P7HTV/NkNIQZhBaWYEQRcHXMUVsrb3nj5k9yHvapro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831178; c=relaxed/simple;
	bh=pUGpmYTftrRK0ETT3jPG4tqfG8NDSM+XDTrcrsA609s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFFaZdIWTPcadpObZL1MIi426PUCMxZTFHhhKELi7NujChHIoX7RJ4gTbS+8RpLNsLlAFUtYyq/fwEbnqMwb+zbZ5OCe1mRWABOd+Thk+y8LeQNugnuspFAasYKsEbo9uBaVO7WS94eMVuOiuBSmBpKs297UsEqa4pQofGQ6wpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlL4/xd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlL4/xd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21241C433C7;
	Thu, 11 Apr 2024 10:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831178;
	bh=pUGpmYTftrRK0ETT3jPG4tqfG8NDSM+XDTrcrsA609s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlL4/xd2ZYeSsbHg4cNi9RfHOqQZon/iiOUIRMWNJcxCGRmyfaOe2TNAZfse5KSV8
	 geI5XQ7tbEX51v0+EhYJx+J4ZnWfqc2BInvd6dw6S1649nQYmG+NsDosQoTDu4kplQ
	 o4m9VmhcWuJizS2G907dtpicErsQeZfoXW1rTVsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/114] overflow: Allow non-type arg to type_max() and type_min()
Date: Thu, 11 Apr 2024 11:56:02 +0200
Message-ID: <20240411095417.930153947@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit bd1ebf2467f9c5d157bec7b025e83f8ffdae1318 ]

A common use of type_max() is to find the max for the type of a
variable. Using the pattern type_max(typeof(var)) is needlessly
verbose. Instead, since typeof(type) == type we can just explicitly
call typeof() on the argument to type_max() and type_min(). Add
wrappers for readability.

We can do some replacements right away:

$ git grep '\btype_\(min\|max\)(typeof' | wc -l
11

Link: https://lore.kernel.org/r/20240301062221.work.840-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/overflow.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index f9b60313eaea2..e04f679476473 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -31,8 +31,10 @@
  * credit to Christian Biere.
  */
 #define __type_half_max(type) ((type)1 << (8*sizeof(type) - 1 - is_signed_type(type)))
-#define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
-#define type_min(T) ((T)((T)-type_max(T)-(T)1))
+#define __type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
+#define type_max(t)	__type_max(typeof(t))
+#define __type_min(T) ((T)((T)-type_max(T)-(T)1))
+#define type_min(t)	__type_min(typeof(t))
 
 /*
  * Avoids triggering -Wtype-limits compilation warning,
@@ -130,10 +132,10 @@ static inline bool __must_check __must_check_overflow(bool overflow)
 
 #define __overflows_type_constexpr(x, T) (			\
 	is_unsigned_type(typeof(x)) ?				\
-		(x) > type_max(typeof(T)) :			\
+		(x) > type_max(T) :				\
 	is_unsigned_type(typeof(T)) ?				\
-		(x) < 0 || (x) > type_max(typeof(T)) :		\
-	(x) < type_min(typeof(T)) || (x) > type_max(typeof(T)))
+		(x) < 0 || (x) > type_max(T) :			\
+	(x) < type_min(T) || (x) > type_max(T))
 
 #define __overflows_type(x, T)		({	\
 	typeof(T) v = 0;			\
-- 
2.43.0



