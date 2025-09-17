Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4724C32E747;
	Wed, 17 Sep 2025 12:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113689; cv=none; b=RY6MRSsd0KF3MgZQQ1q15wE/sLgCQSF63tIWsUoEGEhNccj+nY2xql+DX27qbYEtF7bUyOUsrEbbIPEzxlCG5lKZjW8lyN3yLGazWUoieis1bJUwMXaG8pbLaOYN4R7BCBK7UsoHFwjVURftG3LLInoacVzho84ZZAZwwjyhikk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113689; c=relaxed/simple;
	bh=8j6OeRO5DJrAT42+X34Ma1EhdZBAb8KkPc00lROBXbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8fy+Oeu0liX1lDq3eiaWlgblAlzMAlYLWM36YIg5T6x7o3nGO+MTBRc7cQKLIQLD+pslpK9zN5324X8RX6cOnACOf/T14cyNYjBF+LOpsDhctfSqTk5clK6qCneEZcSbTkDipfWOyCXGa7k8IwUX8U9XzptXXR/HzH1ZMA4XM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAgU80jB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAgU80jB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC67C4CEF5;
	Wed, 17 Sep 2025 12:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113689;
	bh=8j6OeRO5DJrAT42+X34Ma1EhdZBAb8KkPc00lROBXbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAgU80jBT8zTJqelkf+sW9H0ketRchuRFO2UsAAHA7ScXnlY1uQcIwxtL5S6/4iyv
	 xzi+Ro24z6HPYwYNyk7WHoRcQSADejYZsn8X4GSmwcKZ7APFoSkiuhybIDLk1OW9nT
	 6oxuUzwvccIJbrX/xncl+l55wcXzWiHF8MW5uWbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Petr Vorel <pvorel@suse.cz>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/101] ima: limit the number of ToMToU integrity violations
Date: Wed, 17 Sep 2025 14:33:51 +0200
Message-ID: <20250917123337.070995002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mimi Zohar <zohar@linux.ibm.com>

[ Upstream commit a414016218ca97140171aa3bb926b02e1f68c2cc ]

Each time a file in policy, that is already opened for read, is opened
for write, a Time-of-Measure-Time-of-Use (ToMToU) integrity violation
audit message is emitted and a violation record is added to the IMA
measurement list.  This occurs even if a ToMToU violation has already
been recorded.

Limit the number of ToMToU integrity violations per file open for read.

Note: The IMA_MAY_EMIT_TOMTOU atomic flag must be set from the reader
side based on policy.  This may result in a per file open for read
ToMToU violation.

Since IMA_MUST_MEASURE is only used for violations, rename the atomic
IMA_MUST_MEASURE flag to IMA_MAY_EMIT_TOMTOU.

Cc: stable@vger.kernel.org # applies cleanly up to linux-6.6
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Tested-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
[ adapted IMA flag definitions location from ima.h to integrity.h ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_main.c |   16 +++++++++++-----
 security/integrity/integrity.h    |    3 ++-
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -128,16 +128,22 @@ static void ima_rdwr_violation_check(str
 		if (atomic_read(&inode->i_readcount) && IS_IMA(inode)) {
 			if (!iint)
 				iint = integrity_iint_find(inode);
+
 			/* IMA_MEASURE is set from reader side */
-			if (iint && test_bit(IMA_MUST_MEASURE,
-						&iint->atomic_flags))
+			if (iint && test_and_clear_bit(IMA_MAY_EMIT_TOMTOU,
+						       &iint->atomic_flags))
 				send_tomtou = true;
 		}
 	} else {
 		if (must_measure)
-			set_bit(IMA_MUST_MEASURE, &iint->atomic_flags);
-		if (inode_is_open_for_write(inode) && must_measure)
-			send_writers = true;
+			set_bit(IMA_MAY_EMIT_TOMTOU, &iint->atomic_flags);
+
+		/* Limit number of open_writers violations */
+		if (inode_is_open_for_write(inode) && must_measure) {
+			if (!test_and_set_bit(IMA_EMITTED_OPENWRITERS,
+					      &iint->atomic_flags))
+				send_writers = true;
+		}
 	}
 
 	if (!send_tomtou && !send_writers)
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -74,7 +74,8 @@
 #define IMA_UPDATE_XATTR	1
 #define IMA_CHANGE_ATTR		2
 #define IMA_DIGSIG		3
-#define IMA_MUST_MEASURE	4
+#define IMA_MAY_EMIT_TOMTOU	4
+#define IMA_EMITTED_OPENWRITERS	5
 
 enum evm_ima_xattr_type {
 	IMA_XATTR_DIGEST = 0x01,


