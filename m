Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBF929BDB5;
	Fri,  3 Oct 2025 16:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507617; cv=none; b=hdrO7Bi70gVr3ZztwYWiC0oQUHSv8Q/VnB3SzHmk8vAuquF5o+TlBZoBqZ7V5MrzGrdxmvQ5HZnog2CJ0L+86Zfi2NFNQiYOAPJyIWLsCt8FOClLkFe3Pp8jsJWz3EXG4rU9ZZ0Kq0wNVgR6bRp1kSxvAmNiNi5rESxdgjiU0AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507617; c=relaxed/simple;
	bh=wHIFANEyp+qvXJSJCz5knZv0ovS6TA3ngFGhuLiHzos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msCIMJC1Mtq2NwKu1Lh+ZDkXBZm2VibEkObV88CGQL8P14Bbo3Nyzyth3ty/XqiwgCcyzW8ZDmQOGC5vI0IM1ux951sSxET/4jdJkb8cTuNe40ufXKMVL/SfIthK3UtCUttIjoDY6NH+H1mC612Vr+6dH+4pJati2zZxCO70XM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgtWNMJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgtWNMJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B47AC4CEF5;
	Fri,  3 Oct 2025 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507617;
	bh=wHIFANEyp+qvXJSJCz5knZv0ovS6TA3ngFGhuLiHzos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgtWNMJNFSiroqXrUCcNcddfsxgUvbeAORT0L8BbSMBvVh2WhNjezubiusuPsfG68
	 IZsR+rsCz4X8NACeYkRjf3I4jo6CALN9s4jQ/Y1RIa7W+VjGnmupsSB+ea6yUtvSSg
	 vjmkExaisAl8y0/T5PMYalaKJzPZxkOO+Dzkbx50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Haoran <haoranwangsec@gmail.com>,
	ziiiro <yuanmingbuaa@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.17 03/15] scsi: target: target_core_configfs: Add length check to avoid buffer overflow
Date: Fri,  3 Oct 2025 18:05:27 +0200
Message-ID: <20251003160359.986608370@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
References: <20251003160359.831046052@linuxfoundation.org>
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

From: Wang Haoran <haoranwangsec@gmail.com>

commit 27e06650a5eafe832a90fd2604f0c5e920857fae upstream.

A buffer overflow arises from the usage of snprintf to write into the
buffer "buf" in target_lu_gp_members_show function located in
/drivers/target/target_core_configfs.c. This buffer is allocated with
size LU_GROUP_NAME_BUF (256 bytes).

snprintf(...) formats multiple strings into buf with the HBA name
(hba->hba_group.cg_item), a slash character, a devicename (dev->
dev_group.cg_item) and a newline character, the total formatted string
length may exceed the buffer size of 256 bytes.

Since snprintf() returns the total number of bytes that would have been
written (the length of %s/%sn ), this value may exceed the buffer length
(256 bytes) passed to memcpy(), this will ultimately cause function
memcpy reporting a buffer overflow error.

An additional check of the return value of snprintf() can avoid this
buffer overflow.

Reported-by: Wang Haoran <haoranwangsec@gmail.com>
Reported-by: ziiiro <yuanmingbuaa@gmail.com>
Signed-off-by: Wang Haoran <haoranwangsec@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2774,7 +2774,7 @@ static ssize_t target_lu_gp_members_show
 			config_item_name(&dev->dev_group.cg_item));
 		cur_len++; /* Extra byte for NULL terminator */
 
-		if ((cur_len + len) > PAGE_SIZE) {
+		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;


