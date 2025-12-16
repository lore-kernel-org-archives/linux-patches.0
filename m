Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12C6350D78;
	Tue, 16 Dec 2025 12:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886619; cv=none; b=tJSCnOedma9hhDo07lhie2Yl4v9/PTesAYlZmbx95fb3EhvdSSuCXJy/enL0Wg3Z6iTnKgviW2GW2FMYnqlBErOcjTEjaPbM3iqiy9uhgCSayeNj6DKTP5rD6aDcFGPvqHYfNFirKw57EsMguegJZIYRAJ48Pd8QrG6tsKEyths=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886619; c=relaxed/simple;
	bh=10OLzoMC3sjMgGFoQ2bAW2KiZ9v+8RYRwpXNQxqhsNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9MS8Q+o43h48DoNlIsEUo9xtBRulNN32Jf1R72bY6REGtgOITwKwNXrl5ogVHxSpo5AAPDsOtbDD1P08RQmWPtIEd2cc813UDgpOLLqYp9cwRHSczp1SCLFGh9EGAWUgW7p9TAucMFOLdGRN0ABhVwzhtns3t+ySK/Iq+2NnQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATo6WvZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATo6WvZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC83C4CEF1;
	Tue, 16 Dec 2025 12:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886619;
	bh=10OLzoMC3sjMgGFoQ2bAW2KiZ9v+8RYRwpXNQxqhsNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATo6WvZFj5KH6oZz8R3FaHhWa7rxyf6dCJGYVr/x+9T/g07BccHNBEjghqE1O2nOp
	 /d+H8y7HVMcZcZe6nfFEqCJ7OGGCnMItkuxw7EdKACwcmYv6+2ErYLNHlaf+B4G6G9
	 /bjHSUMDsXD0I/DhR1GjI6UMh+KuAk2xFETeeXhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 489/507] efi/cper: Add a new helper function to print bitmasks
Date: Tue, 16 Dec 2025 12:15:30 +0100
Message-ID: <20251216111403.155031688@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 928409199a1a4..79ba688a64f8d 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -12,6 +12,7 @@
  * Specification version 2.4.
  */
 
+#include <linux/bitmap.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/time.h>
@@ -106,6 +107,65 @@ void cper_print_bits(const char *pfx, unsigned int bits,
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
index 0ed60a91eca9d..58f40477c824e 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -588,6 +588,8 @@ const char *cper_mem_err_type_str(unsigned int);
 const char *cper_mem_err_status_str(u64 status);
 void cper_print_bits(const char *prefix, unsigned int bits,
 		     const char * const strs[], unsigned int strs_size);
+int cper_bits_to_str(char *buf, int buf_size, unsigned long bits,
+		     const char * const strs[], unsigned int strs_size);
 void cper_mem_err_pack(const struct cper_sec_mem_err *,
 		       struct cper_mem_err_compact *);
 const char *cper_mem_err_unpack(struct trace_seq *,
-- 
2.51.0



