Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB03367F26;
	Sat, 17 Oct 2026 18:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260258; cv=none; b=DDh+I78qNYFODcXR2y24Hv5qsNNh42nkZ/hsK/KLMMA9NKDng2ZTMCnXAoeNNh5+pKPWUFVSej5I7gntfOtP7coFImVFu90M+6Tsj9GFc+JIFaRHln01J7KOij4yplFYzVG3yvp7FlwTp0y9ZTDG54qblOPozomCp7hhm7RTzEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260258; c=relaxed/simple;
	bh=5Yk1a7jDZyaSuwLq7YBkaHvMjsgX7E9ddmLGtgpqSu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRadioPs/mn7o0J1Dab2HZsZ2nnvl/fYrWP9Q4h00Vn+Wz2n8AWknHPhyfzK/KhXeBsbrs5GtRqxPCdHVTp8d7GgmZfzOI1vOSM4N3clOHG03MV1I9sWMchar+HgAJcdo6sqrKpTi7HyzRci0KxCS7jcDbMaTVy2fDu6Um4mOfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWEcuTuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWEcuTuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762041F000C4;
	Sat, 17 Oct 2026 18:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260257;
	bh=QUFBnRn9CPzWYtOBo+mdi4goSuXN9x/8C9mVSgihGdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWEcuTuGr8gbCfYAwBCV40TI2wqaNUIWI7EjzNqnv1wRZxdqOHKylCyhAgXMBkzxc
	 /i0VgpGZB60iS24DNVFzj1qPev8SlQXUmYm2Iahr0Ged0l6w3sjGqLAEU7G2rQUHHL
	 aC6t7kHbyhEM4e7itHgs16Zf3ZPWhCg5Yaj6s15Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1484/1674] usb: gadget: uac: validate rate list length before storing
Date: Sat, 17 Oct 2026 18:02:36 +0200
Message-ID: <20261017160509.237538422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Ming <a0yami@mailbox.org>

[ Upstream commit 844d83d5964b87919b958ff48405188c6ddae9cc ]

UAC1 and UAC2 configfs rate-list attributes parse a comma-separated
list of sampling rates and store each parsed value in fixed-size arrays.
The arrays have UAC_MAX_RATES entries, but the store paths do not check
that the input contains at most that many tokens before writing through
opts->name##s[i++].

Writing more than ten rates therefore writes past the end of the
p_srates[] or c_srates[] array in struct f_uac1_opts or struct
f_uac2_opts.

With CONFIG_UBSAN_BOUNDS enabled, writing an 11-entry rate list to the
UAC1 p_srate attribute reports:

  UBSAN: array-index-out-of-bounds
  drivers/usb/gadget/function/f_uac1.c:1669:1
  index 10 is out of range for type 'int [10]'
  __ubsan_handle_out_of_bounds.cold
  f_uac1_opts_p_srate_store
  configfs_write_iter
  vfs_write
  ksys_write
  do_syscall_64

The same reproducer against the UAC2 p_srate attribute reports:

  UBSAN: array-index-out-of-bounds
  drivers/usb/gadget/function/f_uac2.c:2087:1
  index 10 is out of range for type 'int [10]'
  __ubsan_handle_out_of_bounds.cold
  f_uac2_opts_p_srate_store
  configfs_write_iter
  vfs_write
  ksys_write
  do_syscall_64

Reject additional tokens once UAC_MAX_RATES entries have been parsed.
Also keep the original kstrdup() pointer for kfree(), because strsep()
advances the parsing cursor. Freeing the advanced cursor leaks the
original buffer on successful parses and can free an interior pointer on
some error paths.

Fixes: 695d39ffc2b5 ("usb: gadget: f_uac1: Support multiple sampling rates")
Fixes: a7339e4f5788 ("usb: gadget: f_uac2: Support multiple sampling rates")
Signed-off-by: Qing Ming <a0yami@mailbox.org>
Link: https://patch.msgid.link/20260519143319.147494-1-a0yami@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uac1.c | 13 +++++++++----
 drivers/usb/gadget/function/f_uac2.c | 13 +++++++++----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uac1.c b/drivers/usb/gadget/function/f_uac1.c
index 6f0e1d803dc24..7939dadd52a5a 100644
--- a/drivers/usb/gadget/function/f_uac1.c
+++ b/drivers/usb/gadget/function/f_uac1.c
@@ -1521,7 +1521,8 @@ static ssize_t f_uac1_opts_##name##_store(struct config_item *item,	\
 					  const char *page, size_t len)	\
 {									\
 	struct f_uac1_opts *opts = to_f_uac1_opts(item);		\
-	char *split_page = NULL;					\
+	char *buf = NULL;						\
+	char *split_page;						\
 	int ret = -EINVAL;						\
 	char *token;							\
 	u32 num;							\
@@ -1535,18 +1536,22 @@ static ssize_t f_uac1_opts_##name##_store(struct config_item *item,	\
 									\
 	i = 0;								\
 	memset(opts->name##s, 0x00, sizeof(opts->name##s));		\
-	split_page = kstrdup(page, GFP_KERNEL);				\
+	buf = kstrdup(page, GFP_KERNEL);				\
+	split_page = buf;						\
 	while ((token = strsep(&split_page, ",")) != NULL) {		\
 		ret = kstrtou32(token, 0, &num);			\
 		if (ret)						\
 			goto end;					\
-									\
+		if (i >= UAC_MAX_RATES) {				\
+			ret = -EINVAL;					\
+			goto end;					\
+		}							\
 		opts->name##s[i++] = num;				\
 		ret = len;						\
 	};								\
 									\
 end:									\
-	kfree(split_page);						\
+	kfree(buf);							\
 	mutex_unlock(&opts->lock);					\
 	return ret;							\
 }									\
diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index eabd10817e1e7..b7d3988caa9c0 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -2003,7 +2003,8 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 					  const char *page, size_t len)	\
 {									\
 	struct f_uac2_opts *opts = to_f_uac2_opts(item);		\
-	char *split_page = NULL;					\
+	char *buf = NULL;						\
+	char *split_page;						\
 	int ret = -EINVAL;						\
 	char *token;							\
 	u32 num;							\
@@ -2017,18 +2018,22 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 									\
 	i = 0;								\
 	memset(opts->name##s, 0x00, sizeof(opts->name##s));		\
-	split_page = kstrdup(page, GFP_KERNEL);				\
+	buf = kstrdup(page, GFP_KERNEL);				\
+	split_page = buf;						\
 	while ((token = strsep(&split_page, ",")) != NULL) {		\
 		ret = kstrtou32(token, 0, &num);			\
 		if (ret)						\
 			goto end;					\
-									\
+		if (i >= UAC_MAX_RATES) {				\
+			ret = -EINVAL;					\
+			goto end;					\
+		}							\
 		opts->name##s[i++] = num;				\
 		ret = len;						\
 	};								\
 									\
 end:									\
-	kfree(split_page);						\
+	kfree(buf);							\
 	mutex_unlock(&opts->lock);					\
 	return ret;							\
 }									\
-- 
2.53.0



