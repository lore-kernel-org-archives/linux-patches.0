Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFEF17ABE
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAF9C433CB;
	Wed,  9 Aug 2023 11:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581294;
	bh=COy6M2SWog+bvgScoeKsIPtGiWS5cxeJvow4rlVy1Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPbsiZPREvz0Eg3QmfPxEjcvEp3adHbCCFjBdm5FvpLIbIMzG7WKjDMQb80RiVuhg
	 4gmhu8aNpe7kSMG/Y2EACbHnqxWdbCilPST/by95gL1Mr0np9it5ryTdyDH6PVJTqU
	 vAPZdlrKIlzaFq6pL6Rvsnw5DzUltlTWLSeC005I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 174/201] open: make RESOLVE_CACHED correctly test for O_TMPFILE
Date: Wed,  9 Aug 2023 12:42:56 +0200
Message-ID: <20230809103649.559887777@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aleksa Sarai <cyphar@cyphar.com>

commit a0fc452a5d7fed986205539259df1d60546f536c upstream.

O_TMPFILE is actually __O_TMPFILE|O_DIRECTORY. This means that the old
fast-path check for RESOLVE_CACHED would reject all users passing
O_DIRECTORY with -EAGAIN, when in fact the intended test was to check
for __O_TMPFILE.

Cc: stable@vger.kernel.org # v5.12+
Fixes: 99668f618062 ("fs: expose LOOKUP_CACHED through openat2() RESOLVE_CACHED")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Message-Id: <20230806-resolve_cached-o_tmpfile-v1-1-7ba16308465e@cyphar.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/open.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -1101,7 +1101,7 @@ inline int build_open_flags(const struct
 		lookup_flags |= LOOKUP_IN_ROOT;
 	if (how->resolve & RESOLVE_CACHED) {
 		/* Don't bother even trying for create/truncate/tmpfile open */
-		if (flags & (O_TRUNC | O_CREAT | O_TMPFILE))
+		if (flags & (O_TRUNC | O_CREAT | __O_TMPFILE))
 			return -EAGAIN;
 		lookup_flags |= LOOKUP_CACHED;
 	}


