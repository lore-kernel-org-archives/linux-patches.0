Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1279B350A3A;
	Tue, 21 Oct 2025 20:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077238; cv=none; b=FQ7ouVKTdyY9TJMH+fIibXITAtEL917iG1DdGrDuZtPDhJpvrxhYrkgd8EXg8jR8NsUf1T92e3g3zKJXzoxXs6OenGEZTTMF5dlUH5ryneWGesO85vx+qk883v5i2HZqMzbHs1CAyw1V4HkaiIMwjqBhyzhsMkwlqATNQxTJ7uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077238; c=relaxed/simple;
	bh=KYwAOLLRmoL6lu7FcGcnQ9Ur4WsQUNFamy03ori4Z5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPDx33uO79SXQ8EDlFAJX5c7eijiDFr8zUINye01xCragWpFAYspTZE3+Ze9+BZCMP4mr+y30sqOe31V2oV/DlC3oGDHbYYH+Y2jcoA+QhxTDxohHx2nuO8WeTAiLU47pXjAnnW3bux53/yzQPf/NaNJAFfoRZRIMVMeYpwnvQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIHDvR3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIHDvR3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C76BC4CEF7;
	Tue, 21 Oct 2025 20:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077236;
	bh=KYwAOLLRmoL6lu7FcGcnQ9Ur4WsQUNFamy03ori4Z5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIHDvR3P1v36S2H1DM/5pbWUF+PT6nosrUL82C4w2lFvkytl7jrz2AnjWQ5/sYkGI
	 aeydFwI2xP2M9UPqz8O7usTrec4jAoyLjFnvox+pp6bxts9u1TspZajEo0sPb0i4Mg
	 6q9m2hYAcJBGfDGr1BTXQ/94ugb8bTBcmcTjIlB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.17 005/159] ata: libata-core: relax checks in ata_read_log_directory()
Date: Tue, 21 Oct 2025 21:49:42 +0200
Message-ID: <20251021195043.315285716@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 12d724f2852d094d68dccaf5101e0ef89a971cde upstream.

Commit 6d4405b16d37 ("ata: libata-core: Cache the general purpose log
directory") introduced caching of a device general purpose log directory
to avoid repeated access to this log page during device scan. This
change also added a check on this log page to verify that the log page
version is 0x0001 as mandated by the ACS specifications.

And it turns out that some devices do not bother reporting this version,
instead reporting a version 0, resulting in error messages such as:

ata6.00: Invalid log directory version 0x0000

and to the device being marked as not supporting the general purpose log
directory log page.

Since before commit 6d4405b16d37 the log page version check did not
exist and things were still working correctly for these devices, relax
ata_read_log_directory() version check and only warn about the invalid
log page version number without disabling access to the log directory
page.

Fixes: 6d4405b16d37 ("ata: libata-core: Cache the general purpose log directory")
Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220635
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c | 11 ++++-------
 include/linux/libata.h    |  6 ++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ff53f5f029b4..2a210719c4ce 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2174,13 +2174,10 @@ static int ata_read_log_directory(struct ata_device *dev)
 	}
 
 	version = get_unaligned_le16(&dev->gp_log_dir[0]);
-	if (version != 0x0001) {
-		ata_dev_err(dev, "Invalid log directory version 0x%04x\n",
-			    version);
-		ata_clear_log_directory(dev);
-		dev->quirks |= ATA_QUIRK_NO_LOG_DIR;
-		return -EINVAL;
-	}
+	if (version != 0x0001)
+		ata_dev_warn_once(dev,
+				  "Invalid log directory version 0x%04x\n",
+				  version);
 
 	return 0;
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 21de0935775d..7a98de1cc995 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1594,6 +1594,12 @@ do {								\
 #define ata_dev_dbg(dev, fmt, ...)				\
 	ata_dev_printk(debug, dev, fmt, ##__VA_ARGS__)
 
+#define ata_dev_warn_once(dev, fmt, ...)			\
+	pr_warn_once("ata%u.%02u: " fmt,			\
+		     (dev)->link->ap->print_id,			\
+		     (dev)->link->pmp + (dev)->devno,		\
+		     ##__VA_ARGS__)
+
 static inline void ata_print_version_once(const struct device *dev,
 					  const char *version)
 {
-- 
2.51.1.dirty



