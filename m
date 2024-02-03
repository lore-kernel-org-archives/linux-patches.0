Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A55168CD;
	Sat,  3 Feb 2024 04:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933507; cv=none; b=WwTXY7yT1g21xAT5VIyNZJfHIJlBY+Bnzsf+YTJNgRPAp3M/VYRG9feFPtBqAHagpUFiMU1oovhc7eEXv9aSyezWET2gz6oktt3pQT27xmzXUHKAtX5M77K4IAKEftqu3KqS6i+2Vt+dLtzVJxindmFSkccmUY1uijBavf7mq94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933507; c=relaxed/simple;
	bh=I0jou1rIhVDnRf3fBQNuLhXulC1VIPViyvvZd+h5MdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XL5dSHpq39Cv8UtUvexGNbL7GRaL/vp1nyw0EHxr00rk166yRb1d28EOxdeLjluKNqvy1tE8qhTmxvFQgm+Bby8yE0fYFnr7ghT3pusx+ykom1VA7ms+Q4MajEznZhhW4okUtlg/Wbh+xA5PQm/ucxeuORQb3H3sP5yrA4QC2z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lyrz+CVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lyrz+CVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557E9C433C7;
	Sat,  3 Feb 2024 04:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933507;
	bh=I0jou1rIhVDnRf3fBQNuLhXulC1VIPViyvvZd+h5MdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lyrz+CVuX6NI0nRrJxhto1+PFyUbW14ZkN+hrcrE0nuEethAD14n+E0+6qqfOMHBj
	 nbiq/4vgw8cjAPuFvOi78HpJOvHm/Qv7Tgeu47CaMnM5wEolMqoZnMFhhAzmVsEwak
	 Dv7ENNnsLwhl1uVRsQqsGZozhAZNNFhS7QFgPQYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kees Cook <keescook@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/322] PNP: ACPI: fix fortify warning
Date: Fri,  2 Feb 2024 20:01:55 -0800
Message-ID: <20240203035359.636859089@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit ba3f5058db437d919f8468db50483dd9028ff688 ]

When compiling with gcc version 14.0.0 20231126 (experimental)
and CONFIG_FORTIFY_SOURCE=y, I've noticed the following:

In file included from ./include/linux/string.h:295,
                 from ./include/linux/bitmap.h:12,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/x86/include/asm/paravirt.h:17,
                 from ./arch/x86/include/asm/cpuid.h:62,
                 from ./arch/x86/include/asm/processor.h:19,
                 from ./arch/x86/include/asm/cpufeature.h:5,
                 from ./arch/x86/include/asm/thread_info.h:53,
                 from ./include/linux/thread_info.h:60,
                 from ./arch/x86/include/asm/preempt.h:9,
                 from ./include/linux/preempt.h:79,
                 from ./include/linux/spinlock.h:56,
                 from ./include/linux/mmzone.h:8,
                 from ./include/linux/gfp.h:7,
                 from ./include/linux/slab.h:16,
                 from ./include/linux/resource_ext.h:11,
                 from ./include/linux/acpi.h:13,
                 from drivers/pnp/pnpacpi/rsparser.c:11:
In function 'fortify_memcpy_chk',
    inlined from 'pnpacpi_parse_allocated_vendor' at drivers/pnp/pnpacpi/rsparser.c:158:3,
    inlined from 'pnpacpi_allocated_resource' at drivers/pnp/pnpacpi/rsparser.c:249:3:
./include/linux/fortify-string.h:588:25: warning: call to '__read_overflow2_field'
declared with attribute warning: detected read beyond size of field (2nd parameter);
maybe use struct_group()? [-Wattribute-warning]
  588 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

According to the comments in include/linux/fortify-string.h, 'memcpy()',
'memmove()' and 'memset()' must not be used beyond individual struct
members to ensure that the compiler can enforce protection against
buffer overflows, and, IIUC, this also applies to partial copies from
the particular member ('vendor->byte_data' in this case). So it should
be better (and safer) to do both copies at once (and 'byte_data' of
'struct acpi_resource_vendor_typed' seems to be a good candidate for
'__counted_by(byte_length)' as well).

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pnp/pnpacpi/rsparser.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 4f05f610391b..c02ce0834c2c 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -151,13 +151,13 @@ static int vendor_resource_matches(struct pnp_dev *dev,
 static void pnpacpi_parse_allocated_vendor(struct pnp_dev *dev,
 				    struct acpi_resource_vendor_typed *vendor)
 {
-	if (vendor_resource_matches(dev, vendor, &hp_ccsr_uuid, 16)) {
-		u64 start, length;
+	struct { u64 start, length; } range;
 
-		memcpy(&start, vendor->byte_data, sizeof(start));
-		memcpy(&length, vendor->byte_data + 8, sizeof(length));
-
-		pnp_add_mem_resource(dev, start, start + length - 1, 0);
+	if (vendor_resource_matches(dev, vendor, &hp_ccsr_uuid,
+				    sizeof(range))) {
+		memcpy(&range, vendor->byte_data, sizeof(range));
+		pnp_add_mem_resource(dev, range.start, range.start +
+				     range.length - 1, 0);
 	}
 }
 
-- 
2.43.0



