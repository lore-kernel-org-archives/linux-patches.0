Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030E4190663;
	Tue,  8 Oct 2024 12:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391211; cv=none; b=b+RZo0bSRXPYfLMfatsA6YEGsIluQREcFlWbR7Mbkh9dbGd/JrDBIqDJqM12b3wiwPewW7VqiI7o2lcEq2joNNFooB3SGkol5smH0Jep4HJ+Jr/x+EZwvgPZpwPtnyO7KGFM1fZ7j/ipvGiLVyGP9SsvQ7Gn62GcZ4j9f1Kx7ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391211; c=relaxed/simple;
	bh=9nt7J/xRvZTs8S5Wanj6oQVrlD7PHPoTO/1YVUI1ZHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAvooyig8JilfYGbF/F0D/x93pq/xMeInO04/QhnV3xTSNHKPb3cmPCBLj4a3fiWaa9sO/aR4KqPYOnAOgqH0Puvo2nQVLqhtWmEQnT0MpizyZTiSEDN77N8zp0+re+ub30vshqZFL+hFV3Z3x+yuWPIXfTEJkt5P7z9Sex3TYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2WhIRGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2WhIRGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3037EC4CEC7;
	Tue,  8 Oct 2024 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391210;
	bh=9nt7J/xRvZTs8S5Wanj6oQVrlD7PHPoTO/1YVUI1ZHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2WhIRGXnNIJmmAFH0aR1uAj0lgwwTLTdoiH3DOv1aWwo0Qf0rGp1UAEOyC6u1OYR
	 N/c+JjjdwY9WZazdGuAXJj3jHF7Vh3tevOcekTvwAX4ZGvBF6zU+TVEB8LvcIVszNt
	 Ea8+Hbi3gpf6IzUp5EU80cb/w2uArQmwygFb9D9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 035/558] afs: Fix the setting of the server responding flag
Date: Tue,  8 Oct 2024 14:01:05 +0200
Message-ID: <20241008115703.604142042@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit ff98751bae40faed1ba9c6a7287e84430f7dec64 ]

In afs_wait_for_operation(), we set transcribe the call responded flag to
the server record that we used after doing the fileserver iteration loop -
but it's possible to exit the loop having had a response from the server
that we've discarded (e.g. it returned an abort or we started receiving
data, but the call didn't complete).

This means that op->server might be NULL, but we don't check that before
attempting to set the server flag.

Fixes: 98f9fda2057b ("afs: Fold the afs_addr_cursor struct in")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20240923150756.902363-7-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fs_operation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/fs_operation.c b/fs/afs/fs_operation.c
index 3546b087e791d..428721bbe4f6e 100644
--- a/fs/afs/fs_operation.c
+++ b/fs/afs/fs_operation.c
@@ -201,7 +201,7 @@ void afs_wait_for_operation(struct afs_operation *op)
 		}
 	}
 
-	if (op->call_responded)
+	if (op->call_responded && op->server)
 		set_bit(AFS_SERVER_FL_RESPONDING, &op->server->flags);
 
 	if (!afs_op_error(op)) {
-- 
2.43.0



