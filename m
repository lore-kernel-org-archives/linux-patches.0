Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C2F3BC4ED;
	Thu, 15 Jan 2026 17:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497761; cv=none; b=bouSfAdcRl8M379I/nIdNjivcvE4rHHB60aLdl/AjrV2NliG7qXUuVBlo7XhaFTD+BxAn1jr3Bp1pTb4pWkMT91EazWUP/aHbQKBzqHJGomh/hGezJ/t4Y7qPiiQuxLzp7egMe6VWZij1ZjYG2yDe7lehK9tULC1SxHhb9BkDC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497761; c=relaxed/simple;
	bh=vhDD2qxh7hXIShv0jTGtzbQaT4QNUAv6p0Ql0MeDO4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4vuQsQNoCaTWUxEkjNWPOwmih9e23mIjqVGtbrnePZn7huM4KtxgSd9XwAC565EMsQQkhq20OUKHcMrgp6b9+y6vJ/cjOOK1+orv5pojdE9a7EQpMEN9ZxqQ0MEp/f098L03Po4bu0qCp17tQwVkb6w7zYFVv8t+/akqYNLCjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWuXyC54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWuXyC54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F51C116D0;
	Thu, 15 Jan 2026 17:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497761;
	bh=vhDD2qxh7hXIShv0jTGtzbQaT4QNUAv6p0Ql0MeDO4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWuXyC543hU6ae0Ps769P1LFrCR/NJSFZ/Z61tO6f/jT9Q0J3CvYK4Y28vo5HjBZ4
	 WrR3/+h5P8uE3IVif5uLOt8QIxzYe6KACHAQqvDRCV/MrfwNq6JOoCRz4B0v9k+1/h
	 CxXVx+tQo+JbWEvNDXnJh8gOYnkpSZBgYEKsn04w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 194/554] efi/cper: Add a new helper function to print bitmasks
Date: Thu, 15 Jan 2026 17:44:20 +0100
Message-ID: <20260115164253.281249443@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit a976d790f49499ccaa0f991788ad8ebf92e7fd5c ]

Add a helper function to print a string with names associated
to each bit field.

A typical example is:

	const char * const bits[] = {
		"bit 3 name",
		"bit 4 name",
		"bit 5 name",
	};
	char str[120];
        unsigned int bitmask = BIT(3) | BIT(5);

	#define MASK  GENMASK(5,3)

	cper_bits_to_str(str, sizeof(str), FIELD_GET(MASK, bitmask),
			 bits, ARRAY_SIZE(bits));

The above code fills string "str" with "bit 3 name|bit 5 name".

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/cper.c | 60 +++++++++++++++++++++++++++++++++++++
 include/linux/cper.h        |  2 ++
 2 files changed, 62 insertions(+)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 6ec8edec63296..d0668452dca9e 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -12,6 +12,7 @@
  * Specification version 2.4.
  */
 
+#include <linux/bitmap.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/time.h>
@@ -105,6 +106,65 @@ void cper_print_bits(const char *pfx, unsigned int bits,
 		printk("%s\n", buf);
 }
 
+/**
+ * cper_bits_to_str - return a string for set bits
+ * @buf: buffer to store the output string
+ * @buf_size: size of the output string buffer
+ * @bits: bit mask
+ * @strs: string array, indexed by bit position
+ * @strs_size: size of the string array: @strs
+ *
+ * Add to @buf the bitmask in hexadecimal. Then, for each set bit in @bits,
+ * add the corresponding string describing the bit in @strs to @buf.
+ *
+ * A typical example is::
+ *
+ *	const char * const bits[] = {
+ *		"bit 3 name",
+ *		"bit 4 name",
+ *		"bit 5 name",
+ *	};
+ *	char str[120];
+ *	unsigned int bitmask = BIT(3) | BIT(5);
+ *	#define MASK GENMASK(5,3)
+ *
+ *	cper_bits_to_str(str, sizeof(str), FIELD_GET(MASK, bitmask),
+ *			 bits, ARRAY_SIZE(bits));
+ *
+ * The above code fills the string ``str`` with ``bit 3 name|bit 5 name``.
+ *
+ * Return: number of bytes stored or an error code if lower than zero.
+ */
+int cper_bits_to_str(char *buf, int buf_size, unsigned long bits,
+		     const char * const strs[], unsigned int strs_size)
+{
+	int len = buf_size;
+	char *str = buf;
+	int i, size;
+
+	*buf = '\0';
+
+	for_each_set_bit(i, &bits, strs_size) {
+		if (!(bits & BIT_ULL(i)))
+			continue;
+
+		if (*buf && len > 0) {
+			*str = '|';
+			len--;
+			str++;
+		}
+
+		size = strscpy(str, strs[i], len);
+		if (size < 0)
+			return size;
+
+		len -= size;
+		str += size;
+	}
+	return len - buf_size;
+}
+EXPORT_SYMBOL_GPL(cper_bits_to_str);
+
 static const char * const proc_type_strs[] = {
 	"IA32/X64",
 	"IA64",
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 6a511a1078ca0..724a5e3c122d6 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -560,6 +560,8 @@ const char *cper_severity_str(unsigned int);
 const char *cper_mem_err_type_str(unsigned int);
 void cper_print_bits(const char *prefix, unsigned int bits,
 		     const char * const strs[], unsigned int strs_size);
+int cper_bits_to_str(char *buf, int buf_size, unsigned long bits,
+		     const char * const strs[], unsigned int strs_size);
 void cper_mem_err_pack(const struct cper_sec_mem_err *,
 		       struct cper_mem_err_compact *);
 const char *cper_mem_err_unpack(struct trace_seq *,
-- 
2.51.0



