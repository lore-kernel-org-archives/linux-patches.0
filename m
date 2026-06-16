Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08312C0261;
	Tue, 16 Jun 2026 18:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635742; cv=none; b=SOGYtXFrdJQvhNlaWQvHpeF2qE+Duo3Aql60e2eGa4dFjPpwiGsLbTFf1IEF4o7eruniu/mAKKZlbtpN5MZpAjXDtEYEq3Ar7G+LwEZ/5JWqp14H6Q9HmhtD6wTmcCjGPJky0XKDOTLuSShmO5YrhZGwNK2lF3OpocuAS8inM6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635742; c=relaxed/simple;
	bh=coukqfV4l5u8bEY1ZOQc+tvIkvI5Go2t02by4KoJwx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQqyrjSLfXkBkcqoQ7DLAwhhvDd7CTJ42T6WuXTonJj8scHyGaIy8/CHfDk0t96THolNL4xYC6tVpX/nmwVGEEf82dXcu2+/iPwVL/iekyuWowUw86Nlo2Ce8PGUbs7tSvipnW722v1OXgPOBROkdqJ3GMLhZ+QrrL5dH2G47kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoVap93U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoVap93U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893571F000E9;
	Tue, 16 Jun 2026 18:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635741;
	bh=2+NVpukFB46Qi5dBLLbsdhCNvpjBOo+HQdFqQU4JDIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uoVap93UqFqELCjBfO6JwHxBw0w8BOQ6aOaLYLEzfOp13zTyiqUQn12kxGK/5bjVy
	 WBNU4ngx9RpNhGR6zl/oLn+RcDW5JugNq8aYVpidus7e56M0N2T/8RMzHEaKlCZm6U
	 03RJuxjY4gU7fQ669d29GkqLQ5F75ractUb1E2JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 106/342] thunderbolt: property: Reject u32 wrap in tb_property_entry_valid()
Date: Tue, 16 Jun 2026 20:26:42 +0530
Message-ID: <20260616145053.167811330@linuxfoundation.org>
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

commit 01deda0152066c6c955f0619114ea6afa070aaec upstream.

entry->value is u32 and entry->length is u16; the sum is performed in
u32 and wraps.  A malicious XDomain peer can pick
value = 0xffffff00, length = 0x100 so the sum 0x100000000 wraps to 0
and passes the > block_len check.  tb_property_parse() then passes
entry->value to parse_dwdata() as a dword offset into the property
block, reading attacker-directed memory far past the allocation.

For TEXT-typed entries with the "deviceid" or "vendorid" keys this
lands in xd->device_name / xd->vendor_name and is readable back via
the per-XDomain device_name / vendor_name sysfs attributes; the leak
is NUL-bounded (kstrdup() stops at the first zero byte) and
untargeted (the attacker picks a delta, not an absolute address).
DATA-typed entries are parsed into property->value.data but not
generically surfaced to userspace.

Use check_add_overflow() so a wrapped sum is rejected.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/property.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uuid.h>
@@ -52,13 +53,16 @@ static inline void format_dwdata(void *d
 static bool tb_property_entry_valid(const struct tb_property_entry *entry,
 				  size_t block_len)
 {
+	u32 end;
+
 	switch (entry->type) {
 	case TB_PROPERTY_TYPE_DIRECTORY:
 	case TB_PROPERTY_TYPE_DATA:
 	case TB_PROPERTY_TYPE_TEXT:
 		if (entry->length > block_len)
 			return false;
-		if (entry->value + entry->length > block_len)
+		if (check_add_overflow(entry->value, entry->length, &end) ||
+		    end > block_len)
 			return false;
 		break;
 


