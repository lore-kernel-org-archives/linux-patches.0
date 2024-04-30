Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7183C12D1EA;
	Tue, 30 Apr 2024 11:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475309; cv=none; b=jpBNnYkm6pCBd7KCQ9CUc4T/5sLGafyYqHR5HOmns8l+0bnzjGRA6XqJ87ESe2IvNGjQ0LeRh9NY4/PRBISUVBLMWo7yYQEh9UFvXL1H5BgjSW5bCtkrw7Evh88FsrwViJ4YTs9JtHzlUqmAgHuF5pWd89OI5Yc0EY4y6M79OP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475309; c=relaxed/simple;
	bh=13COE6qRmEfg4Qg5iQDca0o6nMt7aEuYnIOHJGtGitY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KscQwrl1T+1gN/StW7UyORJ2CBLhT2QhdFWgdwUmAowI0Muqi/bcsXr6nrbfKRpMRqujwSxto/hwGjNaH8P+Pdwhfy3JgqJhOdhvYKtz4c63k9OMVcdiMEi8z5Pt+x2oPKp22ue5fzrHan28P7SNW02qUQ4iJokJD1xt7MQFPEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJSgLlRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJSgLlRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF625C2BBFC;
	Tue, 30 Apr 2024 11:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475309;
	bh=13COE6qRmEfg4Qg5iQDca0o6nMt7aEuYnIOHJGtGitY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJSgLlRd668BNZYaORQBuEUbNeFK0DGXK+yw8MLwZ6qd3rXHCp+BBfeWrnFf07cuY
	 sg2a+ta5PRQSsHd/+wj6B7lo6peTRjALfWe+75cABqftU4hvZiyVpZpxRD1Y/Qg8k+
	 oftTuIZtm14FdksUBvrqDBt4btbmM4t0/4YGrW6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/186] tools: ynl: dont ignore errors in NLMSG_DONE messages
Date: Tue, 30 Apr 2024 12:38:30 +0200
Message-ID: <20240430103059.723738417@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit a44f2eb106a46f2275a79de54ce0ea63e4f3d8c8 ]

NLMSG_DONE contains an error code, it has to be extracted.
Prior to this change all dumps will end in success,
and in case of failure the result is silently truncated.

Fixes: e4b48ed460d3 ("tools: ynl: add a completely generic client")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://lore.kernel.org/r/20240420020827.3288615-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 13c4b019a881f..44ea0965c9d9c 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -201,6 +201,7 @@ class NlMsg:
             self.done = 1
             extack_off = 20
         elif self.nl_type == Netlink.NLMSG_DONE:
+            self.error = struct.unpack("i", self.raw[0:4])[0]
             self.done = 1
             extack_off = 4
 
-- 
2.43.0



