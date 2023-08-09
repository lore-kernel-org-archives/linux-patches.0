Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651B215AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829E6C433C7;
	Wed,  9 Aug 2023 10:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578096;
	bh=o6IYe8pyfZVMw0/EKhv5aaXTGf+3/tRuJHs4ZVNwbAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ib7VcisZSe4chUP2GNOGKWi4Puia9VBOnv5EZ/hx3TdBGqLc9SaMwMOABzsLpPhyS
	 bX9vDN63nQCC78E104tMwirq6jdeS3GLWRZKLZMBHjPC732nWb+Oszjy3KXOPKPgnw
	 So2Z6aa813LDKKAXu/EVI7tZ1iobRtcXPI4nJzjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Maxim Suhanov <dfirblog@gmail.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.4 105/165] exfat: check if filename entries exceeds max filename length
Date: Wed,  9 Aug 2023 12:40:36 +0200
Message-ID: <20230809103646.222639563@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit d42334578eba1390859012ebb91e1e556d51db49 upstream.

exfat_extract_uni_name copies characters from a given file name entry into
the 'uniname' variable. This variable is actually defined on the stack of
the exfat_readdir() function. According to the definition of
the 'exfat_uni_name' type, the file name should be limited 255 characters
(+ null teminator space), but the exfat_get_uniname_from_ext_entry()
function can write more characters because there is no check if filename
entries exceeds max filename length. This patch add the check not to copy
filename characters when exceeding max filename length.

Cc: stable@vger.kernel.org
Cc: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reported-by: Maxim Suhanov <dfirblog@gmail.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -34,6 +34,7 @@ static int exfat_get_uniname_from_ext_en
 {
 	int i, err;
 	struct exfat_entry_set_cache es;
+	unsigned int uni_len = 0, len;
 
 	err = exfat_get_dentry_set(&es, sb, p_dir, entry, ES_ALL_ENTRIES);
 	if (err)
@@ -52,7 +53,10 @@ static int exfat_get_uniname_from_ext_en
 		if (exfat_get_entry_type(ep) != TYPE_EXTEND)
 			break;
 
-		exfat_extract_uni_name(ep, uniname);
+		len = exfat_extract_uni_name(ep, uniname);
+		uni_len += len;
+		if (len != EXFAT_FILE_NAME_LEN || uni_len >= MAX_NAME_LENGTH)
+			break;
 		uniname += EXFAT_FILE_NAME_LEN;
 	}
 
@@ -1079,7 +1083,8 @@ rewind:
 			if (entry_type == TYPE_EXTEND) {
 				unsigned short entry_uniname[16], unichar;
 
-				if (step != DIRENT_STEP_NAME) {
+				if (step != DIRENT_STEP_NAME ||
+				    name_len >= MAX_NAME_LENGTH) {
 					step = DIRENT_STEP_FILE;
 					continue;
 				}


