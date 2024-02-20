Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6326B14A4E6;
	Tue, 20 Feb 2024 21:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464408; cv=none; b=LD58BNT4DyzWWc4ukeE71pwehziotqXuG/BpTm3cVQ7EH37ZiYhcns6Ps89oKTyY6e85k7Cmw6ZcbQgZEf437LYEZEswvf/M1uh8QVLMYzaK/eLXTM2bY/4Hu8VHUUQoU3Woi/LGFp4jV83ajGW9uK/MuPNQbwgUsnu3/ksn3S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464408; c=relaxed/simple;
	bh=XONXdUZ8ixJjp8Xz+hcekftA14xAgF1QIqfQmCKx7/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfE2XrL5wLVCz1UM9AnfRSEXlnT9Ol8e30Of5MM0sjTk5TwbruXXZ1jcNSf2FJS8MdhWSNm3LrSRWHTdvVa+t8kaBR2yufq9NRnWqT8NbCwYFk40xTCDBu1RF7dJEbbUvZ7YJSaG6yb57/pKfV3FqAT5nm3iCFw7/Zc35HBAXiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2ka0I5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2ka0I5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B553C433F1;
	Tue, 20 Feb 2024 21:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464407;
	bh=XONXdUZ8ixJjp8Xz+hcekftA14xAgF1QIqfQmCKx7/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2ka0I5CIlgAAb0UbJvC7FQIa8Luj3qvUEPLJhe2R9TBpE/nYFhw+iRFOmsC9Qbus
	 wD5s55zvrfzK4bjjEceJq1Vb9sKlh/5N1/oYGq3yDo4GfLXMy6bSy2a2Ukp7iDQ/72
	 UKt0nSq3NH9nA/+9cft0Y9QOd4tpvjTGP9w/EXgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.7 016/309] driver core: Fix device_link_flag_is_sync_state_only()
Date: Tue, 20 Feb 2024 21:52:55 +0100
Message-ID: <20240220205633.667621166@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravana Kannan <saravanak@google.com>

commit 7fddac12c38237252431d5b8af7b6d5771b6d125 upstream.

device_link_flag_is_sync_state_only() correctly returns true on the flags
of an existing device link that only implements sync_state() functionality.
However, it incorrectly and confusingly returns false if it's called with
DL_FLAG_SYNC_STATE_ONLY.

This bug doesn't manifest in any of the existing calls to this function,
but fix this confusing behavior to avoid future bugs.

Fixes: 67cad5c67019 ("driver core: fw_devlink: Add DL_FLAG_CYCLE support to device links")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240202095636.868578-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -284,10 +284,12 @@ static bool device_is_ancestor(struct de
 	return false;
 }
 
+#define DL_MARKER_FLAGS		(DL_FLAG_INFERRED | \
+				 DL_FLAG_CYCLE | \
+				 DL_FLAG_MANAGED)
 static inline bool device_link_flag_is_sync_state_only(u32 flags)
 {
-	return (flags & ~(DL_FLAG_INFERRED | DL_FLAG_CYCLE)) ==
-		(DL_FLAG_SYNC_STATE_ONLY | DL_FLAG_MANAGED);
+	return (flags & ~DL_MARKER_FLAGS) == DL_FLAG_SYNC_STATE_ONLY;
 }
 
 /**


