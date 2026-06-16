Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC9D441035;
	Tue, 16 Jun 2026 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625149; cv=none; b=DwMaomp3LDEppB8YiBaG3FgEA1OeVxx8yuStBZ4xnPD+mxGZpkq03AVeqSRyOxnFW7sQhiztgF2dAzhRMt44xz40M+QjukYYwzCSglt0hLXZcA0jBqFKuzsjNr4Hva/r3xE4rVsiCm4MaiH89f5RZ/6PytBwfEv113CLvXrjMXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625149; c=relaxed/simple;
	bh=I7h8jufXjMLXRo8XBRYiqeF5cGCbWckrPdErbTSquOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aai/Oyt8DB1uPpuv4aNVV335tvJMyRf0zb0FmnFMUSqx30OH6KQTLqgE+WsAZGWwAvWyrtLoplXbtOhquJODtRkjcBi1BC+Lttk00Uc3kt6qDywflH5dcV9WcX71+lhsEPjuC2ANB2XweLjcKOJYxGT9VG5SfCbxRm4jHQMAUOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUjzSEHg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUjzSEHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C9B1F000E9;
	Tue, 16 Jun 2026 15:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625147;
	bh=Ut9Mw2I4KB1xaz3XJYcxDrb4C0twQW6tp2yb4y0yPEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUjzSEHgpUZZSpkwQr6Ao+LwsLVtFyw/jGpJKd4M2vSOYKqkP3/HZqBl73oP8FfM8
	 iz0VBvODjYXWnCK2UxikjaXW2V3GRamEI2pqg3K70zrLyfS0cp80Zc8gGJavShwqeW
	 4k8rkdshiKyAoltTAGuyKI6qpyxybn0a89TX1K/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	unknownbbqrx <dev@unknownbbqr.xyz>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/325] tools/rv: Ensure monitor name and desc are NUL-terminated
Date: Tue, 16 Jun 2026 20:27:55 +0530
Message-ID: <20260616145101.664623424@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 08904765bb941f98306ae6841c33cfd299343faf ]

ikm_fill_monitor_definition() copies monitor name and description with
strncpy(), but does not guarantee NUL termination when source strings are
equal to or longer than the destination buffers.

Clamp copies to sizeof(dst) - 1 and explicitly append '\0' for both fields
to keep them safe for later string operations.

Suggested-by: unknownbbqrx <dev@unknownbbqr.xyz>
Fixes: 6d60f89691fc9 ("tools/rv: Add in-kernel monitor interface")
Link: https://lore.kernel.org/r/20260604120946.90302-2-gmonaco@redhat.com
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/rv/src/in_kernel.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/verification/rv/src/in_kernel.c b/tools/verification/rv/src/in_kernel.c
index 4bb746ea6e1735..d324538249d3ab 100644
--- a/tools/verification/rv/src/in_kernel.c
+++ b/tools/verification/rv/src/in_kernel.c
@@ -215,10 +215,11 @@ static int ikm_fill_monitor_definition(char *name, struct monitor *ikm, char *co
 		return -1;
 	}
 
-	strncpy(ikm->name, nested_name, MAX_DA_NAME_LEN);
+	strncpy(ikm->name, nested_name, sizeof(ikm->name) - 1);
+	ikm->name[sizeof(ikm->name) - 1] = '\0';
 	ikm->enabled = enabled;
-	strncpy(ikm->desc, desc, MAX_DESCRIPTION);
-
+	strncpy(ikm->desc, desc, sizeof(ikm->desc) - 1);
+	ikm->desc[sizeof(ikm->desc) - 1] = '\0';
 	free(desc);
 
 	return 0;
-- 
2.53.0



