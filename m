Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F347132E121;
	Sun,  7 Jun 2026 10:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829587; cv=none; b=IKTopjiK/TF+lrH7G9gxLXzvpbc4wi7EtmNB6e5wsLA7hlQUzdkbi9GEtcLar3HfexRi2SGZRjPw5aLU40RseXTgNKSaDWiapeYH3qjCib78/U6imlbas/iTHJvA3CmHVcdGaYWOTmnUkLj3NqRN7Kj/JGIu/G8Go36VvpywmmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829587; c=relaxed/simple;
	bh=ea2SXpBFddUKQHh9+10Gz/cBBIKJclAJKODgEqVky+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjxtXquGLXjMPhGb7CHMeki+a2Mj2/R3PyxYjVXof5y+BBZKczUMoF4ADA7jJQed2JTWPG8AjP9RajdH1so2iBEhU0yra3xeizitwZlBKhkXu+WE1QG/QaldAvJ6ZVj4AB7/rnZv/amaOglsPb57Ki843PDITPDABpvK+2kRk2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNCLirjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNCLirjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD831F00893;
	Sun,  7 Jun 2026 10:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829584;
	bh=EH0E+JGxhnZHJiBYvBca5B7nerg2n3X/I9fi7mqCHFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FNCLirjM/zIlHwn3N4eLmdItY6SgR26z1kV9FyzjP/9QniPmeDAT/+IcTjgYbtDV0
	 PrSPlkfDZ2L5KAklUKUDU7ld4egaf7SHJlYvyJIXYxvhDwPP+40d8phlhaJIleuEsv
	 SLiXx8wb1ye9JZYrSfttZWOGY3jwUf4kWxFK4Nb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 237/307] thunderbolt: property: Reject u32 wrap in tb_property_entry_valid()
Date: Sun,  7 Jun 2026 12:00:34 +0200
Message-ID: <20260607095736.405170318@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
 


