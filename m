Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC17258CC0;
	Thu, 17 Apr 2025 18:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916087; cv=none; b=uS13xOxDOZyF5cppkxdonCe5+YwRCNeFDcMKQDco5Jmdi6+Li8E3J+R1WN1xjHnogsEvYPGkcS0aGZbHnmcur7rc1z5Y1RSDa7QDwP/QwqUNJXVrG1esGosqO0O16oofATQzXyhQdjiAMwJqaaWQjgEJDaxWRsZCkmL0u4yGHLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916087; c=relaxed/simple;
	bh=GAYHEHD4wFvfldeS49jqLXA6jp+enET/HQf8Zhy+Ebo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tf1INv2rf4HYFEUf5V1Jo/gn79CJ8MJ9egfVNfB6FRCNormfHAfZxfdy9g5xBe5r8yE8iVHabq5ilST8dYknh3IAr+bckwcJkZ3GuPql5O0xvt2GS2UsCnQTQa/aql74QJrGDiGo0Kt4YGy/K0pzhe+u35zrwMeO3RiDxZaOkX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeN7bo2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeN7bo2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DBCC4CEEA;
	Thu, 17 Apr 2025 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916086;
	bh=GAYHEHD4wFvfldeS49jqLXA6jp+enET/HQf8Zhy+Ebo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeN7bo2tKruWqBuBRrx+gEVhalaWy+38qV6yUJBxCXqTzcnSWBDBkSq0QdWq8aUlp
	 loNZqfhyEBNoBtz1pWVoDQSciAWh5rs6hfg44ruQkiwnZTmwPPsc3x3T9F/dSfJOed
	 MXxgoNNbRfkrJMwtdIt9Rx0FvGZz5M2bBmajEY/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chiu <andybnac@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 338/393] ftrace: Properly merge notrace hashes
Date: Thu, 17 Apr 2025 19:52:27 +0200
Message-ID: <20250417175121.193233332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Andy Chiu <andybnac@gmail.com>

commit 04a80a34c22f4db245f553d8696d1318d1c00ece upstream.

The global notrace hash should be jointly decided by the intersection of
each subops's notrace hash, but not the filter hash.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250408160258.48563-1-andybnac@gmail.com
Fixes: 5fccc7552ccb ("ftrace: Add subops logic to allow one ops to manage many")
Signed-off-by: Andy Chiu <andybnac@gmail.com>
[ fixed removing of freeing of filter_hash ]
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3523,16 +3523,16 @@ int ftrace_startup_subops(struct ftrace_
 	    ftrace_hash_empty(subops->func_hash->notrace_hash)) {
 		notrace_hash = EMPTY_HASH;
 	} else {
-		size_bits = max(ops->func_hash->filter_hash->size_bits,
-				subops->func_hash->filter_hash->size_bits);
+		size_bits = max(ops->func_hash->notrace_hash->size_bits,
+				subops->func_hash->notrace_hash->size_bits);
 		notrace_hash = alloc_ftrace_hash(size_bits);
 		if (!notrace_hash) {
 			free_ftrace_hash(filter_hash);
 			return -ENOMEM;
 		}
 
-		ret = intersect_hash(&notrace_hash, ops->func_hash->filter_hash,
-				     subops->func_hash->filter_hash);
+		ret = intersect_hash(&notrace_hash, ops->func_hash->notrace_hash,
+				     subops->func_hash->notrace_hash);
 		if (ret < 0) {
 			free_ftrace_hash(filter_hash);
 			free_ftrace_hash(notrace_hash);


