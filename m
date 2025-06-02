Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A28221734;
	Mon,  2 Jun 2025 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873071; cv=none; b=VCFj830VOexElWHWyLSlhwN8nlSqdIBvrjbPsYsJYOwyT8G7rl9hvS/U7pPgTUWhbGicQKWa/tFMKbM2dMdLx1OctAKXKmJc/PJ1owPibHHMBJRg+Xzz3lbwZrNgEFdeI7O3JkQOQrlhGotkEdy+fvDhQEy1288hM0fMpF6rQAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873071; c=relaxed/simple;
	bh=34qr2EHv95hOPEwelJN05qmukMwq3AFK5yT6AmTDLLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjN2KIk6FhxffzRa07JRYVA/4yktqp94XbRlZpApQNgkpo0UpNMJgWQFTXnFh91bdC5+fW81hWJD+QJVSoPDZAVYnnas1kJ7zqvK3YcLKc9wv+3XMPzr3YvV/4FLj8n1iPUNzpBz7GLGPazWvdusa82RZ5CKWs6y12tlXhiWcpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewiB8gKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewiB8gKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A855C4CEEB;
	Mon,  2 Jun 2025 14:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873070;
	bh=34qr2EHv95hOPEwelJN05qmukMwq3AFK5yT6AmTDLLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewiB8gKeNbm56vutPgtq6EG1Tgukhf3DtT3VUoMmLqH9dTDpi614T0MnckFZOh0Si
	 P+40uK+kudN8Mc0bIvYXOgu78oQWyzzERBkoPSAzdzz4bf3QCCHSrHrQmVwafKDn3o
	 LPDOqm8qfBocL2lUZCUJRDLItPLzUVg0htqumddQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederick Lawler <fred@cloudflare.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/444] ima: process_measurement() needlessly takes inode_lock() on MAY_READ
Date: Mon,  2 Jun 2025 15:41:32 +0200
Message-ID: <20250602134342.062701269@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Frederick Lawler <fred@cloudflare.com>

[ Upstream commit 30d68cb0c37ebe2dc63aa1d46a28b9163e61caa2 ]

On IMA policy update, if a measure rule exists in the policy,
IMA_MEASURE is set for ima_policy_flags which makes the violation_check
variable always true. Coupled with a no-action on MAY_READ for a
FILE_CHECK call, we're always taking the inode_lock().

This becomes a performance problem for extremely heavy read-only workloads.
Therefore, prevent this only in the case there's no action to be taken.

Signed-off-by: Frederick Lawler <fred@cloudflare.com>
Acked-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 98308a2bdef6e..068edb0d79f73 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -235,7 +235,9 @@ static int process_measurement(struct file *file, const struct cred *cred,
 				&allowed_algos);
 	violation_check = ((func == FILE_CHECK || func == MMAP_CHECK ||
 			    func == MMAP_CHECK_REQPROT) &&
-			   (ima_policy_flag & IMA_MEASURE));
+			   (ima_policy_flag & IMA_MEASURE) &&
+			   ((action & IMA_MEASURE) ||
+			    (file->f_mode & FMODE_WRITE)));
 	if (!action && !violation_check)
 		return 0;
 
-- 
2.39.5



