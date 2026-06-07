Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DA131ED93;
	Sun,  7 Jun 2026 10:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829451; cv=none; b=ErRJRhPvXklDgNkZu44Aj7051uvO+kQp6fjLZKp7OhmUKIK+dJM/lOrYzyMnmKv4Jk0OP+TtNlBGZRAm9eqmGlq8PHSaYa8F6muM2jXGSUvMNvonNKVXg3Lgn2C5GGmEQdMlvypKuEzeuzOqXpeUqhkB7A4wAigi0XG0GOKEMvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829451; c=relaxed/simple;
	bh=eQYWdr1vXhi0tbZdjjVcIovfnggd86sKpwbX0/58RC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/eVLMAREI42/RumVJZ21NmjV+cDxsj9CWH+7lIq2++8H9XLfvGBURKDhkjbnV+vdNNOJUfMuKo7Xp3Bf26uWAH6YGCbhdMYFWKFCylqIJSgMbmNPZa3usNZqYnva4eA3Fj38S4wWan5HlMChxDc4BlVmTK9yrpbZysPB0gfPIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dY5TaAkB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dY5TaAkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BBF1F00893;
	Sun,  7 Jun 2026 10:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829449;
	bh=MzZwldRNwVa2QapZCV5eJyjehBgaPTrfoyU7VjtPzH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dY5TaAkBI8S8GeorsN0wJPvQxm7WsY7XuApZFwpRj8CgImzg19/DVUjCCceo5o0ds
	 oqR2/ImZxIqmpIeKogVYKYZXU8ju8vtWcGoRJguSEfSinvnHJzy2t+pTRtuFeUSSY5
	 3GW21lqFVvR3UStOxX0hzE/8ILoMBM0QtZJ9NGOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.0 280/332] thunderbolt: property: Reject u32 wrap in tb_property_entry_valid()
Date: Sun,  7 Jun 2026 12:00:49 +0200
Message-ID: <20260607095738.331649312@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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
 


