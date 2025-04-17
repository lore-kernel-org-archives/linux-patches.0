Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9302722E3E6;
	Thu, 17 Apr 2025 18:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913367; cv=none; b=Y7bRApJ4mRiraLAPzBDdgKXFHmEN49uCltaCf61yvZx2/bpJHqQgP2guSueACMVAoaUUSf/LDSjsasTft8d/pVtJ3ro1UF6Q4yRMDqwU21Wu+aQC42t1af0h3gI2ouPPYQn5WHMt/Vc2RadPDXUzi7oIsnbZLhwbrGcxHpkVSeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913367; c=relaxed/simple;
	bh=hq8MDOqBywcnxHFmQ0cM2b5mFrssDb9XQcEl5agL56k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeLopTUbeUaHS9++tIxwnwsiQKcHdH7dC9TMIFAzSesZZAd0jrKc3l697fzf98W+uw7nwxVmFGoL3dVKj5bydbt4chVZkjTt+WtS/OzbmYAJRnVPGDYmlwRmmDA3h/kGG3BrpwzBdp5kEgpgmaEffweudxP1YeqJeTcoxI1tGdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngY758w1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngY758w1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBC7C4CEE4;
	Thu, 17 Apr 2025 18:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913367;
	bh=hq8MDOqBywcnxHFmQ0cM2b5mFrssDb9XQcEl5agL56k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngY758w1rMK2hFNvxHkcs+wv/7OPtdkfzU7TdFIEn1PzCd7T9DuzYdzqB0AR2msor
	 dNvssi5dksysZnRKD9XuBSn6gjYxBUsEtSUPd3ybnH35oWhgoWDXianNBnSglSVB2x
	 p7u0H32cWKYUDgQbJd+BS9+pvvRI3rF+TMiP0oOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Petr Vorel <pvorel@suse.cz>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.14 315/449] ima: limit the number of open-writers integrity violations
Date: Thu, 17 Apr 2025 19:50:03 +0200
Message-ID: <20250417175130.793357080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mimi Zohar <zohar@linux.ibm.com>

commit 5b3cd801155f0b34b0b95942a5b057c9b8cad33e upstream.

Each time a file in policy, that is already opened for write, is opened
for read, an open-writers integrity violation audit message is emitted
and a violation record is added to the IMA measurement list. This
occurs even if an open-writers violation has already been recorded.

Limit the number of open-writers integrity violations for an existing
file open for write to one.  After the existing file open for write
closes (__fput), subsequent open-writers integrity violations may be
emitted.

Cc: stable@vger.kernel.org # applies cleanly up to linux-6.6
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Tested-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima.h      |    1 +
 security/integrity/ima/ima_main.c |   11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -182,6 +182,7 @@ struct ima_kexec_hdr {
 #define IMA_CHANGE_ATTR		2
 #define IMA_DIGSIG		3
 #define IMA_MUST_MEASURE	4
+#define IMA_EMITTED_OPENWRITERS	5
 
 /* IMA integrity metadata associated with an inode */
 struct ima_iint_cache {
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -137,8 +137,13 @@ static void ima_rdwr_violation_check(str
 	} else {
 		if (must_measure)
 			set_bit(IMA_MUST_MEASURE, &iint->atomic_flags);
-		if (inode_is_open_for_write(inode) && must_measure)
-			send_writers = true;
+
+		/* Limit number of open_writers violations */
+		if (inode_is_open_for_write(inode) && must_measure) {
+			if (!test_and_set_bit(IMA_EMITTED_OPENWRITERS,
+					      &iint->atomic_flags))
+				send_writers = true;
+		}
 	}
 
 	if (!send_tomtou && !send_writers)
@@ -167,6 +172,8 @@ static void ima_check_last_writer(struct
 	if (atomic_read(&inode->i_writecount) == 1) {
 		struct kstat stat;
 
+		clear_bit(IMA_EMITTED_OPENWRITERS, &iint->atomic_flags);
+
 		update = test_and_clear_bit(IMA_UPDATE_XATTR,
 					    &iint->atomic_flags);
 		if ((iint->flags & IMA_NEW_FILE) ||


