Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780D5248BC4;
	Wed, 15 Jan 2025 10:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937848; cv=none; b=Cy2kUdS95kH1tOXKJ8wugBagIRGrry8bFvJLNivHv8hk14EV2s+zEkuR0Rso8U9YAOS+kKKyN5QY1wOltG+xFsEQjhasiv6M+4UkjLy7f8pLXq1YcoGqUpKzS1l0o3f+b+0Cbke+i0eMwGFiUqFnjhxJrssb92aF0aOXTs+aC+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937848; c=relaxed/simple;
	bh=nXA9FxScfmscON3rbAx45cioNQSbeCN2meak+Gbg3vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI37T1Zuz3ItE8TGqA8vUIvyxY6ar5WO6NOJNPTdh1tAonlI/Yw82QhZIKpCDdnUoHOU7JLOCtoIEOXGxstZnf9Cr7AkGD58N9PBY00Ldt7DNDtEsAEPSnTXU3D7U4Ij2aGpLqsakdws6rnAxRN88whgrKDsG1c6tHzycPzXodc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCIp9OhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCIp9OhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25820C4CEE4;
	Wed, 15 Jan 2025 10:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937847;
	bh=nXA9FxScfmscON3rbAx45cioNQSbeCN2meak+Gbg3vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCIp9OhSZK5qefI+QayrFfO4aZtKOsTjCuYxvNFB4KTwH9cWCaJUcOBf809UZa7wO
	 v7yB+V+7MiFpvzV/8iFsPrbJVE2bpZcpUdS7Xy7a1j7kPkY5peqipYAtusPvuYMIfJ
	 VmoSKiod6Kd5IUIaFfmEuh3PpaMVq+yloOyqyJx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/189] jbd2: increase IO priority for writing revoke records
Date: Wed, 15 Jan 2025 11:34:57 +0100
Message-ID: <20250115103606.419041840@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit ac1e21bd8c883aeac2f1835fc93b39c1e6838b35 ]

Commit '6a3afb6ac6df ("jbd2: increase the journal IO's priority")'
increases the priority of journal I/O by marking I/O with the
JBD2_JOURNAL_REQ_FLAGS. However, that commit missed the revoke buffers,
so also addresses that kind of I/Os.

Fixes: 6a3afb6ac6df ("jbd2: increase the journal IO's priority")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20241203014407.805916-2-yi.zhang@huaweicloud.com
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/revoke.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 4556e4689024..ce63d5fde9c3 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -654,7 +654,7 @@ static void flush_descriptor(journal_t *journal,
 	set_buffer_jwrite(descriptor);
 	BUFFER_TRACE(descriptor, "write");
 	set_buffer_dirty(descriptor);
-	write_dirty_buffer(descriptor, REQ_SYNC);
+	write_dirty_buffer(descriptor, JBD2_JOURNAL_REQ_FLAGS);
 }
 #endif
 
-- 
2.39.5



