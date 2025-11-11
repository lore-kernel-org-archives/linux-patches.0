Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46234C97;
	Tue, 11 Nov 2025 00:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822297; cv=none; b=Cq9rkXX3YoiA77jW9g2Q1ROc2YR8hqK28EJKB0jMiTEbsLQPanDpB/IaCm0iDXhazcqVjjPy3W0zk0od7TMZYL0x413EEHQj666KwwRxaNbUmkiIvcqGQWymG8UtaZe4wHTo8ueX7wuBBM29Wkis2ExuYaGyupkq21DYiVooasE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822297; c=relaxed/simple;
	bh=jiPK9FqO1ObMpe/0Jl++MIDM4ndePBhE6BjeAd+zKHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah2cULRKa3N+nDdfZLVINX+Dg+hkseUWoA+rTFA9QigGfJP4o2cJEMOQ6hD8naqKoFGV1/LF0J3yUsx4nHOHNZ6zPq4oMkF5Sb4ttjbYc/eNK6vypHDnj37UTAfBYCUiRKEYqkGkxYkj+4zDIqzvJJ72YlcjB9PAUIUz1yIedY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ko0T+DaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ko0T+DaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FAEC4CEFB;
	Tue, 11 Nov 2025 00:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822296;
	bh=jiPK9FqO1ObMpe/0Jl++MIDM4ndePBhE6BjeAd+zKHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ko0T+DaOpQQYHqfM1PnnhEtXQiDT0VvXCmHH1VPzrr903srn4VUjO+dYEmTwql1OQ
	 hHl+LAvjYNd/VgdlH4WpBNCd3qLcwWHtMiEAeJJ3ZnOqUg0Oi5/FRNrsJZ3j2I0mTt
	 IhabfQY8IJspTFLGMmngYd5BztwpbNeSmeofuRHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 075/849] tools: ynl: avoid print_field when there is no reply
Date: Tue, 11 Nov 2025 09:34:05 +0900
Message-ID: <20251111004538.236032988@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit e3966940559d52aa1800a008dcfeec218dd31f88 ]

When request a none support device operation, there will be no reply.
In this case, the len(desc) check will always be true, causing print_field
to enter an infinite loop and crash the program. Example reproducer:

  # ethtool.py -c veth0

To fix this, return immediately if there is no reply.

Fixes: f3d07b02b2b8 ("tools: ynl: ethtool testing tool")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20251024125853.102916-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/pyynl/ethtool.py | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/net/ynl/pyynl/ethtool.py b/tools/net/ynl/pyynl/ethtool.py
index cab6b576c8762..87bb561080056 100755
--- a/tools/net/ynl/pyynl/ethtool.py
+++ b/tools/net/ynl/pyynl/ethtool.py
@@ -45,6 +45,9 @@ def print_field(reply, *desc):
     Pretty-print a set of fields from the reply. desc specifies the
     fields and the optional type (bool/yn).
     """
+    if not reply:
+        return
+
     if len(desc) == 0:
         return print_field(reply, *zip(reply.keys(), reply.keys()))
 
-- 
2.51.0



